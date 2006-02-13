From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3] attach conntrack to locally generated ICMPv6 error
Date: Tue, 14 Feb 2006 01:30:36 +0900 (JST)
Message-ID: <200602131630.k1DGUb9m020273@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org, kaber@trash.net, laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="03-icmpv6-error-attach.patch"
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

[NETFILTER]: attach conntrack to locally generated ICMPv6 error

The locally generated ICMPv6 error should be associated with the conntrack
of original packet. But the conntrack may be discarded before nf_conntrack
tracks it, then nf_conntrack has no way to associate them. This makes
ICMPv6 processing do that instead.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit eedd46296619657aecd1d3fae27c001db879bf39
tree 1a96711e85fd0d8f0fa6cf5f825b91775a440204
parent a17cfc5ef47d98a67694b08ca93a94d961434a18
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 09 Feb 2006 02:28:25 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 09 Feb 2006 02:28:25 +0900

 net/ipv6/icmp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fcf8831..21eb725 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -42,6 +42,7 @@
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
+#include <linux/netfilter.h>
 
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
@@ -255,6 +256,7 @@ out:
 struct icmpv6_msg {
 	struct sk_buff	*skb;
 	int		offset;
+	uint8_t		type;
 };
 
 static int icmpv6_getfrag(void *from, char *to, int offset, int len, int odd, struct sk_buff *skb)
@@ -266,6 +268,8 @@ static int icmpv6_getfrag(void *from, ch
 	csum = skb_copy_and_csum_bits(org_skb, msg->offset + offset,
 				      to, len, csum);
 	skb->csum = csum_block_add(skb->csum, csum, odd);
+	if (!(msg->type & ICMPV6_INFOMSG_MASK))
+		nf_ct_attach(skb, org_skb);
 	return 0;
 }
 
@@ -403,6 +407,7 @@ void icmpv6_send(struct sk_buff *skb, in
 
 	msg.skb = skb;
 	msg.offset = skb->nh.raw - skb->data;
+	msg.type = type;
 
 	len = skb->len - msg.offset;
 	len = min_t(unsigned int, len, IPV6_MIN_MTU - sizeof(struct ipv6hdr) -sizeof(struct icmp6hdr));
@@ -500,6 +505,7 @@ static void icmpv6_echo_reply(struct sk_
 
 	msg.skb = skb;
 	msg.offset = 0;
+	msg.type = ICMPV6_ECHO_REPLY;
 
 	err = ip6_append_data(sk, icmpv6_getfrag, &msg, skb->len + sizeof(struct icmp6hdr),
 				sizeof(struct icmp6hdr), hlimit, tclass, NULL, &fl,
