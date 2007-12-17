From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 47/64]: nf_log: remove incomprehensible comment
Date: Tue, 18 Dec 2007 00:47:17 +0100 (MET)
Message-ID: <20071217234716.23601.79231.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39028 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXLQXrS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:18 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_log: remove incomprehensible comment

Whatever that comment tries to say, I don't get it and it looks like
a leftover from the time when RCU wasn't used properly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b004f3f365c301797f4c40382faed4a4c220aeb1
tree f8c7da6965cdfef93363dba3f9bcb9a7be2afa0e
parent 31a70984a4c56f7141c77842bd4aa76835f4b1f1
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:37 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 net/netfilter/nf_log.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index ed9116d..4f5f288 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -91,7 +91,6 @@ void nf_log_packet(int pf,
 		va_start(args, fmt);
 		vsnprintf(prefix, sizeof(prefix), fmt, args);
 		va_end(args);
-		/* We must read logging before nf_logfn[pf] */
 		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
 	} else if (net_ratelimit()) {
 		printk(KERN_WARNING "nf_log_packet: can\'t log since "
