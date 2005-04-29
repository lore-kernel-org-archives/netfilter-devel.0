From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: [PATCH] nfsim at route del command.
Date: Thu, 28 Apr 2005 22:50:05 -0300
Message-ID: <1114739405.1940.6.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Rojt/MH2e00tu7NoqWOs"
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-Rojt/MH2e00tu7NoqWOs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch fixes segfault at route del command.

--- tools/route.c       (revision 3887)
+++ tools/route.c       (working copy)
@@ -17,6 +17,10 @@
 You should have received a copy of the GNU General Public License
 along with nfsim; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA
+
+
+2005-04-28: Christian Hentschel <chentschel@arnet.com.ar>
+       - Fix segfault at route del.
 */

 #include <tui.h>
@@ -183,7 +187,6 @@
                        if (route->network =3D=3D r2->network &&
                            route->netmask =3D=3D r2->netmask) {
                                found=3D1;
-                               list_del(&r2->entry);
                                talloc_free(r2);
                                nfsim_log(LOG_UI, "route removed");
                                break;


--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-Rojt/MH2e00tu7NoqWOs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCcZLN/jxG54BC3LgRAoLqAJ9AKaj74AeyL09qTC6DvAc7Ve2WkACfeHE4
FT/BFC0lIexgzWoOyqamkYU=
=Wi+D
-----END PGP SIGNATURE-----

--=-Rojt/MH2e00tu7NoqWOs--
