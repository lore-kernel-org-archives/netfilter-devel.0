From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] trivial patch for TCPLAG iptables version
Date: Wed, 16 Mar 2005 14:07:00 +0100
Message-ID: <1110978420.5786.9.camel@scaramouche>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-O0a5R8SM8XBd0vzK+IEL"
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-O0a5R8SM8XBd0vzK+IEL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

iptables/extensions/libipt_TCPLAG.c from svn requires
iptables version 1.2.3 in its struct iptables_target, so
the TCPLAG target cannot be used from iptables other than
1.2.3.

The attached trivial patch sets .version to IPTABLES_VERSION,
just as all the other libipt_*.c matches have.

Regards,
Torsten L=FCttgert <t.luettgert@pressestimmen.de>


--=-O0a5R8SM8XBd0vzK+IEL
Content-Disposition: attachment; filename=TCPLAG.patch
Content-Type: text/x-patch; name=TCPLAG.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

--- extensions/libipt_TCPLAG.c	(revision 3795)
+++ extensions/libipt_TCPLAG.c	(working copy)
@@ -195,7 +195,7 @@
 {
 next:	          0,
 name:             "TCPLAG",
-version:          "1.2.3",
+version:          IPTABLES_VERSION,
 size:             IPT_ALIGN( sizeof( struct ipt_tcplag )),
 userspacesize:    IPT_ALIGN( sizeof( struct ipt_tcplag )),
 help:             &help,

--=-O0a5R8SM8XBd0vzK+IEL--
