From: "Nicolas Bouliane" <nib@cookinglinux.org>
Subject: [PATCH]: bug with --dst-range in libipt_iprange.c
Date: Sun, 11 Jul 2004 21:05:34 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <32886.192.168.1.19.1089594334.squirrel@192.168.1.19>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

When using --dst-range twice, which is supposed to return an error,
the second given ip range is overwriting the previously set ip range.

The --src-range option is working perfectly; we can't use it twice.
But --dst-range just doesn't because the flag is always reset to 1.

Patch below.

Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>

diff -urpN libipt_iprange.c.orig libipt_iprange.c
--- libipt_iprange.c.orig       2004-07-11 16:34:43.000000000 -0400
+++ libipt_iprange.c    2004-07-11 16:35:16.000000000 -0400
@@ -99,8 +99,8 @@ parse(int c, char **argv, int invert, un
                        info->flags |=3D IPRANGE_DST_INV;

                parse_iprange(optarg, &info->dst);
-               *flags =3D 1;
-               break;
+
+      break;

        default:
                return 0;


---
Nicolas Bouliane,
Samuel Jean
at cookinglinux.org
