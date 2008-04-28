From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: xt_TCPOPTSTRIP: signed tcphoff for	ipv6_skip_exthdr() retval
Date: Tue, 29 Apr 2008 00:06:41 +0200 (MEST)
Message-ID: <20080428220645.18270.96401.sendpatchset@localhost.localdomain>
References: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33386 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbYD1WGn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:06:43 -0400
In-Reply-To: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_TCPOPTSTRIP: signed tcphoff for	ipv6_skip_exthdr() retval

if tcphoff remains unsigned, a negative ipv6_skip_exthdr() return value will
go unnoticed,

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 409c904821b52f9c4597ca87f3ab01b55183904e
tree 648fe90316d4c3d8e714ceefc9137325e8ef8417
parent 358c12953b88c5a06a57c33eb27c753b2e7934d1
author Roel Kluin <12o3l@tiscali.nl> Mon, 28 Apr 2008 20:58:54 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 28 Apr 2008 20:58:54 +0200

 net/netfilter/xt_TCPOPTSTRIP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 3b2aa56..9685b6f 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -90,7 +90,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 		const struct xt_target *target, const void *targinfo)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	unsigned int tcphoff;
+	int tcphoff;
 	u_int8_t nexthdr;
 
 	nexthdr = ipv6h->nexthdr;
