From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: ip6_tables: use correct nexthdr value in
	ipv6_find_hdr()
Date: Tue, 14 Nov 2006 08:03:32 +0100 (MET)
Message-ID: <20061114070332.13023.87730.sendpatchset@localhost.localdomain>
References: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_tables: use correct nexthdr value in ipv6_find_hdr()

nexthdr is NEXTHDR_FRAGMENT, the nexthdr value from the fragment header
is hp->nexthdr.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 85ac8773cc9bc1301cd3be323cb046c0b98998b7
tree 97048b2f41047e7f2bf440fe5ca8ec9986e3fe5c
parent 73d0810541a170f679076824e0a8765ea6017a10
author Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:57:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:57:54 +0100

 net/ipv6/netfilter/ip6_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 167c2ea..204e021 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1494,7 +1494,7 @@ int ipv6_find_hdr(const struct sk_buff *
 			if (_frag_off) {
 				if (target < 0 &&
 				    ((!ipv6_ext_hdr(hp->nexthdr)) ||
-				     nexthdr == NEXTHDR_NONE)) {
+				     hp->nexthdr == NEXTHDR_NONE)) {
 					if (fragoff)
 						*fragoff = _frag_off;
 					return hp->nexthdr;
