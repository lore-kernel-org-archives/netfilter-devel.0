From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 68/69]: nf_nat: fix sparse warning
Date: Wed, 30 Jan 2008 21:18:38 +0100 (MET)
Message-ID: <20080130201835.29874.40011.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbYA3USi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:38 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: fix sparse warning

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5da2b9bf6eb8611637344f4da586d000c862e364
tree a895465adef1c57a6220f36ab1f3c83b8b0dcbaf
parent f4b1df40b6a6978e862bffcaa8d36aecf1220978
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100

 net/ipv4/netfilter/nf_nat_helper.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 4c02328..ca57f47 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -44,8 +44,7 @@ adjust_tcp_sequence(u32 seq,
 	struct nf_nat_seq *this_way, *other_way;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 
-	pr_debug("adjust_tcp_sequence: seq = %u, sizediff = %d\n",
-		 ntohl(seq), seq);
+	pr_debug("adjust_tcp_sequence: seq = %u, sizediff = %d\n", seq, seq);
 
 	dir = CTINFO2DIR(ctinfo);
 
