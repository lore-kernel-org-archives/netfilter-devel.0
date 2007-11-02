From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/07]: remove unneeded rcu_dereference() calls
Date: Fri,  2 Nov 2007 12:23:17 +0100 (MET)
Message-ID: <20071102112007.22803.32649.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXKBLXS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:18 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: remove unneeded rcu_dereference() calls

As noticed by Paul McKenney, the rcu_dereference calls in the init path
of NAT modules are unneeded, remove them.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 04a6b70568aa679cdce548f4edaac0a668440c60
tree 7be457d2896edddeaf07f503928338f1b8f850d0
parent 5bbc87888870ac8831766b731f509a552e25815f
author Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:57 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:57 +0100

 net/ipv4/netfilter/nf_nat_amanda.c |    2 +-
 net/ipv4/netfilter/nf_nat_ftp.c    |    2 +-
 net/ipv4/netfilter/nf_nat_h323.c   |   18 +++++++++---------
 net/ipv4/netfilter/nf_nat_irc.c    |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c   |    8 ++++----
 net/ipv4/netfilter/nf_nat_sip.c    |    4 ++--
 net/ipv4/netfilter/nf_nat_tftp.c   |    2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf_nat_amanda.c
index 35a5aa6..c31b876 100644
--- a/net/ipv4/netfilter/nf_nat_amanda.c
+++ b/net/ipv4/netfilter/nf_nat_amanda.c
@@ -69,7 +69,7 @@ static void __exit nf_nat_amanda_fini(void)
 
 static int __init nf_nat_amanda_init(void)
 {
-	BUG_ON(rcu_dereference(nf_nat_amanda_hook));
+	BUG_ON(nf_nat_amanda_hook != NULL);
 	rcu_assign_pointer(nf_nat_amanda_hook, help);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index e1a16d3..a1d5d58 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -147,7 +147,7 @@ static void __exit nf_nat_ftp_fini(void)
 
 static int __init nf_nat_ftp_init(void)
 {
-	BUG_ON(rcu_dereference(nf_nat_ftp_hook));
+	BUG_ON(nf_nat_ftp_hook != NULL);
 	rcu_assign_pointer(nf_nat_ftp_hook, nf_nat_ftp);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index a868c8c..93e18ef 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -544,15 +544,15 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 /****************************************************************************/
 static int __init init(void)
 {
-	BUG_ON(rcu_dereference(set_h245_addr_hook) != NULL);
-	BUG_ON(rcu_dereference(set_h225_addr_hook) != NULL);
-	BUG_ON(rcu_dereference(set_sig_addr_hook) != NULL);
-	BUG_ON(rcu_dereference(set_ras_addr_hook) != NULL);
-	BUG_ON(rcu_dereference(nat_rtp_rtcp_hook) != NULL);
-	BUG_ON(rcu_dereference(nat_t120_hook) != NULL);
-	BUG_ON(rcu_dereference(nat_h245_hook) != NULL);
-	BUG_ON(rcu_dereference(nat_callforwarding_hook) != NULL);
-	BUG_ON(rcu_dereference(nat_q931_hook) != NULL);
+	BUG_ON(set_h245_addr_hook != NULL);
+	BUG_ON(set_h225_addr_hook != NULL);
+	BUG_ON(set_sig_addr_hook != NULL);
+	BUG_ON(set_ras_addr_hook != NULL);
+	BUG_ON(nat_rtp_rtcp_hook != NULL);
+	BUG_ON(nat_t120_hook != NULL);
+	BUG_ON(nat_h245_hook != NULL);
+	BUG_ON(nat_callforwarding_hook != NULL);
+	BUG_ON(nat_q931_hook != NULL);
 
 	rcu_assign_pointer(set_h245_addr_hook, set_h245_addr);
 	rcu_assign_pointer(set_h225_addr_hook, set_h225_addr);
diff --git a/net/ipv4/netfilter/nf_nat_irc.c b/net/ipv4/netfilter/nf_nat_irc.c
index 766e2c1..fe6f9ce 100644
--- a/net/ipv4/netfilter/nf_nat_irc.c
+++ b/net/ipv4/netfilter/nf_nat_irc.c
@@ -74,7 +74,7 @@ static void __exit nf_nat_irc_fini(void)
 
 static int __init nf_nat_irc_init(void)
 {
-	BUG_ON(rcu_dereference(nf_nat_irc_hook));
+	BUG_ON(nf_nat_irc_hook != NULL);
 	rcu_assign_pointer(nf_nat_irc_hook, help);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index e1385a0..6817e79 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -281,16 +281,16 @@ static int __init nf_nat_helper_pptp_init(void)
 {
 	nf_nat_need_gre();
 
-	BUG_ON(rcu_dereference(nf_nat_pptp_hook_outbound));
+	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
 	rcu_assign_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
 
-	BUG_ON(rcu_dereference(nf_nat_pptp_hook_inbound));
+	BUG_ON(nf_nat_pptp_hook_inbound != NULL);
 	rcu_assign_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
 
-	BUG_ON(rcu_dereference(nf_nat_pptp_hook_exp_gre));
+	BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
 	rcu_assign_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
 
-	BUG_ON(rcu_dereference(nf_nat_pptp_hook_expectfn));
+	BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
 	rcu_assign_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index ce9edbc..3ca9897 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -293,8 +293,8 @@ static void __exit nf_nat_sip_fini(void)
 
 static int __init nf_nat_sip_init(void)
 {
-	BUG_ON(rcu_dereference(nf_nat_sip_hook));
-	BUG_ON(rcu_dereference(nf_nat_sdp_hook));
+	BUG_ON(nf_nat_sip_hook != NULL);
+	BUG_ON(nf_nat_sdp_hook != NULL);
 	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
 	rcu_assign_pointer(nf_nat_sdp_hook, ip_nat_sdp);
 	return 0;
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
index 0ecec70..1360a94 100644
--- a/net/ipv4/netfilter/nf_nat_tftp.c
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -43,7 +43,7 @@ static void __exit nf_nat_tftp_fini(void)
 
 static int __init nf_nat_tftp_init(void)
 {
-	BUG_ON(rcu_dereference(nf_nat_tftp_hook));
+	BUG_ON(nf_nat_tftp_hook != NULL);
 	rcu_assign_pointer(nf_nat_tftp_hook, help);
 	return 0;
 }
