From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Fri, 05 Nov 2004 20:15:09 +0100
Message-ID: <418BD13D.5080907@trash.net>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
	<418AAF0A.4000201@trash.net>
	<Pine.LNX.4.61.0411050036560.19958@filer.marasystems.com>
	<20041105104845.GF5606@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041105104845.GF5606@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Fri, Nov 05, 2004 at 12:40:03AM +0100, Henrik Nordstrom wrote:
>
>  
>
>>I am not saying that the current code is correct, only that I see no 
>>reason why MASQUERADE should consider being overly friendly to people 
>>having multiple IP addresses on their dynamic IP interface.
>>    
>>
>
>I totally agree with Henrik in this issue. But we relly need to document
>it.  Maybe printk() some warning in case somebody adds a second address
>to an interface that uses MASQUERADE (from within the notifier)?
>  
>
We only know is someone adds a true secondary address, not multiple
primaries, otherwise we could just ignore it. Anyway, I agree we
don't need to be overly friendly, I just don't see a case where this
optimization does something useful. On ethernet devices, why delete
the IP (if it didn't change) or set the interface down in the first
place ? On ppp-interfaces, it doesn't work. Phil mentioned powercycling
his dsl-/cablemodem would set his eth-interface down. I find that hard
to believe, so I assume he didn't literally meant "my", but picked a
bad example.

So, can anyone think of a setup where this optimization does work ?

Regards
Patrick
