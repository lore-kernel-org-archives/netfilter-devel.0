From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_core: Updated nf_conntrack to destroy/refresh
 conn irrespective of del_timer status
Date: Fri, 29 Feb 2008 13:23:41 +0100
Message-ID: <47C7F94D.5020801@trash.net>
References: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com> <47C2B056.3010609@trash.net> <2A6F278C5B66C4459AF4013E77A40CD30122F288@zin33exm20.fsl.freescale.net> <47C55F08.9070905@trash.net> <2A6F278C5B66C4459AF4013E77A40CD30122F862@zin33exm20.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Medve Emilian <Emilian.Medve@freescale.com>
To: Juneja Kapil <Kapil.Juneja@freescale.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:58300 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756115AbYB2MXy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:23:54 -0500
In-Reply-To: <2A6F278C5B66C4459AF4013E77A40CD30122F862@zin33exm20.fsl.freescale.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Juneja Kapil wrote:
> Hi Patrick,
> 
>> That sounds pretty reasonable. Is that code available somewhere?
 >
> We are working on licensing aspects and will be glad to share the code
> as and when we get approval.
>

OK thanks.

>>> Can you describe the race scenario mentioned by you?
 >>
>> Very simple:
>>
>> CPU0					CPU1
>> 					timer goes off
>> refresh_timer: mod_timer, rearm		death_by_timeout()
>>
>> timer goes off again
>>
>> Using del_timer prevents us from rearming the timer if it 
>> already went off.
> 
> Thanks for the explanation. I was probably only thinking of the non-SMP
> scenarios. However, I feel that if this cannot be done this simple way,
> then we are in a bit trouble because our need is to make
> nf_ct_refresh_acct work independent of the existing timer being dead or
> alive. 
> While we think about a possible alternatives on respin of patch/control
> module, can you provide some insight into any other alternatives.


The IPS_FIXED_TIMEOUT_BIT should work I guess. It skips
timer updates, but still does accounting (at least in
the current kernel version).
