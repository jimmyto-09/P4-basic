from mininet.topo import Topo

class SimpleTopo(Topo):
    def build(self):
        h1 = self.addHost('h1', ip='10.0.0.1/8', mac='00:00:00:00:00:01')
        h2 = self.addHost('h2', ip='10.0.0.2/8', mac='00:00:00:00:00:02')
        s1 = self.addSwitch('s1')  # switch P4/BMv2

        self.addLink(h1, s1)
        self.addLink(h2, s1)

topos = {
    'simpletopo': (lambda: SimpleTopo())
}
