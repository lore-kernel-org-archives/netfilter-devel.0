From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Tue, 05 Jun 2007 17:15:31 +0200
Message-ID: <46657E13.50106@trash.net>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>
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
> (Style changes the way Patrick prefers it.)
> 
> +	if ((dst = skb->dst) == NULL)
> +		return false;
> +	if ((neigh = dst->neighbour) == NULL)
> +		return false;


Actually I very much prefer to have assignments seperated
from comparisons, there just were no instances of this in
the patches I commented on :)

Most of the checks here are unnecessary anyway (we always
have a skb with skb->dst != NULL, neigh->tbl is always != NULL
and the neighbour table family is always AF_INET since the
match is only registered for AF_INET.
