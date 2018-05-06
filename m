From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 30/51] netfilter: add __exit mark to helper modules
Date: Mon,  7 May 2018 00:46:48 +0200
Message-ID: <20180506224709.29100-31-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

There are no __exit mark in the helper modules.
because these exit functions used to be called by init function
but now that is not. so we can add __exit mark.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c  | 3 +--
 net/netfilter/nf_conntrack_irc.c  | 6 +-----
 net/netfilter/nf_conntrack_sane.c | 3 +--
 net/netfilter/nf_conntrack_sip.c  | 2 +-
 net/netfilter/nf_conntrack_tftp.c | 2 +-
 5 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index f0e9a7511e1a..a11c304fb771 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -566,8 +566,7 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
-/* don't make this __exit, since it's called from __init ! */
-static void nf_conntrack_ftp_fini(void)
+static void __exit nf_conntrack_ftp_fini(void)
 {
 	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
 	kfree(ftp_buffer);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5523acce9d69..4099f4d79bae 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -232,8 +232,6 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
 static struct nf_conntrack_expect_policy irc_exp_policy;
 
-static void nf_conntrack_irc_fini(void);
-
 static int __init nf_conntrack_irc_init(void)
 {
 	int i, ret;
@@ -276,9 +274,7 @@ static int __init nf_conntrack_irc_init(void)
 	return 0;
 }
 
-/* This function is intentionally _NOT_ defined as __exit, because
- * it is needed by the init function */
-static void nf_conntrack_irc_fini(void)
+static void __exit nf_conntrack_irc_fini(void)
 {
 	nf_conntrack_helpers_unregister(irc, ports_c);
 	kfree(irc_buffer);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index ae457f39d5ce..5072ff96ab33 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -173,8 +173,7 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
-/* don't make this __exit, since it's called from __init ! */
-static void nf_conntrack_sane_fini(void)
+static void __exit nf_conntrack_sane_fini(void)
 {
 	nf_conntrack_helpers_unregister(sane, ports_c * 2);
 	kfree(sane_buffer);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4dbb5bad4363..148ce1a52cc7 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1609,7 +1609,7 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 	},
 };
 
-static void nf_conntrack_sip_fini(void)
+static void __exit nf_conntrack_sip_fini(void)
 {
 	nf_conntrack_helpers_unregister(sip, ports_c * 4);
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 0ec6779fd5d9..548b673b3625 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,7 +104,7 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
-static void nf_conntrack_tftp_fini(void)
+static void __exit nf_conntrack_tftp_fini(void)
 {
 	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
 }
-- 
2.11.0
