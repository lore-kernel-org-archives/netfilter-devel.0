From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kill NFC_* stuff in iptables [was Re: iptables compile
 error: NFC_IP_TOS undeclared]
Date: Sun, 13 Feb 2005 00:34:23 +0100
Message-ID: <420E927F.1030905@trash.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>	<420B8623.9050308@niksula.hut.fi>	<420B9ED0.1020303@trash.net>
	<420BEB36.7080209@eurodev.net> <420D0276.5080200@trash.net>
	<420D27DB.9000608@eurodev.net> <420D5CC8.1060600@trash.net>
	<420E8259.60604@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <420E8259.60604@eurodev.net>
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

Pablo Neira wrote:

> Patrick McHardy wrote:
>
>> I haven't actually checked
>> the API, but can't we remove all those now empty init functions ?
>> If not I think it would be nicer to change the API to check for
>> ->init == NULL instead of leaving all these empty funtion bodies around.
>
> Yes, I agree and I did it, I must confess that it was kinda boring a 
> bit. See the patch attached.

Thanks Pablo. I'm going to apply it once iptables 1.3.0 is released.

>> I don't think we can remove it from struct ipt_entry without
>> breaking userspace compatibility. But we could stop using it.
>
> Yes, I was aware of that :). I didn't talk about modifying ipt_entry 
> which is not possible because of backward compatibility. I mean that, 
> as next step, we could kill those nfcache arguments passed as 
> parameter that aren't useful anymore.

Sure, go ahead.

Regards
Patrick
