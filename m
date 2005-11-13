From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/4] fix type of sysctl variables in nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 17:50:54 +0900 (JST)
Message-ID: <200511130850.jAD8otXv012019@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_50_54_2005_868)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Sun_Nov_13_17_50_54_2005_868)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


These variables should be unsigned. And this fixes sysctl handler for
nf_ct_frag6_{low,high}_thresh.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sun_Nov_13_17_50_54_2005_868)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-nfct-reasm-sysctl.patch"

[NETFILTER] fix type of sysctl variables in nf_conntrack_ipv6

These variables should be unsigned. And this fixes sysctl handler for
nf_ct_frag6_{low,high}_thresh.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 7f3c8051c47ebe6260a6c6159bcb2feae10c9dcc
tree f1b7da0f485f2d855de58fa5ea334a2c51b59d19
parent c233efcbadfe21a7909bd0c24ea16b9084f0c0f4
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 14:17:41 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 14:17:41 +0900

 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    8 ++++----
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index e2c90b3..753a3ae 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -339,8 +339,8 @@ extern unsigned long nf_ct_icmpv6_timeou
 
 /* From nf_conntrack_frag6.c */
 extern unsigned long nf_ct_frag6_timeout;
-extern unsigned long nf_ct_frag6_low_thresh;
-extern unsigned long nf_ct_frag6_high_thresh;
+extern unsigned int nf_ct_frag6_low_thresh;
+extern unsigned int nf_ct_frag6_high_thresh;
 
 static struct ctl_table_header *nf_ct_ipv6_sysctl_header;
 
@@ -367,7 +367,7 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.data		= &nf_ct_frag6_low_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_dointvec,
 	},
 	{
 		.ctl_name	= NET_NF_CONNTRACK_FRAG6_HIGH_THRESH,
@@ -375,7 +375,7 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.data		= &nf_ct_frag6_high_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= &proc_dointvec,
 	},
         { .ctl_name = 0 }
 };
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 587293b..5556a19 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -55,9 +55,9 @@
 #define NF_CT_FRAG6_LOW_THRESH 196608  /* == 192*1024 */
 #define NF_CT_FRAG6_TIMEOUT IPV6_FRAG_TIMEOUT
 
-int nf_ct_frag6_high_thresh = 256*1024;
-int nf_ct_frag6_low_thresh = 192*1024;
-int nf_ct_frag6_timeout = IPV6_FRAG_TIMEOUT;
+unsigned int nf_ct_frag6_high_thresh = 256*1024;
+unsigned int nf_ct_frag6_low_thresh = 192*1024;
+unsigned long nf_ct_frag6_timeout = IPV6_FRAG_TIMEOUT;
 
 struct nf_ct_frag6_skb_cb
 {

----Next_Part(Sun_Nov_13_17_50_54_2005_868)----
