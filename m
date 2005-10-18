From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!) in
 ipt_limit
Date: Tue, 18 Oct 2005 11:57:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510181154070.7403@filer.marasystems.com>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
	<4353BFFB.7070406@trash.net>
	<20051017213551.GA6043@zion.homelinux.com>
	<Pine.LNX.4.61.0510181031330.6259@filer.marasystems.com>
	<20051018091910.GB25908@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20051018091910.GB25908@zion.homelinux.com>
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

On Tue, 18 Oct 2005, Sven Schuster wrote:

> yes that's what I guessed that it can't be done now due to userspace 
> compatibility issues. But apart from that, it would have been a better 
> solution if it had been implemented in the core from "day 1" on, 
> wouldn't it??

I think so yes.

And likely to be addressed for hipac in the upcoming hipac function 
matches.

Regards
Henrik
