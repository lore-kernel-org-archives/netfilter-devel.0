From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Fri, 15 Jun 2007 18:11:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706151810260.32724@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>
	<46657E13.50106@trash.net> <46727873.20503@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46727873.20503@ufomechanic.net>
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


On Jun 15 2007 12:30, Amin Azez wrote:
>This didn't seem to turn up on the mailing list, so I'm re-sending:

It did, at least for me. (And I truly mean the copy that netfilter.org 
mailing list software sent me, since I still have that.)

>>> +	if ((dst = skb->dst) == NULL)
>>> +		return false;
>>> +	if ((neigh = dst->neighbour) == NULL)
>>> +		return false;    
>>
>> Actually I very much prefer to have assignments seperated
>> from comparisons, there just were no instances of this in
>> the patches I commented on :)
>>
>> Most of the checks here are unnecessary anyway (we always
>> have a skb with skb->dst != NULL, 
>maybe skb->dst = NULL on pre-routing?
>> neigh->tbl is always != NULL  
>same?
>> and the neighbour table family is always AF_INET since the
>> match is only registered for AF_INET.
>>   
>Maybe if I take out these checks, I should restrict the match to FORWARD
>and POSTROUTING?

Leaving them in does not cost too much.

>I'm being careful because while I am confident that what I submitted
>(and Jan modified for current kernels) is safe and works, I'm not
>confident that it will be safe with these changes.
>

	Jan
-- 
