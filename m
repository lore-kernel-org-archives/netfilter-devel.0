From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Mon, 04 Jun 2007 09:45:48 +0900 (JST)
Message-ID: <200706040045.l540jnFe007950@toshiba.co.jp>
References: <465E5159.4050604@trash.net>
	<200705310902.l4V9212d010654@toshiba.co.jp>
	<46603C67.4070201@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	rusty@rustcorp.com.au, kadlec@blackhole.kfki.hu,
	mmohsenz@gmail.com, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46603C67.4070201@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 01 Jun 2007 17:33:59 +0200

> > After all, if we don't want to introduce rwlock for such competition,
> > we'd better to limit nfctnetlink so that it doesn't assign, change, or
> > remove helper of confirmed conntrack.
> > 
> > If people agree to remove ctnetlink_change_helper(), I'll submit the latest
> > pactchset of ct_extend.
> 
> 
> I don't think we can do that, it has been part of the ABI since the
> beginning I think and we might need it for userspace helpers.

OK, I'll try to find an other idea.

> How about grabbing nf_conntrack_lock and replacing the entire conntrack
> structure in this case?

It requires very complicated operations. I want to avoid that as possible.

I'm thinking about exporting nf_nat_lock and locks of helpers, and grabbing
all of them just before reallocating extended area. But I'm not sure it is
possible because we have to take care about deadlock due to grabbing
multiple locks in different order.

One more idea is Rusty's comment in the original patch, it replaces array
of extended area with linked list. But it results in so many small memory
objects. Hmm...

-- Yasuyuki Kozakai
