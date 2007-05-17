From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH] H.323: Add missing T.120 address in OLCA
Date: Thu, 17 May 2007 16:00:33 -0400 (EDT)
Message-ID: <20070517200033.B49F93DA1F7@jzhao.vivecode.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Add missing process of T.120 address in OpenLogicalChannelAck signal.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
 net/netfilter/nf_conntrack_h323_main.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6d668af..a1b95ac 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -520,6 +520,16 @@ static int process_olca(struct sk_buff **pskb, struct nf_conn *ct,
 		}
 	}
 
+	if ((olca->options & eOpenLogicalChannelAck_separateStack) &&
+		olca->separateStack.networkAddress.choice ==
+		eNetworkAccessParameters_networkAddress_localAreaAddress) {
+		ret = expect_t120(pskb, ct, ctinfo, data, dataoff,
+				  &olca->separateStack.networkAddress.
+				  localAreaAddress);
+		if (ret < 0)
+			return -1;
+	}
+
 	return 0;
 }
 
-- 
1.4.4.3
