From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: nf_conntrack_ipv6: fix incorrect classification
	of IPv6 fragments as ESTABLISHED
Date: Tue,  6 Mar 2007 08:44:02 +0100 (MET)
Message-ID: <20070306074402.24479.30970.sendpatchset@localhost.localdomain>
References: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ipv6: fix incorrect classification of IPv6 fragments as ESTABLISHED

The individual fragments of a packet reassembled by conntrack have the
conntrack reference from the reassembled packet attached, but nfctinfo
is not copied. This leaves it initialized to 0, which unfortunately is
the value of IP_CT_ESTABLISHED.

The result is that all IPv6 fragments are tracked as ESTABLISHED,
allowing them to bypass a usual ruleset which accepts ESTABLISHED
packets early.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5bd8638bfa97ebf5ff7765ed06fccd594108e92f
tree 8adea214d03250ab3d1babdcb84706684c550874
parent 393e32c96abe68f7aa2a399b4600dfba8b15a83b
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 06:53:14 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 07:15:45 +0100

 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 6f19c4a..d110245 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -257,6 +257,7 @@ static unsigned int ipv6_conntrack_in(un
 		}
 		nf_conntrack_get(reasm->nfct);
 		(*pskb)->nfct = reasm->nfct;
+		(*pskb)->nfctinfo = reasm->nfctinfo;
 		return NF_ACCEPT;
 	}
 
