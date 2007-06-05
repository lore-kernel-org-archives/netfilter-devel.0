From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Tue, 5 Jun 2007 17:20:33 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051719290.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>
	<46657E13.50106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46657E13.50106@trash.net>
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


On Jun 5 2007 17:15, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> (Style changes the way Patrick prefers it.)
>> 
>> +	if ((dst = skb->dst) == NULL)
>> +		return false;
>> +	if ((neigh = dst->neighbour) == NULL)
>> +		return false;
>
>
>Actually I very much prefer to have assignments seperated
>from comparisons, there just were no instances of this in
>the patches I commented on :)

Well I amsure you can make an exception here, it's just so really simple.

>Most of the checks here are unnecessary anyway (we always
>have a skb with skb->dst != NULL, neigh->tbl is always != NULL
>and the neighbour table family is always AF_INET since the
>match is only registered for AF_INET.

Thanks for letting us now. Now, prime question: Is skb always != NULL?
(Otherwise it would not really make sense calling the match if
there was nothing to match.)


	Jan
-- 
