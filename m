From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/07]: nf_conntrack_h323: add missing T.120 address in
	OLCA
Date: Fri, 25 May 2007 00:02:14 +0200 (MEST)
Message-ID: <20070524215841.14308.81491.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_h323: add missing T.120 address in OLCA

Add missing process of T.120 address in OpenLogicalChannelAck signal.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a545fc8e2ac3c8c7bbb7315469d96bb4e7d8748
tree c06c911468eaf5c32531a940c5b740cdb41ab0fa
parent 6fdca918957ecf41e1b5c416df341cfa48080fcd
author Jing Min Zhao <zhaojingmin@vivecode.com> Thu, 24 May 2007 23:49:59 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:59 +0200

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
 
