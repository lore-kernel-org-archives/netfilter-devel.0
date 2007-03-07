From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/13]: nf_conntrack: fix incorrect classification of
	IPv6 fragments as ESTABLISHED
Date: Wed,  7 Mar 2007 22:34:42 +0100 (MET)
Message-ID: <20070307213402.22306.75367.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED

The individual fragments of a packet reassembled by conntrack have the
conntrack reference from the reassembled packet attached, but nfctinfo
is not copied. This leaves it initialized to 0, which unfortunately is
the value of IP_CT_ESTABLISHED.

The result is that all IPv6 fragments are tracked as ESTABLISHED,
allowing them to bypass a usual ruleset which accepts ESTABLISHED
packets early.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dde28ec33796ecfc28f2d49b870dffac050834a9
tree dca0224d4a05373dab0c27db8bf4b2793a7dc35b
parent af72e6f0118b0361f8d4c933add715ca9c28cba3
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100

 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index a20615f..6155b80 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -257,6 +257,7 @@ static unsigned int ipv6_conntrack_in(un
 		}
 		nf_conntrack_get(reasm->nfct);
 		(*pskb)->nfct = reasm->nfct;
+		(*pskb)->nfctinfo = reasm->nfctinfo;
 		return NF_ACCEPT;
 	}
 
