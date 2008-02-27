From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_core: Updated nf_conntrack to destroy/refresh
 conn irrespective of del_timer status
Date: Wed, 27 Feb 2008 14:00:56 +0100
Message-ID: <47C55F08.9070905@trash.net>
References: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com> <47C2B056.3010609@trash.net> <2A6F278C5B66C4459AF4013E77A40CD30122F288@zin33exm20.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Medve Emilian <Emilian.Medve@freescale.com>
To: Juneja Kapil <Kapil.Juneja@freescale.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:6531 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYB0NAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:00:53 -0500
In-Reply-To: <2A6F278C5B66C4459AF4013E77A40CD30122F288@zin33exm20.fsl.freescale.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Juneja Kapil wrote:
>> -----Original Message-----
>> From: Patrick McHardy [mailto:kaber@trash.net] 
>> Sent: Monday, February 25, 2008 5:41 PM
>> To: Juneja Kapil
>> Cc: netfilter-devel@vger.kernel.org; Medve Emilian
>> Subject: Re: [PATCH] nf_conntrack_core: Updated nf_conntrack 
>> to destroy/refresh conn irrespective of del_timer status
>>
>> Kapil Juneja wrote:
>>> Currently NF_CONNTRACK assumes that a running timer is 
>> present before refreshing
>>> the connection or destroying it. This may not be the case 
>> when, for example,
>>> another forwarding engine hooks up to it to listen to new 
>> connections
>>> but disables the NF_CONNTRACK timer in order to have more control.
>>> In such a scenario, only control packets may be terminated 
>> to NF_CONNTRACK for
>>> it to decode and update the connection status. It will not 
>> impact the present
>>> scenario of kernel forwarding without the aid of any 
>> forwarding engine. 
>>
>> Do you have a pointer to the code you're talking about?
> 
> The forwarding engine concept is  same as the Grand Unified Flow Cache
> idea mooted by Rusty Russel some time back:
> http://lwn.net/Articles/194443/
> 
> Our architecture runs on three components - Linux NF_CONNTRACK, a
> Control (Linux) Module(CM), and a Forwarding Engine or Flow Caching
> system (FC):
> 1) The CM registers itself to the NF_CONNTRACK notifier chain. Whenever
> an assured connection notifier event is received, it extracts all the
> relevant tuple parameters (Src IP, Dst IP, Protocol, Src Port, Dst Port
> etc.) and caches them to the FC. Due to reasons mentioned subsequently,
> it also disables the timer for the said conntrack object. The object,
> however, remains in the conntrack list as long as it is not destroyed.
> 3) The FC, sitting at the ethernet driver level, sends all the data
> packets belonging to the cached connection directly to the outbound port
> (as identified in step 2), bypassing the Linux stack altogether. All the
> packets not belonging to either of the cached tuples are terminated to
> the Linux stack. Also TCP control packets FIN/RST/SYN are terminated
> irrespective of wether the connection is cached or not.
> 4) With assistance from the FC, the CM also runs aging on the cached
> connections (hence the requirement of deleting the NF_CONNTRACK timer in
> step 2)
> 5) Cached connections can be terminated (i.e, removed from cache) in two
> ways:
> 	i) Aging out by the CM: In this scenario, the CM removes the
> connection tuple from FC as well as NF_CONNTRACK by calling the
> corresponding timer destroy function directly.
> 	ii) Destroy via TCP control packet: All the FIN-ACK, RST,
> RST-ACK packets are send to conntrack irrespective of the fact that they
> match a cached tuple. They are picked up by the TCP conntrack module
> which restarts the accounting and refreshes the connection state. It is
> at this point that the first chunk of this patch comes into picture. 
> 6) When the NF_CONNTRACK module is removed, it iterates through the list
> to destroy the detected connections. Currently, it does not remove those
> connections whose timers have gone off (which is the case with
> connections cached to FC). This is fixed by the second chunk of the
> patch.


That sounds pretty reasonable. Is that code available somewhere?

>>> +		if (newtime - ct->timeout.expires >= HZ) {
>>> +			/*
>>> +			 * The timer could have already been deleted
>>> +			 * while still alive (for example connection
>>> +			 * offloaded to a forwarding module other than
>>> +			 * the kernel stack).
>>> +			 */
>>> +			mod_timer(&ct->timeout, newtime);
>>>  			event = IPCT_REFRESH;
>> This adds a race, we don't want to update the timer if it already
>> went off this that means the connection is already destroyed.
>> Same problem with the other chunk.
>>
> 
> A timer call would have invalidated the conntrack by a call to
> 'death_by_timeout' (or similar such routine), thereby rendering this
> check redundant.  Theoretically, I think the check is irrelevant unless
> a hypothetical timeout doesn't really invalidate the conntrack. Can you
> describe the race scenario mentioned by you?

Very simple:

CPU0					CPU1
					timer goes off
refresh_timer: mod_timer, rearm		death_by_timeout()

timer goes off again

Using del_timer prevents us from rearming the timer if it
already went off.
