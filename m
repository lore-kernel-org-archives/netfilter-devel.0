From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Don't increase master refcount on expectations
Date: Thu, 25 Aug 2005 22:45:45 +0200
Message-ID: <430E2DF9.8060802@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080009010000040207090608"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080009010000040207090608
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

As it's been discussed [1][2]. We shouldn't increase the master 
conntrack refcount for non-fulfilled conntracks. During the conntrack 
destruction, the expectations are always killed before the conntrack 
itself, this guarantees that there won't be any orphan expectation.

[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020783.html
[2]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020904.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------080009010000040207090608
Content-Type: text/x-patch;
 name="06expect-refcount.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06expect-refcount.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-20 18:19:44.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-20 18:27:59.000000000 +0200
@@ -934,6 +934,9 @@
 	write_unlock_bh(&ip_conntrack_lock);
 }
 
+/* We don't increase the master conntrack refcount for non-fulfilled
+ * conntracks. During the conntrack destruction, the expectations are 
+ * always killed before the conntrack itself */
 struct ip_conntrack_expect *ip_conntrack_expect_alloc(struct ip_conntrack *me)
 {
 	struct ip_conntrack_expect *new;
@@ -944,17 +947,14 @@
 		return NULL;
 	}
 	new->master = me;
-	atomic_inc(&new->master->ct_general.use);
 	atomic_set(&new->use, 1);
 	return new;
 }
 
 void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
 {
-	if (atomic_dec_and_test(&exp->use)) {
-		ip_conntrack_put(exp->master);
+	if (atomic_dec_and_test(&exp->use))
 		kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	}
 }
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)

--------------080009010000040207090608--
