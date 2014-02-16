From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 12:01:52 +0100
Message-ID: <20140216110152.GD28751@breakpoint.cc>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52700 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbaBPLB4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:01:56 -0500
Content-Disposition: inline
In-Reply-To: <20140216085319.GA26751@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On Sat, Feb 15, 2014 at 11:47:12PM +0100, Florian Westphal wrote:
> > Takes advantage of the fact that the current maximum label storage area
> > is 128 bits, i.e. it will fit into a nft register.
> > 
> > Advantages:
> > - kernel part is very small (just copies extension storage to register)
> > - userspace part is not huge either and very powerful since
> >   we can operate on the entire '128 bit connlabel pseudo-register'
> >   (f.e. "ct labels & foo|bar == foo" to match when foo is set and bar is not,
> >    etc)
> > 
> > Disadvantage:
> > 
> > - We get into trouble if kernel would ever increase the current limit
> >   of 128 labels (its just a matter of changing #define in kernel and
> >   making sure nf_conn extension offsets can deal with larger sizes).
> 
> We need to change the kernel registers anyway to deal with concatenations
> properly. So this will most likely not be a problem.

Oh.  Thats good.  One problem disappearing :-)

> > - Its currently not necessarily doing what the user would think.
> > 
> > The latter point deserves example:
> > 
> > add rule filter output ct labels foo
> > 
> > is NOT the translation of iptables
> > -m connlabel --label foo
> > 
> > The former matches only if foo and ONLY foo is set.
> > The latter matches when foo label bit is set and doesn't care about
> > other labels, i.e. the nft translation would be
> > 
> > add rule filter output ct labels & foo == foo
> > 
> > Thus I am not sure at the moment if this is really the right approach
> > and if it would be better to follow the xt_connlabel model and ask kernel
> > for the desired *bit* instead.
> > 
> > It could be done by adding a 'ctlabel' instruction that would check the
> > bit given in sreg (eg. 3 would do test_bit(... 3) and BREAK if its not set.
> 
> Actually you can also easily do this with by just generating an equality
> comparison in userspace. Since you're using bitmask as a base type,
> nft automatically generates instructions to only check that bit when
> using an *implicit* op. If you use
> 
> "filter output ct labels == foo" that should match only the one label.

src/nft add rule filter output ct labels == foo --debug=netlink
ip filter output 0 0
[ ct load labels => reg 1 ]
[ cmp eq reg 1 0x00000001 0x00000000 0x00000000 0x00000000 ]

I guess I am doing something wrong in my patch.
Let me investigate.  The behaviour you describe seems to be exactly
what I want.

> I have to admit that I don't know how connlabels are used, so I don't
> know what the best default implicit op would be.

I think it should be a bit-test to make it behave like xt_connlabels
match.

> > Something to also keep in mind is that this currently lacks write
> > support.  In iptables this is done via
> > '-m connlabel --label foo --set', which causes atomic set-bit operation.
> > 
> > For nft with current approach it would mean we would need to copy to
> > reg, alter reg, then copy altered register back to extension area.
> > 
> > What do others think?
> 
> Sounds fine. Its a quite rare operation I assume.

Yes.

The iptables match performs the set operation only if the bit is not
set to avoid the write in the common case.

It should be possible to do something similar for nft.

> > --- a/include/datatype.h
> > +++ b/include/datatype.h
> > @@ -32,6 +32,7 @@
> >   * @TYPE_CT_STATE:	conntrack state (bitmask subtype)
> >   * @TYPE_CT_DIR:	conntrack direction
> >   * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
> > + * @TYPE_CT_LABELS:	Conntrack Labels (bitmask subtype)
> >   * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
> >   */
> >  enum datatypes {
> > @@ -63,6 +64,7 @@ enum datatypes {
> >  	TYPE_CT_STATE,
> >  	TYPE_CT_DIR,
> >  	TYPE_CT_STATUS,
> > +	TYPE_CT_LABELS,
> >  	TYPE_ICMP6_TYPE,
> >  	__TYPE_MAX
> >  };
> 
> Small note - we should add datatypes at the end. The kernel stores those
> types for userspace to interpret the type of sets, so when doing an update
> of nft, the types should still match.

I was unaware of this.  Thanks for pointing it out.

> > +static void ct_label_type_print(const struct expr *expr)
> > +{
> > +	const struct symbolic_constant *s;
> > +	unsigned long bit = 0;
> > +	int cnt = 0;
> > +
> > +	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
> > +		bit = mpz_scan1(expr->value, s->value);
> > +		if (bit < CT_LABELS_BIT_SIZE && bit == s->value) {
> > +			if (cnt)
> > +				printf("|");
> 
> This looks incorrect since it doesn't match the input format. When using
> a bitmask base type, nft should automatically reconstruct the list as
> comma-seperated values. So I think you don't need a print function.

see below

> > +static struct error_record *ct_label_type_parse(const struct expr *sym,
> > +						struct expr **res)
> > +{
> > +	const struct symbolic_constant *s;
> > +	const struct datatype *dtype;
> > +	uint8_t data[CT_LABELS_BIT_SIZE];
> > +	mpz_t value;
> > +
> > +	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
> > +		if (!strcmp(sym->identifier, s->identifier))
> > +			break;
> > +	}
> > +
> > +	dtype = sym->dtype;
> > +	if (s->identifier == NULL)
> > +		return error(&sym->location, "Could not parse %s", dtype->desc);
> > +
> > +	mpz_init2(value, dtype->size);
> > +	mpz_setbit(value, s->value);
> > +	mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
> > +
> > +	*res = constant_expr_alloc(&sym->location, dtype,
> > +				   dtype->byteorder, sizeof(data),
> > +				   data);
> > +	mpz_clear(value);
> > +	return NULL;
> > +}
> 
> Same here. The defaults should work fine.

Hmm, I think the problem is that connlabel.conf
maps the bit-number to names, e.g.

0 foo
1 bar

But these should be parsed as (1<<$number)
[ in iptables these values are passed to the kernel which
  uses them as argument to test_bit and friends ].

Could probably be fixed by having my own parsing
function instead of reusing the rt_symbol_table one, but I would
need to replace the uint64_t value in the sym table structure
for that [need to be able to store (1<<127)]...

> > +static const struct datatype ct_labels_type = {
> > +	.type		= TYPE_CT_LABELS,
> > +	.name		= "ct_labels",
> > +	.desc		= "conntrack labels",
> 
> The type only refers to a single instance, so all should be singular.

Ok

> >  static void ct_expr_print(const struct expr *expr)
> > @@ -159,4 +223,5 @@ static void __init ct_init(void)
> >  	datatype_register(&ct_state_type);
> >  	datatype_register(&ct_dir_type);
> >  	datatype_register(&ct_status_type);
> > +	ct_label_tbl = rt_symbol_table_init("/etc/xtables/connlabel.conf");
> 
> We're using per type init functions for symbol table initializations so
> far (see meta.c). I'd suggest to keep this consistent.

Sure, I'll change it.

Thanks Patrick.
