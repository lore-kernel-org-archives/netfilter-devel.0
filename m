From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Thu, 04 Nov 2004 18:55:53 +0100
Message-ID: <418A6D29.60004@trash.net>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041104154355.GA8553@linuxace.com>
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

>On Thu, Nov 04, 2004 at 03:53:38AM +0100, Patrick McHardy wrote:
>  
>
>>I think we should revert to the old behaviour for all interfaces.
>>When MASQUERADE was using a route-lookup for selecting the source
>>there were good reasons for using MASQUERADE on devices with statically
>>configured adresses, and some people (like me) still do it today.
>>Simple adding a second IP address to an interface flushes all
>>MASQUERADEDED conntracks on the device, which is not very nice.
>>The optimization was meant for ppp devices anyway, if we can't use
>>it there I don't see much reason to keep it.
>>
>>Opinions anyone ?
>>    
>>
>
>It is nice that a powercycle of your router/switch/dslmodem/cablemodem/etc
>doesn't cause lost conntracks.  The optimization is of value here.
>
>Given these events are infrequent, and not in any fast path, any reason
>why the behaviour shouldn't be maintained for ethernet since it works
>there?
>  
>
Ok, I agree it is still useful, but using the inetaddr_notifier gives
false positives when more than one IP address is added to the interface.

Regards
Patrick
