From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
 match inverted in 2.6.28?)
Date: Mon, 12 Jan 2009 08:43:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120835390.21692@fbirervta.pbzchgretzou.qr>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com> <1230779772.29793.31.camel@localhost> <496AD1C6.9080906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: matthltc@us.ibm.com, Matt Cross <matt.cross@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45420 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZALHnZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:43:25 -0500
In-Reply-To: <496AD1C6.9080906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 06:14, Patrick McHardy wrote:

> Matthew Helsley wrote:
>> On Wed, 2008-12-31 at 17:00 -0500, Matt Cross wrote:
>>> I think the work to move ebtables to use xtables broke ebtables.
>>> Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
>>> return value of the match functions was inverted so that they return 1
>>> (true) on matches instead of EBT_MATCH (0), and vice versa (look in
>>> ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
>>> EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.
>>>
>>> The patch at the end of this message fixes the problem, but seems a
>>> little hacky to me.  Who's the right person to address this?
>
> Jan, could you have a look at this please?

That seemds indeed so.
Patch is both for 2.6.29-running and 2.6.28.

parent 1e8ca9528de86bdb2d73fbdfb27a10131bb5c593 (v2.6.29-rc1-21-g1e8ca95)
commit cc46eb3e855b7c1f628e934e01b97f4f2642973e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 08:40:22 2009 +0100

netfilter: ebtables: fix inversion in match code

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index fa108c4..9f46235 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -79,7 +79,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
-	return m->u.match->match(skb, par);
+	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
-- 
# Created with git-export-patch
