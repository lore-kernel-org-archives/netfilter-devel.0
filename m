From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_conntrack: attach conntrack to locally
	generated ICMPv6 error
Date: Thu, 16 Feb 2006 00:00:32 +0100 (MET)
Message-ID: <20060215230032.25078.64555.sendpatchset@localhost.localdomain>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: attach conntrack to locally generated ICMPv6 error

Locally generated ICMPv6 errors should be associated with the conntrack
of the original packet. Since the conntrack entry may not be in the hash
tables (for the first packet), it must be manually attached.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a01ef7ba3866e0c920f804f153166f162bcb2a1f
tree 8a164639758c51e7f41453ed1736a49e0456becc
parent 257b70114334c5cee6f8b1f4789f49cc570fac45
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 15 Feb 2006 11:08:54 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 15 Feb 2006 11:08:54 +0100

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
