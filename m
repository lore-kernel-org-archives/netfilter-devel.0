From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sat, 20 Aug 2005 13:14:03 -0700 (PDT)
Message-ID: <20050820.131403.37427784.davem@davemloft.net>
References: <43075517.3070405@eurodev.net>
	<43075BEA.1030701@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43075BEA.1030701@trash.net>
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
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sat, 20 Aug 2005 18:35:54 +0200

> Pablo Neira wrote:
> > Here comes the iptables string match since the textsearch infrastructure
> > went into 2.6.13. This adds to iptables the ability of looking for given
> > patterns in packets. I'll be happy to see this stuff in Davem's 2.6.14
> > tree ;)
> 
> > +struct ipt_string_info
> > +{
> > +	u_int16_t		from_offset;
> > +	u_int16_t		to_offset;
> > +	char			algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
> > +	char			pattern[IPT_STRING_MAX_PATTERN_SIZE];
> > +	u_int8_t		patlen;
> > +	u_int8_t		invert;
> > +	struct ts_config	*config;
> > +};
> 
> Embedding a pointer in the struct causes different alignment depending
> on the wordsize and doesn't work in mixed 64/32 bit environments.
> Please use __attribute__((aligned(8))) to prevent this.

Our ability to translate netfilter structures in compat mode
is primitive, at best, and I think we really should try to
do something about this soon.

This IP tables modules can provide a bit of help, with some kind
of descriptor, or set of methods the compat layer can call into
for help (or a flag saying, "no translation necessary").

One thing about the implementation is that it is apparent that
people often load an _enormous_ amount of rules.  A large enough
set that kmalloc() can't get enough space for the entire rule set.
I've seen a report about this recently on sparc64, where someone
tries to load enough ipt_replace rules that the kmalloc() done
by the compat mode translation stuff was too large.

One thing that can help is to not put pointers into these rules,
that is actually the most difficult case to handle.  Without
pointers, the entire struct can be defined using portable types
that require no translation.  Once you introduce a pointer, using
the user's struct as-is becomes impossible.  (as an added bonus
such rules could thus be sent over the wire as well, if we ever
wanted to do that)

In this case, we could put a zero length array at the end.  But
I realize that with iptables rules this may be difficult due to
some restriction I am not aware of.
