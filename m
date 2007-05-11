From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Fri, 11 May 2007 10:51:06 +0900 (JST)
Message-ID: <200705110151.l4B1p7bd012706@toshiba.co.jp>
References: <46404700.40609@trash.net>
	<200705091105.l49B5DTu023689@toshiba.co.jp>
	<46431138.2080805@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp, kadlec@blackhole.kfki.hu
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46431138.2080805@trash.net>
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


Hi, Patrick, Pablo and all,

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 10 May 2007 14:34:00 +0200

> >>This will add quite some overhead since at least nfct_help is looked at
> >>for every packet (we might avoid this using a status flag though).
> >>I'm guessing the locks are needed to protect against concurrent
> >>reallocations. Maybe we can avoid this by adding the limitation that
> >>only unconfirmed entries may add new extensions?
> > 
> > 
> > It sounds good to avoid competition of 2 packet processing. I think
> > that the remain is nfctnetlink. It can assign helper to a confirmed
> > conntrack. Do you think that it's enough to assume that it disables bh ?
> 
> 
> No, that would only help for the CPU its running on. But so far
> we only allow to change helpers, not assign completely new ones,
> so no reallocation is needed. I'm wondering if this behaviour
> is correct though ..

IIRC, Harald had a idea of userland helper using nfctnetlink and nfqueue (2
years ago ?). ??? Please wait...... oh.. but to do that, nfctnetlink is
enough to assign a helper to an unconfirmed conntrack (currently it does
not).

And I'm not sure about the case of conntrackd.

Pablo, is there any case that conntrackd assign helper to a confirmed
conntrack ?

-- Yasuyuki Kozakai
