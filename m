From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/69]: nf_log: add netfilter gcc printf format checking
Date: Wed, 30 Jan 2008 21:17:04 +0100 (MET)
Message-ID: <20080130201702.29874.29208.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60656 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765621AbYA3URG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:06 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_log: add netfilter gcc printf format checking

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1b8b1c29feb7a42aceb8f62ea9378d492437acbe
tree b56dae8df90443115cb7eff3199a160be17b9631
parent 62069912fa544382934395362fb73205475474d4
author Helge Deller <deller@gmx.de> Tue, 29 Jan 2008 16:21:53 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:13 +0100

 include/net/netfilter/nf_log.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 037e824..8c6b5ae 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -54,6 +54,6 @@ void nf_log_packet(int pf,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   const struct nf_loginfo *li,
-		   const char *fmt, ...);
+		   const char *fmt, ...) __attribute__ ((format(printf,7,8)));
 
 #endif /* _NF_LOG_H */
