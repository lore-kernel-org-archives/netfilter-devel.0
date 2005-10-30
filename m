From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] NETFILTER: add support for invert condition
	(!)	in	ipt_limit
Date: Sun, 30 Oct 2005 16:12:20 +0100
Message-ID: <4364E2D4.6090809@trash.net>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>	<20051017143053.GA29010@pc-innocenti.cineca.it>	<4353BFFB.7070406@trash.net>
	<20051017213551.GA6043@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20051017213551.GA6043@zion.homelinux.com>
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

Sven Schuster wrote:

> I know it's been a while since netfilter/iptables has been developed,
> but why wasn't isn't the inversion built into the netfilter/iptables
> core?? Inversion can be useful for any kind of match, so why duplicate
> it in every single match?? Why not instead do a general inversion??
> If I haven't thought of something obvious please cat this post to
> /dev/null :-) (but pleas enlighten me before doing so *g*)

Yes, that would have been a better idea. Unfortunately
we can't change this now because of userspace compatiblity.
