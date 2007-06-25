From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 02/10] nf_conntrack: Introduces a extension
 infrastructure
Date: Tue, 26 Jun 2007 00:35:46 +0900 (JST)
Message-ID: <200706251535.l5PFZlux026579@toshiba.co.jp>
References: <200706250314.l5P3EeGY021239@toshiba.co.jp>
	<467F925E.7090703@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467F925E.7090703@trash.net>
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

Thanks for your review. I'm impressed with your huge works in many areas.
I've applied your suggestions, except following.

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 25 Jun 2007 12:01:02 +0200

> > +void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, int gfp)
> 
> 
> Does any caller actually use something besides GFP_ATOMIC for gfp?

nf_conntrack_netlink does that.

> > +{
> > +	struct nf_ct_ext *new;
> > +	int i, newlen, newoff;
> > +	struct nf_ct_ext_type *t;
> > +
> > +	if (!ct->ext)
> > +		return nf_ct_ext_create(&ct->ext, id, gfp);
> > +
> > +	if (nf_ct_ext_exist(ct, id))
> > +		return NULL;
> > +
> > +	rcu_read_lock();
> > +	t = rcu_dereference(nf_ct_ext_types[id]);
> > +	BUG_ON(t == NULL);
> > +
> > +	newoff = ALIGN(ct->ext->len, t->align);
> > +	newlen = newoff + t->len;
> > +	rcu_read_unlock();
> > +
> > +	if (newlen >= ct->ext->real_len) {
> > +		new = kmalloc(newlen, gfp);
> > +		if (!new)
> > +			return NULL;
> > +
> > +		memcpy(new, ct->ext, ct->ext->len);
> 
> And maybe krealloc here?

krealloc() is possible to free old area before t->move().
That breaks list used by NAT.

> > +
> > +		for (i = 0; i < NF_CT_EXT_MAX; i++) {
> > +			if (!nf_ct_ext_exist(ct, i))
> > +				continue;
> > +
> > +			rcu_read_lock();
> > +			t = rcu_dereference(nf_ct_ext_types[i]);
> > +			if (t && t->move)
> > +				t->move(ct, ct->ext + ct->ext->offset[id]);
> > +			rcu_read_unlock();
> > +		}
> > +		kfree(ct->ext);
> > +		new->real_len = newlen;
> > +		ct->ext = new;
> > +	}

-- Yasuyuki Kozakai
