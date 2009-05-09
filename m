From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 07/11] netfilter: xtables: reduce indent level by one
Date: Sat, 9 May 2009 06:00:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905090553080.13691@fbirervta.pbzchgretzou.qr>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de> <1241774801-2315-8-git-send-email-jengelh@medozas.de> <4A04E59B.7040503@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41383 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZEIEAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 May 2009 00:00:30 -0400
In-Reply-To: <4A04E59B.7040503@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-05-09 04:08, Amos Jeffries wrote:
> Jan Engelhardt wrote:
>> Cosmetic only. Transformation applied:
>>
>> 	-if (foo) { long block; } else { short block; }
>> 	+if (!foo) { short block; continue; } long block;
>>
>> -			if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
>> -				goto no_match;
>> +		if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
>> +			goto no_match;
>
> Didn't your patch just earlier remove these no_match jumps from xtables?

You are looking at patch #07/11, the gotos are removed in patch #08/11.
