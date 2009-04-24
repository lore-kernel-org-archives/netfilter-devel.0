From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_recent compat code supposedly broken
Date: Fri, 24 Apr 2009 10:54:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904241050030.22023@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0904241032310.20106@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josef Drexler <joe-lk@ttdpatch.net>,
	Roman Hoog Antink <rha@open.ch>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51931 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZDXIyx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:54:53 -0400
In-Reply-To: <alpine.LSU.2.00.0904241032310.20106@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2009-04-24 10:43, Jan Engelhardt wrote:

>>Linux kernels 2.6.28 and 2.6.29 seem to have troubles, applying iptables
>>rules correctly that use the recent match.

The standard code has been fixed in 2.6.29 by Josef Drexler.

>>It seems, that on kernel 2.6.29, only the COMPAT option is buggy. On kernel
>>2.6.28 (used by Jaunty) however, xt_recent.ko has no effect on iptables rules.

Right. Here is a compile-tested patch. When confirmed by Roman (seems to 
have a source tree handy ;-) , this should be going into -stable too. 
Affected: 2.6.28, 2.6.29, running 2.6.30-rc.
Those casts pretty much looked suspicious enough, heh.

I guess now I can also reply to 325fb5b4's question-in-commit: "Possible 
solutions: (1) initialize the addr variable in recent_mt_proc_write, or 
(2) compare only 4 bytes for IPv4 addresses in recent_entry_lookup". The 
presence of the cast that are being removed with this patch suggest that 
originally, somehow, only X bytes were compared, depending on NFPROTO_* 
that was passed around. Looks like that never came about though, so I 
think we should stick with (1)-style code for xt_recent.

--->8---
parent 415a0779776ba14dd7895e13c02519f76fab0b65 (v2.6.30-rc1-424-g415a077)
commit e7051c8bd856f4197cdb791dfa76ab31ba07824d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Apr 24 10:42:12 2009 +0200

netfilter: xt_recent: fix stack overread in compat code

Related-to: commit 325fb5b4d26038cba665dd0d8ee09555321061f0

The compat path suffers from a similar problem. It only uses a __be32
when all of the recent code uses, and expects, an nf_inet_addr
everywhere. As a result, addresses stored by xt_recents were
filled with whatever other stuff was on the stack following the be32.

Reported-by: Roman Hoog Antink <rha@open.ch>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_recent.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 791e030..fcc2d7b 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -474,7 +474,7 @@ static ssize_t recent_old_proc_write(struct file *file,
 	struct recent_table *t = pde->data;
 	struct recent_entry *e;
 	char buf[sizeof("+255.255.255.255")], *c = buf;
-	__be32 addr;
+	struct nf_inet_addr addr = {};
 	int add;
 
 	if (size > sizeof(buf))
@@ -506,14 +506,13 @@ static ssize_t recent_old_proc_write(struct file *file,
 		add = 1;
 		break;
 	}
-	addr = in_aton(c);
+	addr.ip = in_aton(c);
 
 	spin_lock_bh(&recent_lock);
-	e = recent_entry_lookup(t, (const void *)&addr, NFPROTO_IPV4, 0);
+	e = recent_entry_lookup(t, &addr, NFPROTO_IPV4, 0);
 	if (e == NULL) {
 		if (add)
-			recent_entry_init(t, (const void *)&addr,
-					  NFPROTO_IPV4, 0);
+			recent_entry_init(t, &addr, NFPROTO_IPV4, 0);
 	} else {
 		if (add)
 			recent_entry_update(t, e);
-- 
# Created with git-export-patch
