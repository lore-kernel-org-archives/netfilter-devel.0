From: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Sun, 12 Jun 2005 22:24:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0506122217030.15775@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<42AB0D81.2080804@trash.net>
	<20050612095655.GB19830@obroa-skai.de.gnumonks.org>
	<42AC3AC6.4080304@trash.net>
	<Pine.LNX.4.61.0506121119510.15775@e-smith.charlieb.ott.istop.com>
	<42AC5839.9020608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AC5839.9020608@trash.net>
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


On Sun, 12 Jun 2005, Patrick McHardy wrote:

> Charlie Brady wrote:
>> Attached.
>
> Applied, thanks. Could you send a patch that updates the
> iptables-restore manpage to reflect this change?

I'd be happy to, but I'm not sure what it would be appropriate to say in 
an altered manpage.

The current manpage still succinctly and accurately describes the function 
and usage of iptables-restore. What it doesn't do is define behaviour in 
every corner case or exception. The description IOW is incomplete. But 
that is probably true of many/most man pages.

IMO, my patch just fixes a bug.

Charlie
