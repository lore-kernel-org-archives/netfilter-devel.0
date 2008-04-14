From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] Combine ipt and ip6t manpages
Date: Mon, 14 Apr 2008 09:00:36 +0200
Message-ID: <48030114.2050805@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <b99189c17a0a98eee21175c1ea2fe9818e4b2892.1208075035.git.jengelh@computergmbh.de> <4802FD56.3080707@trash.net> <alpine.LNX.1.10.0804140854340.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63610 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYDNHAl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:00:41 -0400
In-Reply-To: <alpine.LNX.1.10.0804140854340.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-04-14 08:44, Patrick McHardy wrote:
>>>  delete mode 100644 extensions/libipt_policy.man
>>>  rename extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} (77%)
>>>  rename extensions/{libip6t_TRACE.man => libxt_TRACE.man} (94%)
>>>  rename extensions/{libipt_connlimit.man => libxt_connlimit.man} (100%)
>>>  create mode 100644 extensions/libxt_length.man
>>>  rename extensions/{libipt_multiport.man => libxt_multiport.man} (100%)
>>>  rename extensions/{libip6t_policy.man => libxt_policy.man} (100%)
>>>  rename extensions/{libipt_tcp.man => libxt_tcp.man} (100%)
>> Please send a unidiff that includes all those renames
>> so I can apply it using "patch".
>>
> commit 94b7a2a14adc13fdd667d3f06212922e21416e43
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Feb 14 03:02:55 2008 +0100
> 
>     Combine ipt and ip6t manpages

Applied, thanks.
