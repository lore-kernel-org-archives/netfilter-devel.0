From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ipt_hashlimit.c: Remove custom msecs_to_jiffies() macro
Date: Fri, 1 Apr 2005 08:28:44 +0200
Message-ID: <20050401062844.GL19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kuk/n493crKO4rgR"
Cc: tklauser@access.unizh.ch
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--Kuk/n493crKO4rgR
Content-Type: multipart/mixed; boundary="Mh8CTEa8Ax54aLHp"
Content-Disposition: inline


--Mh8CTEa8Ax54aLHp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dave, please apply the following fix, courtesy of Thomas.

Thanks!

Signed-off-by: Harald Welte <laforge@netfilter.org>

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Mh8CTEa8Ax54aLHp
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.17-IPv6-Debian-2.1.17-0woody.3.1) with LMTP;
	Thu, 24 Mar 2005 01:28:49 +0100
X-Sieve: CMU Sieve 2.2
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from vishnu.netfilter.org ([213.95.27.115])
	by ganesha.gnumonks.org with esmtp
	(TLS-1.0:DHE_RSA_3DES_EDE_CBC_SHA:24) (Exim 4.34) id 1DEGDR-0002RV-MM
	for laforge@gnumonks.org; Thu, 24 Mar 2005 01:28:49 +0100
Received: from localhost ([127.0.0.1] helo=vishnu.netfilter.org)
	by vishnu.netfilter.org with esmtp (Exim 4.41 #1 (Debian))
	id 1DEGG3-0006SR-D4; Thu, 24 Mar 2005 01:31:31 +0100
Received: from idmailgate1.unizh.ch ([130.60.68.105])
	by vishnu.netfilter.org with esmtp (Exim 4.41 #1 (Debian))
	id 1DDmRT-00019w-LQ for <netfilter-devel@lists.netfilter.org>;
	Tue, 22 Mar 2005 17:41:21 +0100
Received: from localhost ([130.60.169.171])
	by idmailgate1.unizh.ch (8.12.10/8.12.10/Debian-2) with ESMTP id
	j2MGchxW019040; Tue, 22 Mar 2005 17:38:43 +0100
Date: Tue, 22 Mar 2005 17:38:42 +0100
From: Tobias Klauser <tklauser@access.unizh.ch>
To: kernel-janitors@lists.osdl.org
Message-ID: <20050322163842.GA7173@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Key: 0x3A445520
X-OS: GNU/Linux
User-Agent: Mutt/1.5.6+20040907i
X-Virus-Scanned: by amavisd-new
X-Spam-Score: -2.6 (--)
X-Mailman-Approved-At: Thu, 24 Mar 2005 01:30:43 +0100
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Subject: [PATCH] net/ipv4/iptables/ipt_hashlimit.c: Remove custom
	msecs_to_jiffies() macro
X-BeenThere: netfilter-devel@lists.netfilter.org
X-Mailman-Version: 2.1.5
Precedence: list
List-Id: discussion about netfilter development
	<netfilter-devel.lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
X-Spam-Score: -1.9 (-)

Replace the MS2JIFFIES() macro with the msecs_to_jiffies() function provided in
jiffies.h.  The current macro is incorrect because HZ can have different values
on different architectures.

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

diff -urpN linux-2.6.11.orig/net/ipv4/netfilter/ipt_hashlimit.c linux-2.6.11/net/ipv4/netfilter/ipt_hashlimit.c
--- linux-2.6.11.orig/net/ipv4/netfilter/ipt_hashlimit.c	2005-03-02 12:50:59.000000000 +0100
+++ linux-2.6.11/net/ipv4/netfilter/ipt_hashlimit.c	2005-03-21 16:46:41.000000000 +0100
@@ -45,8 +45,6 @@
 /* FIXME: this is just for IP_NF_ASSERRT */
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 
-#define MS2JIFFIES(x) ((x*HZ)/1000)
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables match for limiting per hash-bucket");
@@ -225,7 +223,7 @@ static int htable_create(struct ipt_hash
 	hinfo->pde->data = hinfo;
 
 	init_timer(&hinfo->timer);
-	hinfo->timer.expires = jiffies + MS2JIFFIES(hinfo->cfg.gc_interval);
+	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
 	hinfo->timer.data = (unsigned long )hinfo;
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
@@ -275,7 +273,7 @@ static void htable_gc(unsigned long htlo
 	htable_selective_cleanup(ht, select_gc);
 
 	/* re-add the timer accordingly */
-	ht->timer.expires = jiffies + MS2JIFFIES(ht->cfg.gc_interval);
+	ht->timer.expires = jiffies + msecs_to_jiffies(ht->cfg.gc_interval);
 	add_timer(&ht->timer);
 }
 
@@ -468,7 +466,7 @@ hashlimit_match(const struct sk_buff *sk
 			return 0;
 		}
 
-		dh->expires = jiffies + MS2JIFFIES(hinfo->cfg.expire);
+		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
 
 		dh->rateinfo.prev = jiffies;
 		dh->rateinfo.credit = user2credits(hinfo->cfg.avg * 
@@ -482,7 +480,7 @@ hashlimit_match(const struct sk_buff *sk
 	}
 
 	/* update expiration timeout */
-	dh->expires = now + MS2JIFFIES(hinfo->cfg.expire);
+	dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
 
 	rateinfo_recalc(dh, now);
 	if (dh->rateinfo.credit >= dh->rateinfo.cost) {


--Mh8CTEa8Ax54aLHp--

--Kuk/n493crKO4rgR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOocXaXGVTD0i/8RAjZRAKCBsO0sLOOa+614vlWPBsVIyVs0JACgjIXI
p/uuu02q6RB69kuZeG7wuo0=
=7Ua6
-----END PGP SIGNATURE-----

--Kuk/n493crKO4rgR--
