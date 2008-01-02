From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 21/27] Convert unfixated types to fixated ones
Date: Wed, 2 Jan 2008 21:31:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022130570.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYABUbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:31:24 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 69855da1bb8257b215c83a72edd0c67bd7810fa5
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:30:30 2008 +0100

    [NETFILTER]: Convert unfixated types to fixated ones.
    
    The use of an unfixated type like "int" is dangerous, its size may
    change in future (imagine 128-bit or ILP64 compilation) -- "long"
    already has this problem which is differently-sized on x86_32 and
    x86_64. Switch "int" to "int32_t" to prepare against future compiler
    changes.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_connlimit.h  |    2 +-
 include/linux/netfilter/xt_mac.h        |    4 ++--
 include/linux/netfilter/xt_pkttype.h    |    4 ++--
 include/linux/netfilter/xt_sctp.h       |    2 +-
 include/linux/netfilter/xt_state.h      |    2 +-
 include/linux/netfilter_ipv4/ipt_LOG.h  |    4 ++--
 include/linux/netfilter_ipv4/ipt_SAME.h |    2 +-
 include/linux/netfilter_ipv4/ipt_sctp.h |    2 +-
 include/linux/netfilter_ipv6/ip6t_LOG.h |    4 ++--
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 7e3284b..b66e2a4 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -13,7 +13,7 @@ struct xt_connlimit_info {
 		};
 #endif
 	};
-	unsigned int limit, inverse;
+	u_int32_t limit, inverse;
 
 	/* Used internally by the kernel */
 	struct xt_connlimit_data *data __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_mac.h b/include/linux/netfilter/xt_mac.h
index b892cdc..2f7f05b 100644
--- a/include/linux/netfilter/xt_mac.h
+++ b/include/linux/netfilter/xt_mac.h
@@ -2,7 +2,7 @@
 #define _XT_MAC_H
 
 struct xt_mac_info {
-    unsigned char srcaddr[ETH_ALEN];
-    int invert;
+	unsigned char srcaddr[ETH_ALEN];
+	int32_t invert;
 };
 #endif /*_XT_MAC_H*/
diff --git a/include/linux/netfilter/xt_pkttype.h b/include/linux/netfilter/xt_pkttype.h
index f265cf5..268dd73 100644
--- a/include/linux/netfilter/xt_pkttype.h
+++ b/include/linux/netfilter/xt_pkttype.h
@@ -2,7 +2,7 @@
 #define _XT_PKTTYPE_H
 
 struct xt_pkttype_info {
-	int	pkttype;
-	int	invert;
+	int32_t	pkttype;
+	int32_t	invert;
 };
 #endif /*_XT_PKTTYPE_H*/
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index dd5a4fd..48f945c 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -27,7 +27,7 @@ struct xt_sctp_info {
 
 	u_int32_t chunk_match_type;
 	struct xt_sctp_flag_info flag_info[XT_NUM_SCTP_FLAGS];
-	int flag_count;
+	int32_t flag_count;
 
 	u_int32_t flags;
 	u_int32_t invflags;
diff --git a/include/linux/netfilter/xt_state.h b/include/linux/netfilter/xt_state.h
index c06f32e..7155420 100644
--- a/include/linux/netfilter/xt_state.h
+++ b/include/linux/netfilter/xt_state.h
@@ -8,6 +8,6 @@
 
 struct xt_state_info
 {
-	unsigned int statemask;
+	u_int32_t statemask;
 };
 #endif /*_XT_STATE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 90fa652..ddaf142 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -10,8 +10,8 @@
 #define IPT_LOG_MASK		0x1f
 
 struct ipt_log_info {
-	unsigned char level;
-	unsigned char logflags;
+	u_int8_t level;
+	u_int8_t logflags;
 	char prefix[30];
 };
 
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
index be6e682..0def688 100644
--- a/include/linux/netfilter_ipv4/ipt_SAME.h
+++ b/include/linux/netfilter_ipv4/ipt_SAME.h
@@ -7,7 +7,7 @@
 
 struct ipt_same_info
 {
-	unsigned char info;
+	u_int8_t info;
 	u_int32_t rangesize;
 	u_int32_t ipnum;
 	u_int32_t *iparray;
diff --git a/include/linux/netfilter_ipv4/ipt_sctp.h b/include/linux/netfilter_ipv4/ipt_sctp.h
index 80b3dba..78b567d 100644
--- a/include/linux/netfilter_ipv4/ipt_sctp.h
+++ b/include/linux/netfilter_ipv4/ipt_sctp.h
@@ -28,7 +28,7 @@ struct ipt_sctp_info {
 
 	u_int32_t chunk_match_type;
 	struct ipt_sctp_flag_info flag_info[IPT_NUM_SCTP_FLAGS];
-	int flag_count;
+	int32_t flag_count;
 
 	u_int32_t flags;
 	u_int32_t invflags;
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 0d0119b..e768acc 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -10,8 +10,8 @@
 #define IP6T_LOG_MASK		0x1f
 
 struct ip6t_log_info {
-	unsigned char level;
-	unsigned char logflags;
+	u_int8_t level;
+	u_int8_t logflags;
 	char prefix[30];
 };
 
