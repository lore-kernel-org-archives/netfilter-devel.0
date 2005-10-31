From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] fix compilation error of pptp helper on 2.6.14
Date: Tue, 01 Nov 2005 04:10:55 +0900 (JST)
Message-ID: <200510311910.j9VJAug1016778@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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


Hi, Harald,

PPTP helper without NAT cannot be build.

  CC [M]  net/ipv4/netfilter/ip_conntrack_standalone.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_core.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_generic.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_tcp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_udp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_icmp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_helper_pptp.o
net/ipv4/netfilter/ip_conntrack_helper_pptp.c: In function `exp_gre':
net/ipv4/netfilter/ip_conntrack_helper_pptp.c:273: error: structure has no member named `dir'
net/ipv4/netfilter/ip_conntrack_helper_pptp.c:279: error: structure has no member named `dir'
net/ipv4/netfilter/ip_conntrack_helper_pptp.c:279: error: structure has no member named `dir'
make[3]: *** [net/ipv4/netfilter/ip_conntrack_helper_pptp.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2


This patch can help you ?

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -270,14 +270,10 @@ exp_gre(struct ip_conntrack *master,
 	exp_orig->expectfn = pptp_expectfn;
 	exp_orig->flags = 0;
 
-	exp_orig->dir = IP_CT_DIR_ORIGINAL;
-
 	/* both expectations are identical apart from tuple */
 	memcpy(exp_reply, exp_orig, sizeof(*exp_reply));
 	memcpy(&exp_reply->tuple, &exp_tuples[1], sizeof(exp_reply->tuple));
 
-	exp_reply->dir = !exp_orig->dir;
-
 	if (ip_nat_pptp_hook_exp_gre)
 		ret = ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
 	else {
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -216,6 +216,7 @@ pptp_exp_gre(struct ip_conntrack_expect 
 	expect_orig->saved_proto.gre.key = htons(nat_pptp_info->pac_call_id);
 	expect_orig->tuple.src.u.gre.key = htons(nat_pptp_info->pns_call_id);
 	expect_orig->tuple.dst.u.gre.key = htons(ct_pptp_info->pac_call_id);
+	expect_orig->dir = IP_CT_DIR_ORIGINAL;
 	inv_t.src.ip = reply_t->src.ip;
 	inv_t.dst.ip = reply_t->dst.ip;
 	inv_t.src.u.gre.key = htons(nat_pptp_info->pac_call_id);
@@ -233,6 +234,7 @@ pptp_exp_gre(struct ip_conntrack_expect 
 	expect_reply->saved_proto.gre.key = htons(nat_pptp_info->pns_call_id);
 	expect_reply->tuple.src.u.gre.key = htons(nat_pptp_info->pac_call_id);
 	expect_reply->tuple.dst.u.gre.key = htons(ct_pptp_info->pns_call_id);
+	expect_reply->dir = !exp_orig->dir;
 	inv_t.src.ip = orig_t->src.ip;
 	inv_t.dst.ip = orig_t->dst.ip;
 	inv_t.src.u.gre.key = htons(nat_pptp_info->pns_call_id);
