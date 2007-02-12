From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/22]: ip6t_mh: drop piggyback payload packet on MH
	packets
Date: Mon, 12 Feb 2007 11:36:51 +0100 (MET)
Message-ID: <20070212103651.661.8735.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6t_mh: drop piggyback payload packet on MH packets

Regarding RFC3775, MH payload proto field should be IPPROTO_NONE. Otherwise
it must be discarded (and the receiver should send ICMP error).

We assume filter should drop such piggyback everytime to disallow slipping
through firewall rules, even the final receiver will discard it.

Signed-off-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a7b4ff1031d3e62fad2b7da2068bb5deb2041325
tree ba6d4b4517999ebf0876a5618640276a6a251503
parent 353c941b0735b883510bfd7bb98fcd4fc8a0ee08
author Masahide NAKAMURA <nakam@linux-ipv6.org> Mon, 12 Feb 2007 11:08:11 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:11 +0100

 net/ipv6/netfilter/ip6t_mh.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index 2c7efc6..c2a9098 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -66,6 +66,13 @@ match(const struct sk_buff *skb,
 		return 0;
 	}
 
+	if (mh->ip6mh_proto != IPPROTO_NONE) {
+		duprintf("Dropping invalid MH Payload Proto: %u\n",
+			 mh->ip6mh_proto);
+		*hotdrop = 1;
+		return 0;
+	}
+
 	return type_match(mhinfo->types[0], mhinfo->types[1], mh->ip6mh_type,
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
