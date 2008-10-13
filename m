From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/6] [PATCH] remove module dependency between ctnetlink
 and	nf_nat
Date: Mon, 13 Oct 2008 16:06:34 +0200
Message-ID: <48F355EA.7050104@netfilter.org>
References: <20081011152116.6436.17277.stgit@Decadence> <20081011152312.6436.15322.stgit@Decadence> <48F3520B.7010306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58444 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbYJMOHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:07:46 -0400
In-Reply-To: <48F3520B.7010306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> I really can't get the other patches in at this point since they
> don't really qualify as bug fixes. I'll start a nf-next tree once
> Dave opens up the net-next tree, which will be in about two weeks.

OK, I'll keep the patches in a internal queue and I'll resend them once
you announce your nf-next tree in the ML.

BTW, should I re-send even those that didn't not hit 2.6.28 but you said
that were applied, I mean, for example:

http://marc.info/?l=netfilter-devel&m=122355881514337&w=2
http://marc.info/?l=netfilter-devel&m=122355885514404&w=2
http://marc.info/?l=netfilter-devel&m=122364391728099&w=2

I don't mind about doing so.

> Sorry about that, I know its partially my fault.

Never mind, shit happens, I'm fine with having these into 2.6.29. That
will give me more time to synchronize a conntrack-tools 1.0 and a
ctnetlink 1.0 release.

BTW, I still have to send three patches to -stable, I'm going to do that
now, but what tree should I use to diff the changes? The patch should go
into 2.6.24, .25, and .26.

> I've tried applying this without the others, and it applies and
> compiled cleanly with one minor reject:
> 
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -445,7 +445,7 @@ static inline size_t
>> calculate_helper_room_size(const struct nf_conn *ct)
>>  {
>>      const struct nf_conn_help *help = nfct_help(ct);
>>      struct nf_conntrack_helper *helper;
>> -    size_t size;
>> +    size_t size = 0;
>>  
>>      if (!help)
>>          goto out;
> 
> This chunk doesn't apply, but it doesn't seem to belong in the patch
> anyway.

Sorry, this belongs to patch 5/6.

> Do you want me to apply the patch as attached to this email, or would
> you prefer to rediff it?

No, I'll send you a new patchset once you set your tree. This patch also
needs to include the nfnl_lock/nfnl_unlock logic.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
