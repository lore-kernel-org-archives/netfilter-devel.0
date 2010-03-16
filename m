From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/10] netfilter: xtables: merge xt_NOTRACK into xt_CT
Date: Tue, 16 Mar 2010 18:16:16 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003161814340.25891@obet.zrqbmnf.qr>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de> <1268703135-2622-7-git-send-email-jengelh@medozas.de> <4B9FB972.7010207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55018 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab0CPRQR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:16:17 -0400
In-Reply-To: <4B9FB972.7010207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-03-16 18:01, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> ---
>>  net/netfilter/Kconfig      |   21 +++++------------
>>  net/netfilter/Makefile     |    1 -
>>  net/netfilter/xt_CT.c      |   54 ++++++++++++++++++++++++++++++++++---------
>>  net/netfilter/xt_NOTRACK.c |   53 -------------------------------------------
>>  4 files changed, 48 insertions(+), 81 deletions(-)
>>  delete mode 100644 net/netfilter/xt_NOTRACK.c
>
>Since CT is supposed to obsolete NOTRACK, I don't want to merge
>these two. Better schedule it for removal in one or two years.

Ok, perfect. Just skip this patch then for now. (Should I update the git 
branch?)

I'll send you another patch later on documenting the fact in 
Documentation/feature-removal-schedule.txt in one of the next 
microrounds.

thanks,
Jan
