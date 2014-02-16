From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 11:12:52 +0000
Message-ID: <20140216111252.GA29491@macbook.localnet>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38966 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaBPLM4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:12:56 -0500
Content-Disposition: inline
In-Reply-To: <20140216110152.GD28751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 12:01:52PM +0100, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > > - Its currently not necessarily doing what the user would think.
> > > 
> > > The latter point deserves example:
> > > 
> > > add rule filter output ct labels foo
> > > 
> > > is NOT the translation of iptables
> > > -m connlabel --label foo
> > > 
> > > The former matches only if foo and ONLY foo is set.
> > > The latter matches when foo label bit is set and doesn't care about
> > > other labels, i.e. the nft translation would be
> > > 
> > > add rule filter output ct labels & foo == foo
> > > 
> > > Thus I am not sure at the moment if this is really the right approach
> > > and if it would be better to follow the xt_connlabel model and ask kernel
> > > for the desired *bit* instead.
> > > 
> > > It could be done by adding a 'ctlabel' instruction that would check the
> > > bit given in sreg (eg. 3 would do test_bit(... 3) and BREAK if its not set.
> > 
> > Actually you can also easily do this with by just generating an equality
> > comparison in userspace. Since you're using bitmask as a base type,
> > nft automatically generates instructions to only check that bit when
> > using an *implicit* op. If you use
> > 
> > "filter output ct labels == foo" that should match only the one label.
> 
> src/nft add rule filter output ct labels == foo --debug=netlink
> ip filter output 0 0
> [ ct load labels => reg 1 ]
> [ cmp eq reg 1 0x00000001 0x00000000 0x00000000 0x00000000 ]
> 
> I guess I am doing something wrong in my patch.
> Let me investigate.  The behaviour you describe seems to be exactly
> what I want.

This looks correct, doesn't it? Its an equality comparison of the label.

> > I have to admit that I don't know how connlabels are used, so I don't
> > know what the best default implicit op would be.
> 
> I think it should be a bit-test to make it behave like xt_connlabels
> match.

Ok I misunderstood your initial problem statement. So basically what it
should currently do:

ct labels foo => test whether that bit is set
ct labels == foo => test whether foo and only foo is set

Ok I can see the problem :)

The implicit op only selects FLAGCMP for EXPR_LIST (see
expr_evaluate_relational()). That should probably be changed to take the
base type into account. This also seems wrong for the ct state expression,
we currently use equality if only one state is specified but use a flag
comparison if multiple flags are specified.

If you change the default case to take the basetype into account it should
do what you want.

> > > +static void ct_label_type_print(const struct expr *expr)
> > > +{
> > > +	const struct symbolic_constant *s;
> > > +	unsigned long bit = 0;
> > > +	int cnt = 0;
> > > +
> > > +	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
> > > +		bit = mpz_scan1(expr->value, s->value);
> > > +		if (bit < CT_LABELS_BIT_SIZE && bit == s->value) {
> > > +			if (cnt)
> > > +				printf("|");
> > 
> > This looks incorrect since it doesn't match the input format. When using
> > a bitmask base type, nft should automatically reconstruct the list as
> > comma-seperated values. So I think you don't need a print function.
> 
> see below
> 
> > > +static struct error_record *ct_label_type_parse(const struct expr *sym,
> > > +						struct expr **res)
> > > +{
> > > +	const struct symbolic_constant *s;
> > > +	const struct datatype *dtype;
> > > +	uint8_t data[CT_LABELS_BIT_SIZE];
> > > +	mpz_t value;
> > > +
> > > +	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
> > > +		if (!strcmp(sym->identifier, s->identifier))
> > > +			break;
> > > +	}
> > > +
> > > +	dtype = sym->dtype;
> > > +	if (s->identifier == NULL)
> > > +		return error(&sym->location, "Could not parse %s", dtype->desc);
> > > +
> > > +	mpz_init2(value, dtype->size);
> > > +	mpz_setbit(value, s->value);
> > > +	mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
> > > +
> > > +	*res = constant_expr_alloc(&sym->location, dtype,
> > > +				   dtype->byteorder, sizeof(data),
> > > +				   data);
> > > +	mpz_clear(value);
> > > +	return NULL;
> > > +}
> > 
> > Same here. The defaults should work fine.
> 
> Hmm, I think the problem is that connlabel.conf
> maps the bit-number to names, e.g.
> 
> 0 foo
> 1 bar
> 
> But these should be parsed as (1<<$number)
> [ in iptables these values are passed to the kernel which
>   uses them as argument to test_bit and friends ].
> 
> Could probably be fixed by having my own parsing
> function instead of reusing the rt_symbol_table one, but I would
> need to replace the uint64_t value in the sym table structure
> for that [need to be able to store (1<<127)]...

I see. Actually I think we could change the rt_parse_symbol function
to generate bitmasks in case of basetype == bitmask_type.
