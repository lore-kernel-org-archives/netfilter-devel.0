From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] xtables: use guarded types
Date: Thu, 16 Dec 2010 08:28:50 +0100
Message-ID: <4D09BFB2.7040504@trash.net>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr> <4D01FFC5.90808@netfilter.org> <4D093A49.2060500@trash.net> <alpine.LNX.2.01.1012152319550.2669@obet.zrqbmnf.qr> <4D09457C.5050302@trash.net> <alpine.LNX.2.01.1012160120480.2669@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34709 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0LPH2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:28:51 -0500
In-Reply-To: <alpine.LNX.2.01.1012160120480.2669@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.12.2010 01:27, Jan Engelhardt wrote:
> 
> On Wednesday 2010-12-15 23:47, Patrick McHardy wrote:
>>>>
>>>> I'll also gladly apply a patch to get rid of the u_int_XX crap.
>>>
>>> To be found where? (Choose: kernel/userspace/both)
>>
>> Both I guess, but I was previously referring to the kernel.
> 
> I do not see the issue with using POSIX types outside of operating 
> system interface specifications.
> So I guess this is in order:
> 
> parent 3a84b3d5de492e40aff7bae5038b06dd6b6041c4 (v1.4.10-17-g3a84b3d)
> commit a069355b7933c9afe38b5cb7b251b2ece4fe8456
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Dec 16 00:59:27 2010 +0100
> 
> src: use C99/POSIX types
> 
> "u_int" was a non-standardized extension predating C99 on some platforms.

While I don't have a real personal preference, most of the remaining
networking stack uses uXX types and I know code has been actively
converted from C99 types to those. So for consistency we should also
use uXX. Sorry for not being clearer about that before.
