From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: xt_tee: fix calling nf_dup_ipv6
Date: Mon,  9 Jul 2018 17:25:38 +0200
Message-ID: <20180709152546.1177277-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Kirill Tkhai <ktkhai@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Now that we can enable the NETFILTER_XT_TARGET_TEE option without supporting
TEE on ipv6, we get a build error with NETFILTER_XT_TARGET_TEE=y, IPV6=y and
IP6_NF_IPTABLES=n:

ERROR: "nf_dup_ipv6" [net/netfilter/xt_TEE.ko] undefined!

I previously submitted another patch that fixes the same symptom for the
case of IP6_NF_IPTABLES=m, but missed the fact that there are still
similarly broken configurations.

Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/xt_TEE.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 475957cfcf50..0d0d68c989df 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -38,7 +38,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -141,7 +141,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.destroy    = tee_tg_destroy,
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TEE",
 		.revision   = 1,
-- 
2.9.0
