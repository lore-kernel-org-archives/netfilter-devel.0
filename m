From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 4 Apr 2005 05:42:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504040537290.19728@kaber.coreworks.de>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<42507DF8.9030102@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42507DF8.9030102@outerspace.dyndns.org>
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

On Mon, 4 Apr 2005, Jonas Berlin wrote:
> Speaking of tcp match.. would you happen to know when the "h" union of
> sk_buff is instantiated?
> ~   a) first time someone does -p something
> ~   b) somewhere before the filter table
> ~   c) in a seemingly unpredictable fashion
> ~   d) ?

It is used by the upper layer protocols, you can't use it in netfilter
because it is unset for forwarded packets.

> | bit more generic. Perhaps a data-len match option.
>
> I was thinking of this too but couldn't think of much use for more specific
> length-matching, so I thought I'd save a few cycles.. but ok if you think
> it's the way to go, I go. :)
>
> Any parameter name suggestions? "[!] --has-payload" ?

--datalen?

Regards
Patrick
