From: Tobias Klauser <tklauser@access.unizh.ch>
Subject: [KJ] [PATCH] net/ipv4/iptables/ipt_hashlimit.c: Remove custom
	msecs_to_jiffies() macro
Date: Tue, 22 Mar 2005 17:38:42 +0100
Message-ID: <20050322163842.GA7173@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============67660855260729513=="
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
To: kernel-janitors@lists.osdl.org
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
List-Id: netfilter-devel.vger.kernel.org

--===============67660855260729513==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

--===============67660855260729513==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============67660855260729513==--
