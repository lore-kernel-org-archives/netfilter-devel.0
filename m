From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] xtables: use guarded types
Date: Sat, 18 Dec 2010 00:04:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012180003440.28078@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr> <4D01FFC5.90808@netfilter.org> <4D093A49.2060500@trash.net> <alpine.LNX.2.01.1012152319550.2669@obet.zrqbmnf.qr>
 <4D09457C.5050302@trash.net> <alpine.LNX.2.01.1012160120480.2669@obet.zrqbmnf.qr> <4D09BFB2.7040504@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38589 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0LQXEN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:04:13 -0500
In-Reply-To: <4D09BFB2.7040504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-12-16 08:28, Patrick McHardy wrote:
>>>
>>> Both I guess, but I was previously referring to the kernel.
>> 
>> I do not see the issue with using POSIX types outside of operating 
>> system interface specifications.
>> So I guess this is in order:
>> 
>> parent 3a84b3d5de492e40aff7bae5038b06dd6b6041c4 (v1.4.10-17-g3a84b3d)
>> commit a069355b7933c9afe38b5cb7b251b2ece4fe8456
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Dec 16 00:59:27 2010 +0100
>> 
>> src: use C99/POSIX types
>> 
>> "u_int" was a non-standardized extension predating C99 on some platforms.
>
>While I don't have a real personal preference, most of the remaining
>networking stack uses uXX types and I know code has been actively
>converted from C99 types to those. So for consistency we should also
>use uXX. Sorry for not being clearer about that before.

So is it ok if I push this patch along with the next batch?
