From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Clear padding area in __nfa_fill
Date: Sat, 23 Jul 2005 08:18:43 +0200
Message-ID: <42E1E143.9000902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="x"
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

[NETFILTER]: Clear padding area in __nfa_fill

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7c94d9d3651cf88afe53123c313dd6714856bbd2
tree 1c7baec1d144ce7801208de9522aa64e7f645152
parent a6b1cad65cc50bf64093ed442004e0851d41c8dd
author Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 08:18:08 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 08:18:08 +0200

 net/netfilter/nfnetlink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -121,6 +121,7 @@ void __nfa_fill(struct sk_buff *skb, int
 	nfa->nfa_type = attrtype;
 	nfa->nfa_len  = size;
 	memcpy(NFA_DATA(nfa), data, attrlen);
+	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
 }
 
 int nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
