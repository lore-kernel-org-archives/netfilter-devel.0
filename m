From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Tue, 09 Nov 2004 18:44:39 +0100
Message-ID: <41910207.1090309@trash.net>
References: <20041107181825.GA3522@linuxace.com> <418F9952.5030004@trash.net>
	<20041108161511.GA6754@linuxace.com> <418F9DD4.20202@trash.net>
	<20041108163457.GB6754@linuxace.com>
	<20041108215525.GA8766@linuxace.com> <4190A44F.7010509@trash.net>
	<20041109165313.GA13205@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041109165313.GA13205@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>On Tue, Nov 09, 2004 at 12:04:47PM +0100, Patrick McHardy wrote:
>  
>
>>You're right. I have to admit, I'm not too happy about the unpredictable
>>behaviour we get with this patch and multiple ppp devices. So one last
>>attempt to convince people. The old behaviour was to kill conntracks once
>>the device goes down. I think killing conntracks when the IP is deleted
>>makes more sense. Since the IP has to be deleted manually, except when
>>the device goes away, people can simply not delete IP addresses for
>>devices that don't go away, than nothing will get removed. pppd can be
>>taught to keep the device alive. The attached patch adds a program
>>alloc-ppp to pre-allocate ppp-devices and teaches pppd to attach to them.
>>The device never goes away, if ppp doesn't delete the IP address the
>>conntracks won't be killed. It could easily be integrated in a more handy
>>way in pppd. So this could also be done entirely in userspace, without
>>the unpredictable behaviour.
>>    
>>
>
>Is this the unpredictable behaviour you refer to:
>
>ppp0 down -> clear assured bit on ppp0 conntracks
>ppp1 down -> clear assured bit on ppp1 conntracks
>ppp0 up with same ip -> all ppp1 conntracks get cleared since that ip
>			no longer exists on box
>ppp1 up with same ip -> loser
>  
>
Yes. It gives unpredictable behaviour and no way to avoid it.
If ppp1 comes up first - ppp0 is the loser. If only one goes
down at a time - nobody looses.

>Not much we can do about that except revert to the old behaviour of
>dropping all conntracks on interface down, but that does seem silly
>for 'mostly static' pppoe users.
>
>Obviously I'd vote for the 'friendlier' method, but bottom line is current
>behaviour is broken and should be fixed somehow...
>  
>

I think deterministic behaviour is more friendly than something
working only under certain conditions and doing strange stuff
the remaining time. I would like to hear Harald's opinion.

Regards
Patrick
