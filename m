From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables/libnftables packages for Fedora
Date: Tue, 14 Jan 2014 19:34:33 +0100
Message-ID: <20140114183433.GA15328@localhost>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <alpine.LSU.2.11.1401130953150.14789@nerf08.vanv.qr>
 <20140113090942.GA14601@macbook.localnet>
 <20140113121836.0d4b1595@voldemort.scrye.com>
 <20140114085532.GA23920@macbook.localnet>
 <20140114112816.71d061e7@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="QKdGvSO+nmPlgiQ/"
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37964 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaANSem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:34:42 -0500
Content-Disposition: inline
In-Reply-To: <20140114112816.71d061e7@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 11:28:16AM -0700, Kevin Fenzi wrote:
> On Tue, 14 Jan 2014 08:55:33 +0000
> Patrick McHardy <kaber@trash.net> wrote:
>=20
> > That's what we have (and always had) in nftables:
>=20
> Indeed, it's libnftables that has the old one.=20

Patch attached.

--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x
Content-Transfer-Encoding: quoted-printable

diff --git a/COPYING b/COPYING
index a43ea21..21b9363 100644
--- a/COPYING
+++ b/COPYING
@@ -2,7 +2,7 @@
 		       Version 2, June 1991
=20
  Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-                          675 Mass Ave, Cambridge, MA 02139, USA
+               51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
=20
@@ -278,8 +278,9 @@ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN =
ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
=20
 		     END OF TERMS AND CONDITIONS
-=0C
-	Appendix: How to Apply These Terms to Your New Programs
+
+
+	    How to Apply These Terms to Your New Programs
=20
   If you develop a new program, and you want it to be of the greatest
 possible use to the public, the best way to achieve this is to make it
@@ -305,7 +306,8 @@ the "copyright" line and a pointer to where the full no=
tice is found.
=20
     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1=
301  USA
+
=20
 Also add information on how to contact you by electronic and paper mail.
=20

--QKdGvSO+nmPlgiQ/--
