From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: [PATCH] netfilter-extensions-HOWTO.sgml updated for ROUTE target
Date: 17 Jun 2002 15:52:29 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024321950.11605.25.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-zrenJLJJv91i+aFwAwom"
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


--=-zrenJLJJv91i+aFwAwom
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Here's a patch to update the netfilter-extensions-HOWTO.sgml=20
(english version) for the new ROUTE target.

I'm planning to also update the french version of this HOWTO=20
since it's my mother tongue.

The patch is to apply on

  /cvsroot/netfilter/HOWTO/netfilter-extensions-HOWTO.sgml

Cedric de Launois

--- netfilter-extensions-HOWTO.sgml.orig	Mon Jun 17 12:50:44 2002
+++ netfilter-extensions-HOWTO.sgml	Mon Jun 17 15:26:43 2002
@@ -1043,6 +1043,77 @@
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"web page">
containing the proper documentation
 for ULOG, so there is no point for me to explain this here..
=20
+<sect1>ROUTE patch
+<p>
+This patch by C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; adds a
new target
+which allows you to directly route a packet towards a specified
interface,
+even and especially if the packet IP address is one of the router
itself.=20
+Since the kernel locally delivers those packets, they cannot be
forwarded to=20
+another computer using the standard routing mechanisms.
+Sometimes, this is useful to do that, without modifying the packets.
+
+<p>
+Options supported by the ROUTE target are :
+
+<descrip>
+<tag>--iface name</>
+Send the packet directly through the interface with the name specified.
+<tag>--ifindex index</>
+Send the packet directly through the interface with the index
specified.
+This is Useful when you want to remove a rule with an interface which
doesn't
+exist anymore (e.g. a tunnel which has been destroyed).
+</descrip>
+
+<p>
+For example, assume that you want to install a service, say ssh, on a=20
+computer inside your network. But, you also want this service to appear
+exactly as if it was located on the router itself, including the
+fact that the packets remain unmodified. This prevents us using the=20
+standard port forwarding mechanism.
+
+<p>
+A solution is to simply reroute packets with destination port 22 to the
+computer having the same IP as the router and hosting the ssh service,
+thanks to this ROUTE target and an ipip tunnel.
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
+<p>
+It is not possible to reroute those packets using the standard routing
+mechanisms, simply because the kernel thinks those packets should be=20
+locally delivered (they contain the IP address of the router itself).
+
+<p>
+The ROUTE target provides a way to do that. For our example above, we
+would add the following rules :
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
+The first rule is for rerouting packet coming from the Internet, and
the second
+one is for rerouting all packets coming from the host. The value shown
inside parentheses
+after the interface name is the interface index. We use the nat table
+because this table provides a PREROUTING hook, but this does not imply
any packet
+alteration.=20
+
 <sect>New connection tracking patches
 <p>
 In this sections, we will show the available connection tracking/nat
patches.


--=-zrenJLJJv91i+aFwAwom
Content-Disposition: attachment; filename=netfilter-extensions-HOWTO.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-diff; charset=ISO-8859-15

--- netfilter-extensions-HOWTO.sgml.orig	Mon Jun 17 12:50:44 2002
+++ netfilter-extensions-HOWTO.sgml	Mon Jun 17 15:26:43 2002
@@ -1043,6 +1043,77 @@
 <url url=3D"http://www.gnumonks.org/projects/ulogd" name=3D"web page"> con=
taining the proper documentation
 for ULOG, so there is no point for me to explain this here..
=20
+<sect1>ROUTE patch
+<p>
+This patch by C=E9dric de Launois &lt;delaunois@info.ucl.ac.be&gt; adds a =
new target
+which allows you to directly route a packet towards a specified interface,
+even and especially if the packet IP address is one of the router itself.=20
+Since the kernel locally delivers those packets, they cannot be forwarded =
to=20
+another computer using the standard routing mechanisms.
+Sometimes, this is useful to do that, without modifying the packets.
+
+<p>
+Options supported by the ROUTE target are :
+
+<descrip>
+<tag>--iface name</>
+Send the packet directly through the interface with the name specified.
+<tag>--ifindex index</>
+Send the packet directly through the interface with the index specified.
+This is Useful when you want to remove a rule with an interface which does=
n't
+exist anymore (e.g. a tunnel which has been destroyed).
+</descrip>
+
+<p>
+For example, assume that you want to install a service, say ssh, on a=20
+computer inside your network. But, you also want this service to appear
+exactly as if it was located on the router itself, including the
+fact that the packets remain unmodified. This prevents us using the=20
+standard port forwarding mechanism.
+
+<p>
+A solution is to simply reroute packets with destination port 22 to the
+computer having the same IP as the router and hosting the ssh service,
+thanks to this ROUTE target and an ipip tunnel.
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
+<p>
+It is not possible to reroute those packets using the standard routing
+mechanisms, simply because the kernel thinks those packets should be=20
+locally delivered (they contain the IP address of the router itself).
+
+<p>
+The ROUTE target provides a way to do that. For our example above, we
+would add the following rules :
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
+The first rule is for rerouting packet coming from the Internet, and the s=
econd
+one is for rerouting all packets coming from the host. The value shown ins=
ide parentheses
+after the interface name is the interface index. We use the nat table
+because this table provides a PREROUTING hook, but this does not imply any=
 packet
+alteration.=20
+
 <sect>New connection tracking patches
 <p>
 In this sections, we will show the available connection tracking/nat patch=
es.

--=-zrenJLJJv91i+aFwAwom--
