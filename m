From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 07/11] netfilter: xtables: reduce indent level by one
Date: Mon, 11 May 2009 01:39:14 +1200
Message-ID: <4A06D902.80003@treenet.co.nz>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de> <1241774801-2315-8-git-send-email-jengelh@medozas.de> <4A04E59B.7040503@treenet.co.nz> <alpine.LSU.2.00.0905090553080.13691@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:34640
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZEJNjV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 May 2009 09:39:21 -0400
In-Reply-To: <alpine.LSU.2.00.0905090553080.13691@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-05-09 04:08, Amos Jeffries wrote:
>> Jan Engelhardt wrote:
>>> Cosmetic only. Transformation applied:
>>>
>>> 	-if (foo) { long block; } else { short block; }
>>> 	+if (!foo) { short block; continue; } long block;
>>>
>>> -			if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
>>> -				goto no_match;
>>> +		if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
>>> +			goto no_match;
>> Didn't your patch just earlier remove these no_match jumps from xtables?
> 
> You are looking at patch #07/11, the gotos are removed in patch #08/11.

Ah, the weirdness introduced by splitting patches in to small tasks.
Gotcha.

Amos
