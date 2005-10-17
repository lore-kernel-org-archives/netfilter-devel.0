From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!)
	in	ipt_limit
Date: Mon, 17 Oct 2005 08:28:15 -0700
Message-ID: <20051017152815.GA23954@linuxace.com>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
	<4353BFFB.7070406@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Marco Innocenti <m.innocenti@cineca.it>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4353BFFB.7070406@trash.net>
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

On Mon, Oct 17, 2005 at 05:15:07PM +0200, Patrick McHardy wrote:
> > I've seen it in ipt_multiport.c and I copied it.
> > Should ipt_multiport.c be corrected?
> 
> Probably, I've never liked these strange looking expressions.

Multiport invert works fine (I added/tested it).  No sense in
changing it just based on looks.

Phil
