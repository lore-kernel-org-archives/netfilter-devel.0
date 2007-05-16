From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: nf_conntrack_ipv4: fix incorrect #ifdef config name
Date: Wed, 16 May 2007 18:54:41 +0200
Message-ID: <464B3751.8020902@trash.net>
Mime-Version: 1.0
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: nf_conntrack_ipv4: fix incorrect #ifdef config name

The option is named CONFIG_NF_NAT not CONFIG_IP_NF_NAT. Remove the ifdef
completely since helpers also expect defragmented packet even without
NAT.

Noticed by Robert P. J. Day <rpjday@mindspring.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4fa9ec238fd61ffd3e6f36f67ed5730db018d00c
tree 6282a1f52b4f32664c7bdc0e95f8c593cdf000b7
parent a49738a0ca6dbe54bbc6672b52286ed6b1d8f4ce
author Patrick McHardy <kaber@trash.net> Wed, 16 May 2007 18:51:44 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 16 May 2007 18:51:44 +0200

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 0654eaa..fd62a41 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -154,12 +154,10 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
-#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if ((*pskb)->nfct)
 		return NF_ACCEPT;
-#endif
 
 	/* Gather fragments. */
 	if (ip_hdr(*pskb)->frag_off & htons(IP_MF | IP_OFFSET)) {
