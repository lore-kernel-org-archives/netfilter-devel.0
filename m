From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] netfilter-extensions-HOWTO.sgml FRENCH VERSION updated for
	ROUTE target
Date: 17 Jun 2002 17:50:53 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024329053.11604.39.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-IPeyqyoOnOi8ahSLQMG6"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-IPeyqyoOnOi8ahSLQMG6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi again,

Here's now the FRENCH VERSION of the previous patch.
It is now to apply on

  /cvsroot/netfilter/HOWTO/fr/netfilter-extensions-HOWTO.sgml

C=E9dric

--- netfilter-extensions-HOWTO.sgml.orig	Tue May 14 08:58:14 2002
+++ netfilter-extensions-HOWTO.sgml	Mon Jun 17 17:44:09 2002
@@ -1064,6 +1064,78 @@
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"page web">
contenant de la documentation
 sur l'utilisation de la target ULOG ainsi que sur la librairie, et donc
on ne l'expliquera pas ici..
=20
+<sect1>Le patch ROUTE
+<p>
+Ce patch par C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; ajoute
une nouvelle target
+qui vous permet de directement router un paquet entrant vers une
interface que vous sp=E9cifiez.
+Ceci peut se faire m=EAme, et en particulier, si l'adresse IP de
destination est une des adresses=20
+du routeur lui-m=EAme. D'habitude, le kernel d=E9livre ces paquets
localement. Ils ne peuvent donc=20
+=EAtre rout=E9s vers un autre ordinateur en utilisant les m=E9canismes
standards de routage.
+Parfois, il s'av=E8re utile de le faire, tout en conservant l'int=E9grit=
=E9
des paquets.
+
+<p>
+Les options support=E9es par la target ROUTE sont :
+
+<descrip>
+<tag>--iface name</>
+Envoie le paquet directement vers l'interface de nom &lt;name&gt;.
+<tag>--ifindex index</>
+Envoie le paquet directement vers l'interface dont l'index est
sp=E9cifi=E9.
+Ceci est utile lorsque vous voulez supprimer une r=E8gle concernant une
interface qui
+n'existe plus (par exemple si c'est un tunnel qui a =E9t=E9 d=E9truit
entretemps).
+</descrip>
+
+<p>
+Supposons par exemple que vous d=E9sirez installer un service, disons
ssh, sur un
+ordinateur de votre r=E9seau interne. Vous voulez cependant que ce
service apparaisse
+exactement comme s'il se situait sur le routeur lui-m=EAme, y compris le
fait que les
+paquets ne soient pas modifi=E9s. Ceci ne nous permet donc pas d'utiliser
le m=E9canisme
+standard de redirection de port.
+
+<p>
+Une solution est de simplement rerouter les paquets dont le port de
destination est 22
+vers l'ordinateur ayant la m=EAme adresse que le routeur, et habritant le
serveur ssh.
+Ceci peut se faire gr=E2ce =E0 cette target ROUTE, en utilisant un tunnel
IPIP.
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
+<p>
+Il n'est pas possible de rerouter ces paquets en utilisant les
m=E9canismes standards
+de routage, tout simplement parce que le kernel pense que ces paquets
doivent =EAtre
+d=E9livr=E9s localement (ils contiennent l'adresse IP du routeur lui-m=EAm=
e).
+
+<p>
+La target ROUTE fournit un moyen de le faire. Pour notre exemple, nous
rajouterions
+les r=E8gles suivantes :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE
--iface tunl1
+# iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+
+# iptables -L PREROUTING -t nat
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh
ROUTE iface tunl1(7)=20
+ROUTE      all  --  anywhere             anywhere           ROUTE iface
eth0(3)=20
+</verb></tscreen>
+
+<p>
+La premi=E8re r=E8gle reroute les paquets venant de l'Internet et les
envoie dans le tunnel.
+La seconde r=E8gle reroute vers l'Internet tous les paquets venant de
l'h=F4te (c'est-=E0-dire
+les paquets sortant du tunnel). La valeur indiqu=E9e entre parenth=E8ses
apr=E8s le nom
+de l'interface est l'index de celle-ci. Nous utilisons la table nat
parce qu'elle
+fournit une cha=EEne PREROUTING, mais ceci n'implique aucunement une
modification des
+paquets.
+
 <sect>Les nouveaux patches de suivi de connexion
 <p>
 Dans cette section, nous allons montrer les diff=E9rents patches =E0
disposition pour


--=-IPeyqyoOnOi8ahSLQMG6
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-diff; charset=ISO-8859-15

--- netfilter-extensions-HOWTO.sgml.orig	Tue May 14 08:58:14 2002
+++ netfilter-extensions-HOWTO.sgml	Mon Jun 17 17:44:09 2002
@@ -1064,6 +1064,78 @@
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"page web"> con=
tenant de la documentation
 sur l'utilisation de la target ULOG ainsi que sur la librairie, et donc on=
 ne l'expliquera pas ici..
=20
+<sect1>Le patch ROUTE
+<p>
+Ce patch par C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; ajoute u=
ne nouvelle target
+qui vous permet de directement router un paquet entrant vers une interface=
 que vous sp=E9cifiez.
+Ceci peut se faire m=EAme, et en particulier, si l'adresse IP de destinati=
on est une des adresses=20
+du routeur lui-m=EAme. D'habitude, le kernel d=E9livre ces paquets localem=
ent. Ils ne peuvent donc=20
+=EAtre rout=E9s vers un autre ordinateur en utilisant les m=E9canismes sta=
ndards de routage.
+Parfois, il s'av=E8re utile de le faire, tout en conservant l'int=E9grit=
=E9 des paquets.
+
+<p>
+Les options support=E9es par la target ROUTE sont :
+
+<descrip>
+<tag>--iface name</>
+Envoie le paquet directement vers l'interface de nom &lt;name&gt;.
+<tag>--ifindex index</>
+Envoie le paquet directement vers l'interface dont l'index est sp=E9cifi=
=E9.
+Ceci est utile lorsque vous voulez supprimer une r=E8gle concernant une in=
terface qui
+n'existe plus (par exemple si c'est un tunnel qui a =E9t=E9 d=E9truit entr=
etemps).
+</descrip>
+
+<p>
+Supposons par exemple que vous d=E9sirez installer un service, disons ssh,=
 sur un
+ordinateur de votre r=E9seau interne. Vous voulez cependant que ce service=
 apparaisse
+exactement comme s'il se situait sur le routeur lui-m=EAme, y compris le f=
ait que les
+paquets ne soient pas modifi=E9s. Ceci ne nous permet donc pas d'utiliser =
le m=E9canisme
+standard de redirection de port.
+
+<p>
+Une solution est de simplement rerouter les paquets dont le port de destin=
ation est 22
+vers l'ordinateur ayant la m=EAme adresse que le routeur, et habritant le =
serveur ssh.
+Ceci peut se faire gr=E2ce =E0 cette target ROUTE, en utilisant un tunnel =
IPIP.
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
+<p>
+Il n'est pas possible de rerouter ces paquets en utilisant les m=E9canisme=
s standards
+de routage, tout simplement parce que le kernel pense que ces paquets doiv=
ent =EAtre
+d=E9livr=E9s localement (ils contiennent l'adresse IP du routeur lui-m=EAm=
e).
+
+<p>
+La target ROUTE fournit un moyen de le faire. Pour notre exemple, nous raj=
outerions
+les r=E8gles suivantes :
+
+<tscreen><verb>
+# iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE --iface=
 tunl1
+# iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+
+# iptables -L PREROUTING -t nat
+Chain PREROUTING (policy ACCEPT)
+target     prot opt source               destination        =20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh RO=
UTE iface tunl1(7)=20
+ROUTE      all  --  anywhere             anywhere           ROUTE iface et=
h0(3)=20
+</verb></tscreen>
+
+<p>
+La premi=E8re r=E8gle reroute les paquets venant de l'Internet et les envo=
ie dans le tunnel.
+La seconde r=E8gle reroute vers l'Internet tous les paquets venant de l'h=
=F4te (c'est-=E0-dire
+les paquets sortant du tunnel). La valeur indiqu=E9e entre parenth=E8ses a=
pr=E8s le nom
+de l'interface est l'index de celle-ci. Nous utilisons la table nat parce =
qu'elle
+fournit une cha=EEne PREROUTING, mais ceci n'implique aucunement une modif=
ication des
+paquets.
+
 <sect>Les nouveaux patches de suivi de connexion
 <p>
 Dans cette section, nous allons montrer les diff=E9rents patches =E0 dispo=
sition pour

--=-IPeyqyoOnOi8ahSLQMG6--
