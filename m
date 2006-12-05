From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH 1/2][priv_data-condition][part 1/2][core]
Date: Tue, 5 Dec 2006 23:06:54 +0100
Message-ID: <200612052306.57390.max@nucleus.it>
References: <200609250040.49298.max@nucleus.it>
	<200609251016.33590.max@nucleus.it> <451EA13B.5050700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <451EA13B.5050700@trash.net>
Content-Disposition: inline
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

On Saturday 30 September 2006 6:54 pm, Patrick McHardy wrote:

Sorry for the long delay. I've only been able to work on it in bursts.
I hope you're still interested.

> I wish you would have updated my patch instead. It had more logical
> argument ordering and a few other cleanups. It was also structured
> in a way that left the tree compiling at each step, so we don't
> make peoples life performing bisections unnecessarily hard.

I was already half throu when I received your patch.
In a few minutes I'll send a new series of patches that integrates you 
suggestions both in code and in declarations.

I also separated my code in smaller and self contained patches.
Every step has been tested.

> >  extern int xt_compat_target_to_user(struct xt_entry_target *t,
> > -				    void __user **dstptr, int *size);
> > +				    void * __user *dstptr, int *size);
>
> This reintroduces a bug that was fixed a few days ago.

Whops... It was merged by mistake. Corrected.

> > +	ret = xt_init_target(t, "ipt", AF_INET,
> > +			     name, e->comefrom, e->ip.proto,
> > +			     e->ip.invflags & IPT_INV_PROTO);
>
> x_tables can deduce the prefix from the address family.

You're right. Done.

> > -	if (m->u.kernel.match->checkentry
> > -	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
> > -					      hookmask)) {
> > +	if (m->u.kernel.match->init
> > +	    && !m->u.kernel.match->init(name, ip, match, dm->data,
> > +					hookmask, m->u.kernel.priv_data)) {
>
> The ->checkentry/->init call should be performed in xt_init_match.

I was trying not to be too intrusive and I didn't like the idea that this 
breaks the similarity between xt_init_target() and xt_init_matches().
Anyway I ended up changing a lot of things nontheless, so I might as well do 
it. :)
Implemented in the incoming patches.

I refrained from doing the same code shifting between init_entry() and 
xt_init_target() since it does a lot of similar, but protocol dependent 
things. I'd like to analyze and test it separately.

> > +	if (match->priv_size) {
> > +		m->u.kernel.priv_data = kzalloc(match->priv_size,
> > +						GFP_KERNEL);
> > +		if (!m->u.kernel.priv_data) {
> > +			printk("%s_tables: %s match: "
> > +			       "unable to allocate memory\n",
> > +			       xt_prefix[family], match->name);
> > +			return -ENOMEM;
>
> It should clean up behind itself.

Now that it does the whole work, it cleans up as well. Done.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
