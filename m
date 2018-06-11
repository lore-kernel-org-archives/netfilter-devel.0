From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/15] netfilter: xt_CT: Reject the non-null terminated string from user space
Date: Mon, 11 Jun 2018 11:22:19 +0200
Message-ID: <20180611092233.3219-2-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The helper and timeout strings are from user-space, we need to make
sure they are null terminated. If not, evil user could make kernel
read the unexpected memory, even print it when fail to find by the
following codes.

pr_info_ratelimited("No such helper \"%s\"\n", helper_name);

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 8790190c6feb..03b9a50ec93b 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -245,12 +245,22 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	}
 
 	if (info->helper[0]) {
+		if (strnlen(info->helper, sizeof(info->helper)) == sizeof(info->helper)) {
+			ret = -ENAMETOOLONG;
+			goto err3;
+		}
+
 		ret = xt_ct_set_helper(ct, info->helper, par);
 		if (ret < 0)
 			goto err3;
 	}
 
 	if (info->timeout[0]) {
+		if (strnlen(info->timeout, sizeof(info->timeout)) == sizeof(info->timeout)) {
+			ret = -ENAMETOOLONG;
+			goto err4;
+		}
+
 		ret = xt_ct_set_timeout(ct, par, info->timeout);
 		if (ret < 0)
 			goto err4;
-- 
2.11.0
