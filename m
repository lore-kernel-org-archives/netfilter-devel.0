From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 6/8]: pptp helper: fix buffer overflow
Date: Fri, 16 Sep 2005 00:44:54 +0200
Message-ID: <4329F966.50403@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="06.diff"
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

[NETFILTER]: pptp helper: fix buffer overflow

reqlen directly depends on skb->len and is used as argument to
skb_header_pointer, which copies the data to _pptpReq if it is
in the non-linear area.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2834891111a5574444e4af9a6b1fd496a3359f2b
tree f02ddf7e154110ea3514731843a743286d9ee240
parent d7ea87423cdd670f2dbb737d2baf1cceaa78346c
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:32:59 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:32:59 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -330,6 +330,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	}
 
 	reqlen = datalen - sizeof(struct pptp_pkt_hdr) - sizeof(_ctlh);
+	if (reqlen > sizeof(*pptpReq))
+		reqlen = sizeof(*pptpReq);
 	pptpReq = skb_header_pointer(*pskb, ctlhoff+sizeof(_ctlh),
 				     reqlen, &_pptpReq);
 	if (unlikely(!pptpReq)) {
@@ -535,6 +537,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		return NF_ACCEPT;
 	
 	reqlen = datalen - sizeof(struct pptp_pkt_hdr) - sizeof(_ctlh);
+	if (reqlen > sizeof(*pptpReq))
+		reqlen = sizeof(*pptpReq);
 	pptpReq = skb_header_pointer(*pskb, ctlhoff+sizeof(_ctlh), reqlen, 
 				     &_pptpReq);
 	if (!pptpReq)
