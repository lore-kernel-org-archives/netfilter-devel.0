From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] update for ROUTE target in Netfilter-Extension HOWTO
	[ENG][FR]
Date: 05 Mar 2003 16:17:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046877476.28140.86.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yeVNljv2gd1Zh2e7R1K8"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabrice MARIE <fabrice@celestix.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-yeVNljv2gd1Zh2e7R1K8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h25FEoIU001664

Hi Fabrice,

Here are two patches to update Netfilter-Extension HOWTO, concerning
the ROUTE target. The patches are against the english and french
versions of the sgml master.

The patches update the descriptions of the ROUTE options and move
the section so that it appears alphabetically (between the NETMAP
and the SAME patch sections).

Have a nice day,

C=E9dric



--=-yeVNljv2gd1Zh2e7R1K8
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.patch
Content-Type: text/plain; name=netfilter-extensions-HOWTO.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h25FEoIU001664

--- netfilter-extensions-HOWTO.sgml.orig	Sat Nov  9 10:30:38 2002
+++ netfilter-extensions-HOWTO.sgml	Wed Mar  5 16:07:54 2003
@@ -1088,6 +1088,95 @@
 <tag>--to address[/mask]</> -&gt; Network address to map to.
 </descrip>
=20
+<sect1>ROUTE patch
+<p>
+This patch by C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; adds =
a new=20
+target which allows you to setup unusual routes not supported by the=20
+standard kernel routing table. The ROUTE target lets you route=20
+a received packet through an interface or towards a host, even if the=20
+regular destination of the packet is the router itself. The ROUTE target=
 is=20
+also able to change the incoming interface of a packet. Packets are
+directly put on the wire and do not traverse any other table.
+
+<p>
+This target does not modify the packets and is a final target.
+It has to be used inside the mangle table.
+
+<p>
+Whenever possible, you should use the MARK target together with
+iproute2 instead of this ROUTE target. However, this target is useful
+to force the use of an interface or a next hop and to change the=20
+incoming interface of a packet. People also use it for easiness=20
+and to simplify their rules (one rule to route a packet is easier=20
+that one MARK rule + one iproute2 rule).
+
+<p>
+Options supported by the ROUTE target are :
+
+<descrip>
+<tag>--oif ifname</>
+Send the packet out using `ifname' network interface. The destination
+host must be on the same link or the interface must be a tunnel.
+Otherwise, arp resolution cannot be performed and the packet is dropped.
+<tag>--iif ifname</>
+Change the packet's incoming interface to `ifname'.
+<tag>--gw ip</>
+Route the packet via this gateway. The packet is routed as if
+its destination IP address was this ip.
+</descrip>
+
+
+<p>
+For example, assume that you want to redirect ssh packets towards a=20
+server inside your network, without modifying those packets in any way=20
+(this excludes the use of the standard port forwarding mechanism).
+A solution is to use an ipip tunnel and the ROUTE target to reroute ssh=20
+packets to the real ssh server, which has the same IP address as the rou=
ter.
+It is not possible to reroute those packets using the standard routing
+mechanisms, because the kernel locally delivers a packet having
+a destination address belonging to the router itself.
+
+<p>
+Time for ASCII art :
+<verb>
+              eth0  +------+ 192.168.0.1        192.168.0.2 +----+
+    ----------------|router|--------------------------------|host|
+    IP: 150.150.0.1 +------+                                +----+
+                       | | tunl1              IP: 150.150.0.1 | |
+                       | +------------------------------------+ |
+                       +----------------------------------------+
+                                      IPIP tunnel
+</verb>
+
+<p>
+For the example above, you can do as follows :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --=
oif tunl1
+# iptables -A PREROUTING -t mangle -i tunl1 -j ROUTE --oif eth0
+
+# iptables -L PREROUTING -t mangle
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh =
ROUTE oif tunl1
+ROUTE      all  --  anywhere             anywhere           ROUTE oif et=
h0
+</verb></tscreen>
+
+<p>
+Another example : if you want to quickly and easily balance the load bet=
ween two=20
+gateways 10.0.0.1 and 10.0.0.2, then you can do as follows :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t mangle -m random --average 50 -j ROUTE --gw =
10.0.0.1
+# iptables -A PREROUTING -t mangle -j ROUTE --gw 10.0.0.2
+
+# iptables -L PREROUTING -t mangle
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      all  --  anywhere             anywhere           random 50% R=
OUTE gw 10.0.0.1
+ROUTE      all  --  anywhere             anywhere           ROUTE gw 10.=
0.0.2
+</verb></tscreen>
+
 <sect1>SAME patch
 <p>
 This patch by Martin Josefsson &lt;gandalf@wlug.westbo.se&gt; adds a new=
 target
@@ -1184,74 +1273,6 @@
 Harald maintains a=20
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"web page"> c=
ontaining the proper documentation
 for ULOG, so there is no point for me to explain this here..
-
-<sect1>ROUTE patch
-<p>
-This patch by C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; adds =
a new target
-which allows you to directly route a packet towards a specified interfac=
e,
-even and especially if the packet IP address is one of the router itself=
.=20
-Since the kernel locally delivers those packets, they cannot be forwarde=
d to=20
-another computer using the standard routing mechanisms.
-Sometimes, this is useful to do that, without modifying the packets.
-
-<p>
-Options supported by the ROUTE target are :
-
-<descrip>
-<tag>--iface name</>
-Send the packet directly through the interface with the name specified.
-<tag>--ifindex index</>
-Send the packet directly through the interface with the index specified.
-</descrip>
-
-<p>
-For example, assume that you want to install a service, say ssh, on a=20
-computer inside your network. But, you also want this service to appear
-exactly as if it was located on the router itself, including the
-fact that the packets remain unmodified. This prevents us using the=20
-standard port forwarding mechanism.
-
-<p>
-A solution is to simply reroute packets with destination port 22 to the
-computer having the same IP as the router, and hosting the ssh service,
-thanks to this ROUTE target and an ipip tunnel.
-
-<p>
-Time for ASCII art :
-<verb>
-              eth0  +------+ 192.168.0.1        192.168.0.2 +----+
-    ----------------|router|--------------------------------|host|
-    IP: 150.150.0.1 +------+                                +----+
-                       | | tunl1              IP: 150.150.0.1 | |
-                       | +------------------------------------+ |
-                       +----------------------------------------+
-                                      IPIP tunnel
-</verb>
-<p>
-It is not possible to reroute those packets using the standard routing
-mechanisms, simply because the kernel thinks those packets should be=20
-locally delivered (they contain the IP address of the router itself).
-
-<p>
-The ROUTE target provides a way to do that. For our example above, we
-would add the following rules :
-
-<tscreen><verb>
-# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --=
iface tunl1
-# iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
-
-# iptables -L PREROUTING -t nat
-Chain PREROUTING (policy ACCEPT)
-target     prot opt source               destination        =20
-ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh =
ROUTE iface tunl1=20
-ROUTE      all  --  anywhere             anywhere           ROUTE iface =
eth0
-</verb></tscreen>
-
-<p>
-The first rule is for rerouting packet coming from the Internet, and the=
 second
-one is for rerouting all packets coming from the host. The ROUTE target =
can only
-be inserted inside the mangle table, in the PREROUTING chain.
-
=20
 <sect>New connection tracking patches
 <p>

--=-yeVNljv2gd1Zh2e7R1K8
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.FR.patch
Content-Type: text/plain; name=netfilter-extensions-HOWTO.FR.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h25FEoIU001664

--- netfilter-extensions-HOWTO.sgml.orig	Sat Nov  9 10:30:38 2002
+++ netfilter-extensions-HOWTO.sgml	Wed Mar  5 16:05:50 2003
@@ -1118,6 +1118,95 @@
 <tag>--to address[/mask]</> -&gt; L'adresse r=E9seau =E0 mapper.
 </descrip>
=20
+<sect1>Le patch ROUTE
+<p>
+Ce patch par C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; ajoute=
 une=20
+nouvelle target qui vous d'=E9tablir des routes particuli=E8res qui ne s=
ont pas
+support=E9es par la table de routage standard du noyau. La target ROUTE =
vous
+permet the router un paquet vers une interface ou un h=F4te, m=EAme si l=
a=20
+destination normale du paquet est le routeur lui-m=EAme. La target ROUTE=
 permet
+=E9galement de changer l'interface d'arriv=E9e d'un paquet. Les paquets =
sont
+envoy=E9s directement sur la ligne, sans traverser aucune autre table.
+
+<p>
+Cette target ne modifie jamais les paquets et est une target finale. Ell=
e
+doit =EAtre utilis=E9e dans la table `mangle'.
+
+<p>
+Lorsque c'est possible, il est pr=E9f=E9rable d'utiliser la target MARK =
coupl=E9e
+=E0 l'utilisation d'iproute2. Cette target ROUTE est cependant utile pou=
r forcer
+l'utilisation d'une interface ou d'une passerelle, et pour changer l'int=
erface
+d'arriv=E9e d'un paquet. Certaines personnes l'utilisent aussi par facil=
it=E9 et
+pour simplifier leur r=E8gles (une r=E8gle pour router un paquet est plu=
s facile
+qu'une r=E8gle MARK + une r=E8gle iproute2).
+
+<p>
+Les options support=E9es par la target ROUTE sont :
+
+<descrip>
+<tag>--oif ifname</>
+Envoie le paquet en utilisant l'interface de nom `ifname'. La machine de
+destination doit =EAtre sur le m=EAme lien, ou bien l'interface doit =EA=
tre un tunnel.
+Dans le cas contraire, la r=E9solution arp ne peut se faire et le paquet=
 est
+jet=E9.
+<tag>--iif ifname</>
+Modifie l'interface d'arriv=E9e du packet en l'interface `ifname'.
+<tag>--gw ip</>
+Route le paquet via cette passerelle. Le paquet est rout=E9 comme si son
+adresse IP de destination =E9tait cette ip.
+</descrip>
+
+<p>
+Supposons par exemple que vous voulez rediriger les paquets ssh vers un =
serveur
+situ=E9 =E0 l'int=E9rieur de votre r=E9seau, sans modifier ces paquets (=
ceci exclu
+l'utilisation de la technique de redirection de port).
+Une solution est d'utiliser un tunnel ipip et la target ROUTE pour rerou=
ter les
+paquets ssh vers le vrai serveur ssh, qui a la m=EAme adresse IP que le =
routeur.
+Il n'est pas possible de rerouter ces paquets en utilisant la table de r=
outage
+du noyau car le noyau d=E9livre localement les paquets ayant une adresse
+de destination appartenant au routeur lui-m=EAme.
+
+<p>
+Un peu d'art ASCII :
+<verb>
+              eth0  +-------+ 192.168.0.1         192.168.0.2 +----+
+    ----------------|routeur|---------------------------------|h=F4te|
+    IP: 150.150.0.1 +-------+                                 +----+
+                       | | tunl1               IP: 150.150.0.1 | |
+                       | +-------------------------------------+ |
+                       +-----------------------------------------+
+                                      tunnel IPIP
+</verb>
+
+<p>
+Pour l'exemple ci-dessus, vous pouvez faire comme suit :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --=
oif tunl1
+# iptables -A PREROUTING -t mangle -i tunl1 -j ROUTE --oif eth0
+
+# iptables -L PREROUTING -t mangle
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh =
ROUTE oif tunl1
+ROUTE      all  --  anywhere             anywhere           ROUTE oif et=
h0
+</verb></tscreen>
+
+<p>
+Autre exemple : si vous voulez facilement et rapidement r=E9partir la ch=
arge entre
+deux passerelles 10.0.0.1 et 10.0.0.2, faites comme suit :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t mangle -m random --average 50 -j ROUTE --gw =
10.0.0.1
+# iptables -A PREROUTING -t mangle -j ROUTE --gw 10.0.0.2
+
+# iptables -L PREROUTING -t mangle
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      all  --  anywhere             anywhere           random 50% R=
OUTE gw 10.0.0.1
+ROUTE      all  --  anywhere             anywhere           ROUTE gw 10.=
0.0.2
+</verb></tscreen>
+
 <sect1>Le patch SAME
 <p>
 Ce patch par Martin Josefsson &lt;gandalf@wlug.westbo.se&gt; ajoute une =
nouvelle
@@ -1215,76 +1304,6 @@
 Harald maintient une
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"page web"> c=
ontenant de la documentation
 sur l'utilisation de la target ULOG ainsi que sur la librairie, et donc =
on ne l'expliquera pas ici..
-
-<sect1>Le patch ROUTE
-<p>
-Ce patch par C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; ajoute=
 une nouvelle target
-qui vous permet de directement router un paquet entrant vers une interfa=
ce que vous sp=E9cifiez.
-Ceci peut se faire m=EAme, et en particulier, si l'adresse IP de destina=
tion est une des adresses=20
-du routeur lui-m=EAme. D'habitude, le kernel d=E9livre ces paquets local=
ement. Ils ne peuvent donc=20
-=EAtre rout=E9s vers un autre ordinateur en utilisant les m=E9canismes s=
tandards de routage.
-Parfois, il s'av=E8re utile de le faire, tout en conservant l'int=E9grit=
=E9 des paquets.
-
-<p>
-Les options support=E9es par la target ROUTE sont :
-
-<descrip>
-<tag>--iface name</>
-Envoie le paquet directement vers l'interface de nom &lt;name&gt;.
-<tag>--ifindex index</>
-Envoie le paquet directement vers l'interface dont l'index est sp=E9cifi=
=E9.
-Ceci est utile lorsque vous voulez supprimer une r=E8gle concernant une =
interface qui
-n'existe plus (par exemple si c'est un tunnel qui a =E9t=E9 d=E9truit en=
tretemps).
-</descrip>
-
-<p>
-Supposons par exemple que vous d=E9sirez installer un service, disons ss=
h, sur un
-ordinateur de votre r=E9seau interne. Vous voulez cependant que ce servi=
ce apparaisse
-exactement comme s'il se situait sur le routeur lui-m=EAme, y compris le=
 fait que les
-paquets ne soient pas modifi=E9s. Ceci ne nous permet donc pas d'utilise=
r le m=E9canisme
-standard de redirection de port.
-
-<p>
-Une solution est de simplement rerouter les paquets dont le port de dest=
ination est 22
-vers l'ordinateur ayant la m=EAme adresse que le routeur, et h=E9bergean=
t le serveur ssh.
-Ceci peut se faire gr=E2ce =E0 cette target ROUTE, en utilisant un tunne=
l IPIP.
-
-<p>
-Un peu d'art ASCII :
-<verb>
-              eth0  +-------+ 192.168.0.1         192.168.0.2 +----+
-    ----------------|routeur|---------------------------------|h=F4te|
-    IP: 150.150.0.1 +-------+                                 +----+
-                       | | tunl1               IP: 150.150.0.1 | |
-                       | +-------------------------------------+ |
-                       +-----------------------------------------+
-                                      tunnel IPIP
-</verb>
-<p>
-Il n'est pas possible de rerouter ces paquets en utilisant les m=E9canis=
mes standards
-de routage, tout simplement parce que le kernel pense que ces paquets do=
ivent =EAtre
-d=E9livr=E9s localement (ils contiennent l'adresse IP du routeur lui-m=EA=
me).
-
-<p>
-La target ROUTE fournit un moyen de le faire. Pour notre exemple, nous r=
ajouterions
-les r=E8gles suivantes :
-
-<tscreen><verb>
-# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --=
iface tunl1
-# iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
-
-# iptables -L PREROUTING -t nat
-Chain PREROUTING (policy ACCEPT)
-target     prot opt source               destination        =20
-ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh =
ROUTE iface tunl1
-ROUTE      all  --  anywhere             anywhere           ROUTE iface =
eth0
-</verb></tscreen>
-
-<p>
-La premi=E8re r=E8gle reroute les paquets venant de l'Internet et les en=
voie dans le tunnel.
-La seconde r=E8gle reroute vers l'Internet tous les paquets venant de l'=
h=F4te (c'est-=E0-dire
-les paquets sortant du tunnel). Cette target ne peut =EAtre ins=E9r=E9e =
que dans la table
-`mangle', dans la cha=EEne PREROUTING.
=20
 <sect>Les nouveaux patches de suivi de connexion
 <p>

--=-yeVNljv2gd1Zh2e7R1K8--
