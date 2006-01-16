From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/3] ip6tables: remove unused definitions in IPv6 matches
Date: Mon, 16 Jan 2006 18:38:49 +0900 (JST)
Message-ID: <200601160938.k0G9cnNB027835@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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


These definitions ware used for only internal use in kernel <= 2.6.13,
which had not introduced the unified parser of IPv6 extension header yet.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 6a17d7592477ee9246ed39147980ae5012bb0c28
tree 59d34642d9128fdf034cbb9bc612589adf571ae1
parent 2e4e6a17af35be359cc8f1c924f8f198fbd478cc
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jan 2006 03:56:59 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jan 2006 03:56:59 +0900

 include/linux/netfilter_ipv6/ip6t_ah.h   |    9 ---------
 include/linux/netfilter_ipv6/ip6t_esp.h  |    9 ---------
 include/linux/netfilter_ipv6/ip6t_frag.h |    9 ---------
 include/linux/netfilter_ipv6/ip6t_opts.h |    9 ---------
 include/linux/netfilter_ipv6/ip6t_rt.h   |    9 ---------
 5 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6t_ah.h b/include/linux/netfilter_ipv6/ip6t_ah.h
index c4f0793..8531879 100644
--- a/include/linux/netfilter_ipv6/ip6t_ah.h
+++ b/include/linux/netfilter_ipv6/ip6t_ah.h
@@ -18,13 +18,4 @@ struct ip6t_ah
 #define IP6T_AH_INV_LEN		0x02	/* Invert the sense of length. */
 #define IP6T_AH_INV_MASK	0x03	/* All possible flags. */
 
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
 #endif /*_IP6T_AH_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_esp.h b/include/linux/netfilter_ipv6/ip6t_esp.h
index 01142b9..a91b6ab 100644
--- a/include/linux/netfilter_ipv6/ip6t_esp.h
+++ b/include/linux/netfilter_ipv6/ip6t_esp.h
@@ -7,15 +7,6 @@ struct ip6t_esp
 	u_int8_t  invflags;			/* Inverse flags */
 };
 
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
 /* Values for "invflags" field in struct ip6t_esp. */
 #define IP6T_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
 #define IP6T_ESP_INV_MASK	0x01	/* All possible flags. */
diff --git a/include/linux/netfilter_ipv6/ip6t_frag.h b/include/linux/netfilter_ipv6/ip6t_frag.h
index 449a57e..66070a0 100644
--- a/include/linux/netfilter_ipv6/ip6t_frag.h
+++ b/include/linux/netfilter_ipv6/ip6t_frag.h
@@ -21,13 +21,4 @@ struct ip6t_frag
 #define IP6T_FRAG_INV_LEN	0x02	/* Invert the sense of length. */
 #define IP6T_FRAG_INV_MASK	0x03	/* All possible flags. */
 
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
 #endif /*_IP6T_FRAG_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_opts.h b/include/linux/netfilter_ipv6/ip6t_opts.h
index e259b62..a07e363 100644
--- a/include/linux/netfilter_ipv6/ip6t_opts.h
+++ b/include/linux/netfilter_ipv6/ip6t_opts.h
@@ -20,13 +20,4 @@ struct ip6t_opts
 #define IP6T_OPTS_INV_LEN	0x01	/* Invert the sense of length. */
 #define IP6T_OPTS_INV_MASK	0x01	/* All possible flags. */
 
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
 #endif /*_IP6T_OPTS_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_rt.h b/include/linux/netfilter_ipv6/ip6t_rt.h
index f1070fb..5215602 100644
--- a/include/linux/netfilter_ipv6/ip6t_rt.h
+++ b/include/linux/netfilter_ipv6/ip6t_rt.h
@@ -30,13 +30,4 @@ struct ip6t_rt
 #define IP6T_RT_INV_LEN		0x04	/* Invert the sense of length. */
 #define IP6T_RT_INV_MASK	0x07	/* All possible flags. */
 
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
 #endif /*_IP6T_RT_H*/
