From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: TEE only
Date: Wed, 14 Apr 2010 13:15:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de> <4BC59F93.8090209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43430 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0DNLPl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:15:41 -0400
In-Reply-To: <4BC59F93.8090209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-04-14 12:57, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> in this round:
>> - use IP6SKB_REROUTED in v6 code
>> - pick_net function: use skb->dev or skb->dst->dev when available
>>   (or completely fall back to init_net in case there's something
>>   going on)
>
>So what about oif routing which I asked for two times?

Guess it must have fallen off somewhere between the resends. We can 
still add it as a patch on top.

>I guess you'd usually have a host for logging or IDS somewhere on a
>private network and TEE packets there. So specifying oif and gateway
>seems most useful to me.

The oif is already determined by the route to the gateway(logging
host). I'd also fear that people abuse TEE as a ROUTE replacement
when they see an --oif.
