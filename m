From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: xt_TARPIT
Date: Thu, 19 Jul 2007 09:38:02 +0900 (JST)
Message-ID: <200707190038.l6J0c3pR002571@toshiba.co.jp>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	kaber@trash.net, safari-netfilter@safari.iki.fi
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
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

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Wed, 18 Jul 2007 17:02:45 +0200 (CEST)

> Hi,
> 
> On Wed, 18 Jul 2007, Patrick McHardy wrote:
> 
> >> +	/* This packet will not be the same as the other: clear nf fields */
> >> +	nf_conntrack_put(nskb->nfct);
> >> +	nskb->nfct = NULL;
> 
> If the target is called from the raw table, please attach the fake untrack 
> entry to the created packet so that we could use TARPIT and conntrack 
> nicely.

I'm not sure that we should make TARPIT usable in raw table, but anyway
why the fake untrack entry is necessary ? I think that the created packet
is better to pass through LOCAL_OUT hook so that nf_conntrack can attach an
appropriate entry. That is what REJECT does.

-- Yasuyuki Kozakai
