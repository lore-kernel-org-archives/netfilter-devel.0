From: Stephen Frost <sfrost@snowman.net>
Subject: [PATCH] ipt_recent-0.2.2
Date: Fri, 21 Jun 2002 14:26:50 -0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020621182649.GM9519@ns>
References: <20020618043438.GV9519@ns> <20020621191713.H2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rg893I9M3tK9A1lH"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20020621191713.H2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Rg893I9M3tK9A1lH
Content-Type: multipart/mixed; boundary="uMNE0C2is0k/ADx7"
Content-Disposition: inline


--uMNE0C2is0k/ADx7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Harald Welte (laforge@gnumonks.org) wrote:
> On Tue, Jun 18, 2002 at 12:34:39AM -0400, Stephen Frost wrote:
> > Hey all,
> >=20
> >   Version 0.2.1 of my ipt_recent module has been up and running on my
>=20
> thanks. For future reference: please send patches as mime attachment,
> uncompressed. this way i can read them in the mailer and don't need to sa=
ve,
> unzip them before.

No problem, just thought it a little large to send uncompressed.
Hopefully this one is better; just a minor bugfix.

Changelog:
  - If not SET and not found, return immediately instead of flipping the
    hash entries first (in the event of a collision).

--uMNE0C2is0k/ADx7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_recent-0.2.2.patch"

diff -uNr netfilter-old/userspace/patch-o-matic/extra/recent.patch netfilter/userspace/patch-o-matic/extra/recent.patch
--- netfilter-old/userspace/patch-o-matic/extra/recent.patch	Fri Jun 21 09:49:01 2002
+++ netfilter/userspace/patch-o-matic/extra/recent.patch	Fri Jun 21 10:10:13 2002
@@ -26,7 +26,7 @@
 +#endif /*_IPT_RECENT_H*/
 diff -uNr linux-2.4.18-clean/net/ipv4/netfilter/ipt_recent.c linux-2.4.18/net/ipv4/netfilter/ipt_recent.c
 --- linux-2.4.18-clean/net/ipv4/netfilter/ipt_recent.c	Wed Dec 31 19:00:00 1969
-+++ linux-2.4.18/net/ipv4/netfilter/ipt_recent.c	Mon Jun 17 20:13:00 2002
++++ linux-2.4.18/net/ipv4/netfilter/ipt_recent.c	Fri Jun 21 10:06:15 2002
 @@ -0,0 +1,786 @@
 +/* Kernel module to check if the source address has been seen recently. */
 +#include <linux/module.h>
@@ -51,7 +51,7 @@
 +static int debug = 0;
 +
 +#define RECENT_NAME	"ipt_recent"
-+#define RECENT_VER	"v0.2.1"
++#define RECENT_VER	"v0.2.2"
 +
 +static char version[] =
 +KERN_INFO RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n";
@@ -394,6 +394,13 @@
 +			hash_result = (hash_result + 1) % ip_list_hash_size;
 +		}
 +	}
++
++	if(hash_table[hash_result] == -1 && !(info->check_set & IPT_RECENT_SET)) {
++		/* IP not in list and not asked to SET */
++		spin_unlock_bh(&curr_table->list_lock);
++		return ans;
++	}
++
 +	/* Check if we need to handle the collision, do not need to on REMOVE */
 +	if(orig_hash_result != hash_result && !(info->check_set & IPT_RECENT_REMOVE)) {
 +		if(debug) printk(KERN_INFO "ipt_recent: match(): Collision in hash table. (or: %d,hr: %d,oa: %u,ha: %u)\n",
@@ -431,13 +438,6 @@
 +	if(hash_table[hash_result] == -1) {
 +		if(debug) printk(KERN_INFO "ipt_recent: match(): New table entry. (hr: %d,ha: %u)\n",
 +				 hash_result, addr);
-+
-+		/* New item, find place to put it */
-+		if(!(info->check_set & IPT_RECENT_SET)) {
-+			/* IP not in list and not asked to SET */
-+			spin_unlock_bh(&curr_table->list_lock);
-+			return ans;
-+		}
 +
 +		/* New item found and IPT_RECENT_SET, so we need to add it */
 +		location = time_info[curr_table->time_pos].position;

--uMNE0C2is0k/ADx7--

--Rg893I9M3tK9A1lH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9E2/przgMPqB3kigRAtUcAJ94CmSos4RJRvKnjvuuOT8IvQwhMwCZAVCU
nySlCGKmSK1+l3/zWxoDAQQ=
=AF+A
-----END PGP SIGNATURE-----

--Rg893I9M3tK9A1lH--
