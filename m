From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: nf_nat_sip: don't drop short packets
Date: Tue, 14 Aug 2007 18:40:19 +0200 (MEST)
Message-ID: <20070814164011.14668.44375.sendpatchset@localhost.localdomain>
References: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat_sip: don't drop short packets

Don't drop packets shorter than "SIP/2.0", just ignore them. Keep-alives
can validly be shorter for example.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 12ad6c49be7b0cb1e9f32750e34cde5d29d40a48
tree 6dc3ff60e52adc58a3a02d725f819cc6811b1664
parent 492d0e43049e7f420c1c64044ab57abf278fbead
author Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:58 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:58 +0200

 net/ipv4/netfilter/nf_nat_sip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index a889ec3..e14d419 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -104,7 +104,7 @@ static unsigned int ip_nat_sip(struct sk_buff **pskb,
 	dataoff = ip_hdrlen(*pskb) + sizeof(struct udphdr);
 	datalen = (*pskb)->len - dataoff;
 	if (datalen < sizeof("SIP/2.0") - 1)
-		return NF_DROP;
+		return NF_ACCEPT;
 
 	addr_map_init(ct, &map);
 
