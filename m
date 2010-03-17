From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/9] netfilter: xtables: limit xt_mac to ethernet
 devices
Date: Wed, 17 Mar 2010 14:37:33 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171434550.6297@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-6-git-send-email-jengelh@medozas.de> <4BA0D9B1.4050809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34088 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0CQNhe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:37:34 -0400
In-Reply-To: <4BA0D9B1.4050809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-17 14:31, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> I do not see a point of allowing the MAC module to work with devices
>> that don't possibly have one, e.g. various tunnel interfaces such as
>> tun and sit.
>
>> @@ -29,6 +30,8 @@ static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>>  	const struct xt_mac_info *info = par->matchinfo;
>>  	bool ret;
>>  
>> +	if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
>> +		return false;
>
>What about the ~60 ARPHRD values that are not tunnels and sit?

xt_mac uses eth_hdr(skb), so it makes sense to limit it to ethernet, as 
we cannot be sure of the exact frame formats of other link layers.
Do you have an alternate proposal?

