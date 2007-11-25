From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC NETFILTER 2/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:36:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251835070.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACD4.4010407@trash.net> <Pine.LNX.4.64.0711251824480.9477@fbirervta.pbzchgretzou.qr>
 <4749B0F8.4050500@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54629 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXKYRgf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:36:35 -0500
In-Reply-To: <4749B0F8.4050500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 25 2007 18:29, Patrick McHardy wrote:
>> > +	spin_lock_bh(&info->est1->lock);
>> > +	rstats	= &info->est1->rstats;
>> > +	if (info->flags & XT_RATEEST_MATCH_DELTA) {
>> > +		bps1	= info->bps1 >= rstats->bps ?
>> > +					info->bps1 - rstats->bps : 0;
>> > +		pps1	= info->pps1 >= rstats->pps ?
>> > +					info->pps1 - rstats->pps : 0;
>> > +	} else {
>> > +		bps1	= rstats->bps;
>> > +		pps1	= rstats->pps;
>> > +	}
>> > +	spin_unlock_bh(&info->est1->lock);
>> > +
>> > +	if (info->flags & XT_RATEEST_MATCH_ABS) {
>> > +		bps2	= info->bps2;
>> > +		pps2	= info->pps2;
>> 
>> I think you can cut down on the extra whitespace around = here,
>> it already lines up nicely anyway.
>
> True, that needs some reformatting anyway, especially the ? .. : ..
> looks weird.
>

Try moving the assign-zero out of the if;
Or maybe it is already zero.

	rstats = &info->est1->rstat;
	bps1 = 0;
	pps1 = 0;
	if (delta) {
		if (info->bps1 >= rstats->bps)
			bps1 = info->bps1 - rstats->bps;
		if (info->pps1 >= rstats->pps)
			pps1 = info->pps1 - rstats->pps;
	} else ...
