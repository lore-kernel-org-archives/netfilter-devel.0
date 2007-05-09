From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Wed, 09 May 2007 20:05:12 +0900 (JST)
Message-ID: <200705091105.l49B5DQt026096@toshiba.co.jp>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>
	<46404700.40609@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46404700.40609@trash.net>
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
Date: Tue, 08 May 2007 11:46:40 +0200

> > The issues I noticed are following.
> > - This patchset does not consider locking. The places calling nfct_help() or
> >   nfct_nat() must be protected with new read-write lock. It will add
> >   some processing time and complexities.
> 
> 
> This will add quite some overhead since at least nfct_help is looked at
> for every packet (we might avoid this using a status flag though).
> I'm guessing the locks are needed to protect against concurrent
> reallocations. Maybe we can avoid this by adding the limitation that
> only unconfirmed entries may add new extensions?

It sounds good to avoid competition of 2 packet processing. I think
that the remain is nfctnetlink. It can assign helper to a confirmed
conntrack. Do you think that it's enough to assume that it disables bh ?

> > - ct_extend_add() reallocates memory area for all extensions. All helpers
> >   and NAT codes are necessary to take care that the pointer nfct_help(ct)
> >   and nfct_nat(ct) might be changed. It would make difficult to find bugs
> >   caused by this issue.
> 
> 
> Thats something we'll have to live with I guess. The same is true for
> the skb reallocation functions, maybe we can get a sparse check for
> this some day.

I agree.

> > And some improvements can be considered/are necessary.
> > - Introducing new locking
> > - 'move' operation might be better to have a argument 'struct nf_conn *ct'.
> > - Moving other stuff in 'struct nf_conn' to ct_extend
> > - Spliting nf_conn_nat into helper parts and others
> > - Fixes of function names (nf_ct_ext_, nfct_ext_, nf_cte_, or ?)
> 
> 
> I prefer nf_ct_ext_ or nfct_ext_.

Ok, I'll replace them with nf_ct_ext_*.

> I'm thinking we could probably avoid some reallocations by doing
> a more accurate CT_EXTEND_MIN_SIZE calculation by taking
> nf_nat_module_is_loaded into account. Only makes sense if it
> currently is smaller than the space needed for NAT+MASQUERADE
> of course.

Good idea. On my laptop, CT_EXTEND_MIN_SIZE is 32 bytes, the size of
helper area is 32 bytes, and 36 bytes for NAT. The helper area is allocated
before the NAT, so pre-allocating NAT area can reduce the number of
allocation. I'll add a flag to 'ct_extend_type' to intend pre-allocating.

Thanks for comments,

-- Yasuyuki Kozakai
