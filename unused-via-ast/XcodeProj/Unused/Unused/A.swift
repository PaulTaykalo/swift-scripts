import Foundation

class A {} // unused
class B {} // unused

class C {} // used by inheritance
class D: C {} // unused

protocol E {} // unused
protocol F {} // used by inheritance
protocol G: F {} // unused

