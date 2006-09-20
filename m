From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/39]: ipt_TTL: fix checksum update bug
Date: Wed, 20 Sep 2006 10:24:06 +0200 (MEST)
Message-ID: <20060920082458.14636.91715.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_TTL: fix checksum update bug

Fix regression introduced by the incremental checksum patches.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0c081f02b0a8b3a08aa5ddc888f9af834585d431
tree ff630777fb523976961ac8303d680c7cc0a00975
parent 56a0ea23e536624ad1ea186289bb5d686ca19425
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:47 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:47 +0200

 net/ipv4/netfilter/ipt_TTL.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 214d9d9..96e79cc 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -54,8 +54,8 @@ ipt_ttl_target(struct sk_buff **pskb,
 	}
 
 	if (new_ttl != iph->ttl) {
-		iph->check = nf_csum_update((iph->ttl << 8) ^ 0xFFFF,
-					    new_ttl << 8,
+		iph->check = nf_csum_update(ntohs((iph->ttl << 8)) ^ 0xFFFF,
+					    ntohs(new_ttl << 8),
 					    iph->check);
 		iph->ttl = new_ttl;
 	}
