From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/3] xt_owner match
Date: Mon, 19 Nov 2007 18:12:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711191810380.32378@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711161400360.3340@fbirervta.pbzchgretzou.qr>
 <4741AF25.5080604@trash.net> <Pine.LNX.4.64.0711191751580.32378@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711191807140.32378@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57443 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbXKSRMd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:12:33 -0500
In-Reply-To: <Pine.LNX.4.64.0711191807140.32378@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 19 2007 18:08, Jan Engelhardt wrote:
>On Nov 19 2007 17:56, Jan Engelhardt wrote:
>>>
>>>> +	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
>>>> +		return false;
>>>> +
>>>> +	filp = skb->sk->sk_socket->file;
>>>> +	if (filp == NULL)
>>>> +		return false;
>>>
>>> What would be nice is to allow matching whether a socket exists,
>>> without UID/GID. I had a patch for this for a long time, but
>>> lost it somewhere.
>>
>>Do you mean xt_socket from TPROXY?
>
>Ah, xt_socket is different. But yeah, what you suggest is already implemented.
>It is a matter of adjusting the iptables part now to actually make use
>of the feature (to match whether a socket exists, w/o owner/group).

Speaking... xt_owner currently has

	.hooks = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_POST_ROUTING),

All outgoing packets do have a socket, don't they? So the quest for
"whether a socket exists" implies you want me to add (1 <<
NF_INET_LOCAL_IN), (1 << NF_INET_PRE_ROUTING) and (1 <<
NF_INET_FORWARD) too?


thanks,
Jan
