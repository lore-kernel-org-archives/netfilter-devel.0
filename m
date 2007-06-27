From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER]: nf_conntrack: use hlists for conntrack hash
Date: Wed, 27 Jun 2007 16:03:20 +0900 (JST)
Message-ID: <200706270703.l5R73LQc018520@toshiba.co.jp>
References: <46816369.4070407@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46816369.4070407@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 26 Jun 2007 21:05:13 +0200

> [NETFILTER]: nf_conntrack: use hlists for conntrack hash

very nice patches.

> Convert conntrack hash to hlists to reduce its size and cache
> footprint. Since the default hashsize to max. entries ratio
> sucks (1:16), this patch doesn't reduce the amount of memory
> used for the hash by default, but instead uses a better ratio
> of 1:8, which results in the same max. entries value.

What do you think the impact to nat hash table is ? nf_nat_htable_size
is set to nf_conntrack_htable_size at initialization.

I think we can also replace list with hlist for nat hash and then
there is no problem.

-- Yasuyuki Kozakai
