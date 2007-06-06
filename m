From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Wed, 06 Jun 2007 13:31:14 +0200
Message-ID: <46669B02.2010905@trash.net>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>	<46657E13.50106@trash.net>
	<Pine.LNX.4.61.0706051719290.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051719290.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Jun 5 2007 17:15, Patrick McHardy wrote:
> 
>>Most of the checks here are unnecessary anyway (we always
>>have a skb with skb->dst != NULL, neigh->tbl is always != NULL
>>and the neighbour table family is always AF_INET since the
>>match is only registered for AF_INET.
> 
> 
> Thanks for letting us now. Now, prime question: Is skb always != NULL?
> (Otherwise it would not really make sense calling the match if
> there was nothing to match.)


Yes.
