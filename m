From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_log: restrict the log prefix length to 127
Date: Sun, 22 Jan 2017 22:10:32 +0800
Message-ID: <1485094232-19683-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:55563 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdAVOLN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Jan 2017 09:11:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

First, log prefix will be truncated to NF_LOG_PREFIXLEN-1, i.e. 127,
at nf_log_packet(), so the extra part is useless.

Second, after adding a log rule with a very very long prefix, we will
fail to dump the nft rules after this _special_ one, but acctually,
they do exist. For example:
  # name_65000=$(printf "%0.sQ" {1..65000})
  # nft add rule filter output log prefix "$name_65000"
  # nft add rule filter output counter
  # nft add rule filter output counter
  # nft list chain filter output
  table ip filter {
      chain output {
          type filter hook output priority 0; policy accept;
      }
  }

So now, restrict the log prefix length to NF_LOG_PREFIXLEN-1.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
I think this is different with http://patchwork.ozlabs.org/patch/717635/.
So another separate patch will be better.

 include/uapi/linux/netfilter/nf_log.h | 2 ++
 net/netfilter/nf_log.c                | 1 -
 net/netfilter/nft_log.c               | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_log.h b/include/uapi/linux/netfilter/nf_log.h
index 8be21e0..d0b5fa9 100644
--- a/include/uapi/linux/netfilter/nf_log.h
+++ b/include/uapi/linux/netfilter/nf_log.h
@@ -9,4 +9,6 @@
 #define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
 #define NF_LOG_MASK		0x2f
 
+#define NF_LOG_PREFIXLEN	128
+
 #endif /* _NETFILTER_NF_LOG_H */
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 3dca90d..ffb9e8a 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -13,7 +13,6 @@
 /* Internal logging interface, which relies on the real
    LOG target modules */
 
-#define NF_LOG_PREFIXLEN		128
 #define NFLOGGER_NAME_LEN		64
 
 static struct nf_logger __rcu *loggers[NFPROTO_NUMPROTO][NF_LOG_TYPE_MAX] __read_mostly;
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 6271e40..6f6e644 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -39,7 +39,8 @@ static void nft_log_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_GROUP]	= { .type = NLA_U16 },
-	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
+	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING,
+				    .len = NF_LOG_PREFIXLEN - 1 },
 	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 	[NFTA_LOG_LEVEL]	= { .type = NLA_U32 },
-- 
2.5.5


