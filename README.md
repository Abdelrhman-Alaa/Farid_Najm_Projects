# Farid_Najm_Projects
MATLAB Implementation of the computer project of "Circuit Simulation" book by Farid Najm
Chapter 1 Project: 
  Write a parser that can read a circuit specification in terms of a simple “language”:
    V<int> <node.+> <node.-> <value>
    I<int> <node.+> <node.-> <value> [G2]
    R<int> <node.+> <node.-> <value> [G2]
    C<int> <node.+> <node.-> <value> [G2]
    L<int> <node.+> <node.-> <value>
    D<int> <node.+> <node.-> [<value>]
    QN<int> <node.C> <node.B> <node.E> [<value>]
    QP<int> <node.C> <node.B> <node.E> [<value>]
    MN<int> <node.D> <node.G> <node.S> [<value>]
    MP<int> <node.D> <node.G> <node.S> [<value>]
Notes:
    Inputs between square brackets are optional. 
    Nodes must be consecutive numbers 0,1,...,n.
    Node 0 is ground.
Implementation: function parser.m
    Input: netlist file
    Output: MATLAB struct that contains all the circuit records.
    How to run: parser(netlist_name)
    Example: Circuit = parser('parser_test.txt');
