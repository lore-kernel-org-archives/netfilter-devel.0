From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ip_queue: Print warning when deprecated interface is being
	used
Date: Thu, 13 Apr 2006 10:07:31 +0200
Message-ID: <20060413080731.GF22448@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="twz1s1Hj1O0rHoT0"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
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


--twz1s1Hj1O0rHoT0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick!

I better submit this via you, since I don't want to clash with what you
have in your queue for DaveM...


[NETFILTER] ip_queue: Print warning when deprecated interface is being used

Every time a process binds to ip_queue, this will print a KERN_WARNING
message to inform the user that the process is using a deprecated
interface, and that it should migrate to the new nfnetlink_queue interface.

Also, we extend the deadline for ip_queue removal till December 2006.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 73719a89c574bcda13d13cbec3aba672219988bb
tree 850bb876c175642cb86ee603cb05962f5b4bfae0
parent 3599bbbe2873942dcc68bc50dec7a91868373654
author Harald Welte <laforge@netfilter.org> Thu, 13 Apr 2006 10:05:56 +0200
committer Harald Welte <laforge@netfilter.org> Thu, 13 Apr 2006 10:05:56 +0=
200

 Documentation/feature-removal-schedule.txt |    2 +-
 net/ipv4/netfilter/ip_queue.c              |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/fea=
ture-removal-schedule.txt
index 293fed1..2ed657c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -97,7 +97,7 @@ Who:	Dominik Brodowski <linux@brodo.de>
 ---------------------------
=20
 What:	ip_queue and ip6_queue (old ipv4-only and ipv6-only netfilter queue)
-When:	December 2005
+When:	December 2006
 Why:	This interface has been obsoleted by the new layer3-independent
 	"nfnetlink_queue".  The Kernel interface is compatible, so the old
 	ip[6]tables "QUEUE" targets still work and will transparently handle
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index b93f049..d58d5d6 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -520,6 +520,9 @@ ipq_rcv_skb(struct sk_buff *skb)
 	} else {
 		net_enable_timestamp();
 		peer_pid =3D pid;
+		printk(KERN_WARNING "process with PID %u uses deprecated "
+		       "ip_queue interface. Please migrate to "
+		       "nfnetlink_queue\n", pid);
 	}
 	=09
 	write_unlock_bh(&queue_lock);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--twz1s1Hj1O0rHoT0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPgbDXaXGVTD0i/8RAuBhAJ4r63Kbi0UAExZlS98BivsB8dZ3HACeKdba
ij6KQeyEZyA5f2tg6/MS9AQ=
=0xtY
-----END PGP SIGNATURE-----

--twz1s1Hj1O0rHoT0--
