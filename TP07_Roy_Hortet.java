import static choco.Choco.*;
import choco.cp.model.CPModel;
import choco.cp.solver.CPSolver;
import choco.kernel.model.variables.integer.IntegerVariable;

public class Mobile {
	//longueurs
	private int l1, l2, l3, l4;
	//dernieres valeurs trouvees pour les masses
	private int m1, m2, m3;
	//masse maximum disponible
	private int masse_max;

	// variables des contraintes sur les longueurs
	private CPModel myModelL;
	private CPSolver mySolverL;
	
	private boolean coherent;//vrai si les longueurs sont coherentes

	// pour poser le probleme des longueurs
	IntegerVariable lg1, lg2, lg3, lg4; 
	    
	// variables des contraintes sur les masses
	private CPModel myModelM;
	private CPSolver mySolverM;
	
	private boolean equilibre;
	
  // pour poser le probleme des masses
	IntegerVariable mg1, mg2, mg3; 

	// constructeur : _lx : longeur de la branche x, m_max : masse maximum disponible
	public Mobile(int _l1, int _l2, int _l3, int _l4, int m_max) {
		l1 = _l1;
		l2 = _l2;
		l3 = _l3;
		l4 = _l4;
		
		masse_max = m_max;
		
		myModelL = new CPModel();
		myModelM = new CPModel();
		mySolverL = new CPSolver();
		mySolverM = new CPSolver();
		
		coherent = false;
		equilibre = false;
		poseProblemeLongeur();
		poseProblemeMasse();
	}

	public boolean estEquilibre() {
		return equilibre;
	}

	// accesseurs
	public int getL1() {
		return l1;
	}

	public int getL2() {
		return l2;
	}

	public int getL3() {
		return l3;
	}

	public int getL4() {
		return l4;
	}

	public int getM1() {
		return m1;
	}

	public int getM2() {
		return m2;
	}

	public int getM3() {
		return m3;
	}

	// pose le probleme des longeurs (sans le resoudre),
	// Les longueurs sont coherentes si le mobile est libre
	// (remarque : un peu artificiel car faisable en java 
	// sans contraintes !)
	  private void poseProblemeLongeur() {

	    lg1 = makeConstantVar("l1", l1);
	    lg2 = makeConstantVar("l2", l2);
	    lg3 = makeConstantVar("l3", l3);
	    lg4 = makeConstantVar("l4", l4);
	    
	    myModelL.addConstraint(lt(lg3,plus(lg1,lg2)));
	    myModelL.addConstraint(lt(lg4,plus(lg1,lg2)));
	}

	// verifie la coherence des longueurs
	public boolean longueursCoherentes() {
		mySolverL.read(myModelL);
		coherent = mySolverL.solve();
		return coherent;
	}

	// pose le probleme des masses (sans le resoudre)
	private void poseProblemeMasse() {
		  mg1 = makeIntVar("m1", 1, masse_max);
		  mg2 = makeIntVar("m2", 1, masse_max);
		  mg3 = makeIntVar("m3", 1, masse_max);
		  
		  IntegerVariable tab[] = {mg1, mg2, mg3};
		  myModelM.addConstraint(allDifferent(tab));
		  
		  myModelM.addConstraint(eq(mult(mg2,lg3),mult(mg3,lg4)));
		  myModelM.addConstraint(eq(mult(mg1,lg1),mult(plus(mg2,mg3),lg2)));
	}

	// resoud le probleme des masses
	// la resolution n'est lancee que si l'encombrement est coherent
	public boolean equilibre() {
		if (!coherent)
		  return false;
		  
		mySolverM.read(myModelM);
		equilibre = mySolverM.solve();
		
		m1 = mySolverM.getVar(mg1).getVal();
		m2 = mySolverM.getVar(mg2).getVal();
		m3 = mySolverM.getVar(mg3).getVal();
		
		return equilibre;
	}

	// cherche une autre solution pour les masses
	// la recherche d'une autre solution ne doit etre lancee que si le mobile est equilibre
	public boolean autreSolutionMasse() {
		if (!equilibre)
		  return false;
		  
		  equilibre = mySolverM.nextSolution();
		  
		  m1 = mySolverM.getVar(mg1).getVal();
	  	m2 = mySolverM.getVar(mg2).getVal();
	  	m3 = mySolverM.getVar(mg3).getVal();
		  
		return equilibre;
	}

	//gestion de l'affichage
	public String toString() {
		String res = "l1 = " + l1 + "\n l2 = " + l2 + "\n l3 = " + l3
				+ "\n l4 = " + l4;
		if (equilibre) {
			res += "\n m1 = " + m1 + "\n m2 = " + m2 + "\n m3 = " + m3;
		} else {
			res += "\n masses pas encore trouvees ou impossibles !";
		}
		return res;
	}

	//tests
	public static void main(String[] args) {
		Mobile m = new Mobile(1, 3, 2, 1, 20);
		//tester avec (1,1,2,3,20),(1,3,1,1,20),(1,3,2,1,20)
		System.out.println(m);
		if (m.longueursCoherentes()) {
			System.out.println("Encombrement OK");
			m.equilibre();
			System.out.println(m);
			while (m.autreSolutionMasse()) {
				System.out.println("OU");
				System.out.println(m);
			}
		} else {
			System.out.println("Encombrement pas coherent !");
		}
	}
}
