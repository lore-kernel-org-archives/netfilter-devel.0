From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 11/11] netfilter: xtables: convert basic nfproto match
 functions into xt matches
Date: Tue, 11 May 2010 15:38:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005111516030.26950@obet.zrqbmnf.qr>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de> <1272880297-11198-12-git-send-email-jengelh@medozas.de> <4BE95496.1000709@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51100 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab0EKNip (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 09:38:45 -0400
In-Reply-To: <4BE95496.1000709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-05-11 14:59, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> Each table implementation has a private built-in hardwired match
>> function for its corresponding nfproto data (e.g. ip_tables: struct
>> ipt6_ip6 processed by ip6_packet_match to match against the IPv6
>> header, etc.)
>> 
>> Rewrite the functions so that they are independent xt_matches and can
>> be used from an nfproto-independent table.
>
>No major objections, but I'd like to know where this is going
>and when, so far this doesn't provide any benefit.

The plan, as posted last fall[1], is to continue generalizing the 
different iptables copies into one, bringing Xtables up to the next 
level, e.g. family-agnostic rulesets, while retaining 
compatibility.

[1] http://lwn.net/Articles/345176/

The "when" originally was 2.6.32, but I got a little slacky in doing 
requested benchmarks, so it had practically postponed itself to the 
current cycle, 2.6.35. If my counting is right, ~41 patches of that 
list[1] have been merged, and while doing that, 46 concurrent 
commits/ideas of mine have also been merged.

There are at least 60 patches left however, and that does not include 
any comments from your side. I guess I don't get to spool and flush the 
entire queue to 2.6.35 anymore - "better luck next time", or?

>And as always, please format things like
>
>> +	ret = ifname_compare_aligned((par->in == NULL) ? nulldevname :
>> +	      par->in->name, ipinfo->iniface, ipinfo->iniface_mask);
>
>so the arguments are neatly aligned. F.i.
>
>	ret = ifname_compare_aligned(!par->in ? nulldevname : par->in->name,
>				     ipinfo->iniface, ipinfo->iniface_mask);
>
>would work nicely.
>

Will revisit.
