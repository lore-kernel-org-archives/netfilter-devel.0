From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 05/10] nf_nat: Use extension infrastructure
Date: Tue, 26 Jun 2007 00:48:38 +0900 (JST)
Message-ID: <200706251548.l5PFmeGq020338@toshiba.co.jp>
References: <200706250315.l5P3F5vI009154@toshiba.co.jp>
	<467F9423.3050503@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467F9423.3050503@trash.net>
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
Date: Mon, 25 Jun 2007 12:08:35 +0200

> Yasuyuki KOZAKAI wrote:

> > +	/* nat helper or nfctnetlink also setup binding */
> > +	nat = nfct_nat(ct);
> > +	if (!nat) {
> > +		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
> > +		if (unlikely(nat == NULL)) {
> 
> 
> gcc assumes unlikely for ptr == NULL by default.

I didn't know that, thanks.

> > +static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
> > +{
> > +	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
> > +	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
> > +	struct nf_conn *ct = old_nat->info.ct;
> > +	unsigned int srchash;
> > +
> > +	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
> > +		return;
> 
> 
> Is !ct really possible? Looks like something that should be catched
> on a higher level if it really is.

No, I've removed it.

> > +
> > +	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> > +
> > +	write_lock_bh(&nf_nat_lock);
> > +	list_del(&old_nat->info.bysource);
> > +	new_nat->info.ct = ct;
> > +	list_add(&new_nat->info.bysource, &bysource[srchash]);
> 
> list_replace maybe?

It's useful, thanks.

-- Yasuyuki Kozakai
