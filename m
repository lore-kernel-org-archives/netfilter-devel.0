From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Sat, 10 Sep 2005 09:38:43 +0200
Message-ID: <20050910073842.GA4314@rama.de.gnumonks.org>
References: <m2zmqoscc5.fsf@cerbere.dyndns.info>
	<m2slwgsc4p.fsf@cerbere.dyndns.info>
	<431F7B26.4040302@netfilter.org> <431F7C38.50206@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Cc: netfilter-devel@lists.netfilter.org,
	Samir Bellabes <sbellabes@mandriva.com>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <431F7C38.50206@netfilter.org>
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


--EP0wieDxd4TSJjHq
Content-Type: multipart/mixed; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dave, please consider the appended patch.

On Thu, Sep 08, 2005 at 01:48:08AM +0200, Pablo Neira wrote:
> Pablo Neira wrote:
> >Samir Bellabes wrote:
> >>     for (i =3D 0; i < ports_c; i++) {
> >>+        /* don't allow bad port values */
> >>+        if (ports[i] < 1 || ports[i] > 65535) {
> >>+            printk(KERN_WARNING "ip_ct_ftp: ERROR port"
> >>+                   "should be between 1 and 65535\n");
> >>+            fini();
> >>+            return -EINVAL;
> >>+        }
> >Better something like this?
>=20
> Damn, sorry, my mail client has mangled the email, I meant:
>=20
> -static int ports[MAX_PORTS];
> +static short ports[MAX_PORTS];
> static int ports_c;
> -module_param_array(ports,int, &ports_c, 0400);
> +module_param_array(ports, short, &ports_c, 0400);

I agree, it looks cleaner than the explicit checks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="54-ports-short.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER] Don't allow port numbers > 65535

This patch is the result of comments from Samir Bellabas and Pablo Neira.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 707a1ddcc1aed83c3c5283925635d6a8982363f1
tree 62fdc65b0c508f43e0182939274ea6b6848d6f2d
parent 49f4a3e845089f9d90e7b481e1bb72ab217d69f5
author Harald Welte <laforge@netfilter.org> Sa, 10 Sep 2005 09:37:22 +0200
committer Harald Welte <laforge@netfilter.org> Sa, 10 Sep 2005 09:37:22 +02=
00

 net/ipv4/netfilter/ip_conntrack_ftp.c  |    4 ++--
 net/ipv4/netfilter/ip_conntrack_irc.c  |    4 ++--
 net/ipv4/netfilter/ip_conntrack_tftp.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_=
conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -29,9 +29,9 @@ static char *ftp_buffer;
 static DEFINE_SPINLOCK(ip_ftp_lock);
=20
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
=20
 static int loose;
 module_param(loose, int, 0600);
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_=
conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -34,7 +34,7 @@
 #include <linux/moduleparam.h>
=20
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
 static int max_dcc_channels =3D 8;
 static unsigned int dcc_timeout =3D 300;
@@ -52,7 +52,7 @@ EXPORT_SYMBOL_GPL(ip_nat_irc_hook);
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 module_param(max_dcc_channels, int, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels pe=
r IRC session");
diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip=
_conntrack_tftp.c
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -26,9 +26,9 @@ MODULE_DESCRIPTION("tftp connection trac
 MODULE_LICENSE("GPL");
=20
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
=20
 #if 0

--FsscpQKzF/jJk6ya--

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDIo2CXaXGVTD0i/8RAp12AKClJbhGecWAsyCYOQz19vZAU+jdMwCeO2BR
Js33TiblPYdhmoSsKz5umoM=
=OVLq
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
