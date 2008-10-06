From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 07/23] netfilter: xtables: do centralized checkentry call
 (1/2)
Date: Mon, 6 Oct 2008 12:39:00 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810061232490.10698@fbirervta.pbzchgretzou.qr>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de> <48EA3B7F.9000007@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47856 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYJFQjC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:39:02 -0400
In-Reply-To: <48EA3B7F.9000007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-06 12:23, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> It used to be that {ip,ip6,etc}_tables called extension->checkentry
>> themselves, but this can be moved into the xtables core.
>
> This one doesn't apply cleanly:
>
> patching file net/bridge/netfilter/ebtables.c
> Hunk #3 FAILED at 684.
> 1 out of 3 hunks FAILED -- saving rejects to file
> net/bridge/netfilter/ebtables.c.rej
>
> Since I guess this will introduce new rejects in the following
> patches, I'll wait until you've figured out what went wrong.
> I've applied the patches in the order specified on top of
> 8d51a6615, replacing the previous patches.

By logic alone already, I can say I dunno what's going on.
SHAshing in git ensures that the SHA identifies all ancestors.
Unless perhaps, we found the first hash collision...
You could repush your tree and let me check, or you can check
with mine at git://dev.medozas.de/linux master
There is something that diffs cannot do - ensure proper
parent and tree SHAs ;-)
