From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] update for ROUTE target in Netfilter-Extension HOWTO
	[ENG][FR]
Date: 20 Sep 2002 15:19:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032527991.15787.18.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kXS3HyfiNhDAfsSPa8KD"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-kXS3HyfiNhDAfsSPa8KD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Fabrice,

Here are two patches to update the Netfilter-Extension HOWTO, concerning
the ROUTE target.

The first one [netfilter-extensions-HOWTO.sgml.PATCH] is against
the english version of the sgml master.
The second patch is against [netfilter-extensions-HOWTO.sgml.PATCH-FR]
is against the french version.

C=E9dric


--=-kXS3HyfiNhDAfsSPa8KD
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.sgml.PATCH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-diff; charset=ISO-8859-15

--- netfilter-extensions-HOWTO.sgml.orig	Wed Jul 24 11:05:14 2002
+++ netfilter-extensions-HOWTO.sgml	Fri Sep 20 14:52:06 2002
@@ -1093,8 +1093,6 @@
 Send the packet directly through the interface with the name specified.
 <tag>--ifindex index</>
 Send the packet directly through the interface with the index specified.
-This is Useful when you want to remove a rule with an interface which does=
n't
-exist anymore (e.g. a tunnel which has been destroyed).
 </descrip>
=20
 <p>
@@ -1106,7 +1104,7 @@
=20
 <p>
 A solution is to simply reroute packets with destination port 22 to the
-computer having the same IP as the router and hosting the ssh service,
+computer having the same IP as the router, and hosting the ssh service,
 thanks to this ROUTE target and an ipip tunnel.
=20
 <p>
@@ -1130,22 +1128,21 @@
 would add the following rules :
=20
 <tscreen><verb>
-# iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE --iface=
 tunl1
-# iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --if=
ace tunl1
+# iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
=20
 # iptables -L PREROUTING -t nat
 Chain PREROUTING (policy ACCEPT)
 target     prot opt source               destination        =20
-ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh RO=
UTE iface tunl1(7)=20
-ROUTE      all  --  anywhere             anywhere           ROUTE iface et=
h0(3)=20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh RO=
UTE iface tunl1=20
+ROUTE      all  --  anywhere             anywhere           ROUTE iface et=
h0
 </verb></tscreen>
=20
 <p>
 The first rule is for rerouting packet coming from the Internet, and the s=
econd
-one is for rerouting all packets coming from the host. The value shown ins=
ide parentheses
-after the interface name is the interface index. We use the nat table
-because this table provides a PREROUTING hook, but this does not imply any=
 packet
-alteration.=20
+one is for rerouting all packets coming from the host. The ROUTE target ca=
n only
+be inserted inside the mangle table, in the PREROUTING chain.
+
=20
 <sect>New connection tracking patches
 <p>

--=-kXS3HyfiNhDAfsSPa8KD
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.sgml.PATCH-FR
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-15

--- netfilter-extensions-HOWTO.sgml.orig	Wed Jul 24 11:05:14 2002
+++ netfilter-extensions-HOWTO.sgml	Fri Sep 20 14:55:45 2002
@@ -1129,7 +1129,7 @@
=20
 <p>
 Une solution est de simplement rerouter les paquets dont le port de destin=
ation est 22
-vers l'ordinateur ayant la m=EAme adresse que le routeur, et habritant le =
serveur ssh.
+vers l'ordinateur ayant la m=EAme adresse que le routeur, et h=E9bergeant =
le serveur ssh.
 Ceci peut se faire gr=E2ce =E0 cette target ROUTE, en utilisant un tunnel =
IPIP.
=20
 <p>
@@ -1153,23 +1153,21 @@
 les r=E8gles suivantes :
=20
 <tscreen><verb>
-# iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j ROUTE --iface=
 tunl1
-# iptables -A PREROUTING -t nat -i tunl1 --j ROUTE --iface eth0
+# iptables -A PREROUTING -t mangle -i eth0 -p tcp --dport 22 -j ROUTE --if=
ace tunl1
+# iptables -A PREROUTING -t mangle -i tunl1 --j ROUTE --iface eth0
=20
 # iptables -L PREROUTING -t nat
 Chain PREROUTING (policy ACCEPT)
 target     prot opt source               destination        =20
-ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh RO=
UTE iface tunl1(7)=20
-ROUTE      all  --  anywhere             anywhere           ROUTE iface et=
h0(3)=20
+ROUTE      tcp  --  anywhere             anywhere           tcp dpt:ssh RO=
UTE iface tunl1
+ROUTE      all  --  anywhere             anywhere           ROUTE iface et=
h0
 </verb></tscreen>
=20
 <p>
 La premi=E8re r=E8gle reroute les paquets venant de l'Internet et les envo=
ie dans le tunnel.
 La seconde r=E8gle reroute vers l'Internet tous les paquets venant de l'h=
=F4te (c'est-=E0-dire
-les paquets sortant du tunnel). La valeur indiqu=E9e entre parenth=E8ses a=
pr=E8s le nom
-de l'interface est l'index de celle-ci. Nous utilisons la table nat parce =
qu'elle
-fournit une cha=EEne PREROUTING, mais ceci n'implique aucunement une modif=
ication des
-paquets.
+les paquets sortant du tunnel). Cette target ne peut =EAtre ins=E9r=E9e qu=
e dans la table
+'mangle', dans la cha=EEne PREROUTING.
=20
 <sect>Les nouveaux patches de suivi de connexion
 <p>

--=-kXS3HyfiNhDAfsSPa8KD--
