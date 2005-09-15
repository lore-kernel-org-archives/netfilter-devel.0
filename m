From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 5/8]: pptp helper: fix leaks when issuing expectations
Date: Fri, 16 Sep 2005 00:44:51 +0200
Message-ID: <4329F963.9090301@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: pptp helper: fix leaks when issuing expectations

ip_conntrack_expect_put always needs to be called for new expectations,
independant of the result from ip_conntrack_expect_related. This patch
consolidated the error paths in exp_gre() to do that and moves
responsibility for calling expect_put from the nat helper to the conntrack
helper as in other helpers.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d7ea87423cdd670f2dbb737d2baf1cceaa78346c
tree 87d4909c15d2e7d45ee432a86a17770d93f304d2
parent f406547e6d2cee9aad722ef4cc48fd14c89ddf08
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:14:48 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:14:48 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   43 ++++++++++++-------------
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    2 -
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -228,18 +228,16 @@ exp_gre(struct ip_conntrack *master,
 			 },
 		 }
 	};
-
 	struct ip_conntrack_expect *exp_orig, *exp_reply;
+	int ret = 1;
 
 	exp_orig = ip_conntrack_expect_alloc(master);
 	if (exp_orig == NULL)
-		return 1;
+		goto out;
 
 	exp_reply = ip_conntrack_expect_alloc(master);
-	if (exp_reply == NULL) {
-		ip_conntrack_expect_put(exp_orig);
-		return 1;
-	}
+	if (exp_reply == NULL)
+		goto out_put_orig;
 
 	memcpy(&exp_orig->tuple, &exp_tuples[0], sizeof(exp_orig->tuple));
 
@@ -262,51 +260,52 @@ exp_gre(struct ip_conntrack *master,
 	exp_reply->dir = !exp_orig->dir;
 
 	if (ip_nat_pptp_hook_exp_gre)
-		return ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
+		ret = ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
 	else {
 
 		DEBUGP("calling expect_related PNS->PAC");
 		DUMP_TUPLE(&exp_orig->tuple);
 
 		if (ip_conntrack_expect_related(exp_orig) != 0) {
-			ip_conntrack_expect_put(exp_orig);
-			ip_conntrack_expect_put(exp_reply);
 			DEBUGP("cannot expect_related()\n");
-			return 1;
+			goto out_put_both;
 		}
 
 		DEBUGP("calling expect_related PAC->PNS");
 		DUMP_TUPLE(&exp_reply->tuple);
 
 		if (ip_conntrack_expect_related(exp_reply) != 0) {
-			ip_conntrack_unexpect_related(exp_orig);
-			ip_conntrack_expect_put(exp_reply);
 			DEBUGP("cannot expect_related()\n");
-			return 1;
+			goto out_unexpect_orig;
 		}
 
 		/* Add GRE keymap entries */
 		if (ip_ct_gre_keymap_add(master, &exp_reply->tuple, 0) != 0) {
-			ip_conntrack_unexpect_related(exp_orig);
-			ip_conntrack_unexpect_related(exp_reply);
 			DEBUGP("cannot keymap_add() exp\n");
-			return 1;
+			goto out_unexpect_both;
 		}
 
 		invert_tuplepr(&inv_tuple, &exp_reply->tuple);
 		if (ip_ct_gre_keymap_add(master, &inv_tuple, 1) != 0) {
-			ip_conntrack_unexpect_related(exp_orig);
-			ip_conntrack_unexpect_related(exp_reply);
 			ip_ct_gre_keymap_destroy(master);
 			DEBUGP("cannot keymap_add() exp_inv\n");
-			return 1;
+			goto out_unexpect_both;
 		}
-	
+		ret = 0;
 	}
 
-	ip_conntrack_expect_put(exp_orig);
+out_put_both:
 	ip_conntrack_expect_put(exp_reply);
-	return 0;
+out_put_orig:
+	ip_conntrack_expect_put(exp_orig);
+out:
+	return ret;
+
+out_unexpect_both:
+	ip_conntrack_unexpect_related(exp_reply);
+out_unexpect_orig:
+	ip_conntrack_unexpect_related(exp_orig);
+	goto out_put_both;
 }
 
 static inline int 
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -224,7 +224,6 @@ pptp_exp_gre(struct ip_conntrack_expect 
 		DEBUGP("successfully registered expect\n");
 	} else {
 		DEBUGP("can't expect_related(expect_orig)\n");
-		ip_conntrack_expect_put(expect_orig);
 		return 1;
 	}
 
@@ -243,7 +242,6 @@ pptp_exp_gre(struct ip_conntrack_expect 
 	} else {
 		DEBUGP("can't expect_related(expect_reply)\n");
 		ip_conntrack_unexpect_related(expect_orig);
-		ip_conntrack_expect_put(expect_reply);
 		return 1;
 	}
 
