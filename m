From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Mon, 02 Aug 2004 13:05:53 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408020405.NAA27078@toshiba.co.jp>
References: <20040801164653.GA10656@sunbeam2>
	<410D23AB.2070203@trash.net>
	<20040801181150.GI14539@sunbeam2>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp, kadlec@blackhole.kfki.hu,
        netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20040801181150.GI14539@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 1 Aug 2004 20:11:50 +0200

> On Sun, Aug 01, 2004 at 07:08:59PM +0200, Patrick McHardy wrote:
> 
> > >>	struct tcphdr hdr;
> > >>	struct tcphdr *tcph
> > >>
> > >>	tcph = skb_get_bits(skb, &hdr, skb->nh.iph->ihl*4, sizeof(hdr));
> > >>
> > >>If skb is neither shared nor cloned, this function linearize up to tcp 
> > >>header and returns the pointer to tcp header in skb.
> > >>Otherwise, copies tcp header to "hdr" and return the pointer to it.
> > >>If error, return NULL.
> >
> > The number of copies will still depend on the ruleset with non-linear skbs.
> > skb_linearize_partial sounds like a much better idea to me.
> 
> Oh yes, indeed.  I somehow mis-interpreted Yasuyiki's approach.  We
> should linearize with the first call, so that every 2nd, 3rd, ... call
> do nothing but immediately return.

Oh, sorry. I misstook about pskb_may_pull(). And please forget my patch
because it's inefficient.


> 
> > Regards
> > Patrick
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
