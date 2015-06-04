From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delinearize: restore listing of host
 byteorder set elements
Date: Thu, 4 Jun 2015 22:30:31 +0200
Message-ID: <20150604203031.GA25026@salvia>
References: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
 <20150604022340.GA13221@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60278 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbbFDUZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2015 16:25:27 -0400
Content-Disposition: inline
In-Reply-To: <20150604022340.GA13221@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 04, 2015 at 04:23:40AM +0200, Patrick McHardy wrote:
> On 03.06, Pablo Neira Ayuso wrote:
> > before:
> > 
> > table ip filter {
> >         chain test {
> >                 cpu { 67108864, 50331648, 33554432}
> >         }
> > }
> > 
> > after:
> > 
> > table ip filter {
> >         chain test {
> >                 cpu { 4, 3, 2 }
> >         }
> > }
> > 
> > Related to 525323352904 ("expr: add set_elem_expr as container for set element
> > attributes").
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Note: This patch applies to the next-4.1 branch.
> > 
> >  src/netlink_delinearize.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index b1ce911..ea60c86 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -824,6 +824,10 @@ static void integer_type_postprocess(struct expr *expr)
> >  			integer_type_postprocess(i);
> >  		}
> >  		break;
> > +	case EXPR_SET_ELEM:
> > +		expr_set_type(expr->key, expr->dtype, expr->byteorder);
> > +		integer_type_postprocess(expr->key);
> 
> 
> The fundamental problem is that this is that integers are a special case where
> we don't always have enough context to properly restore. Literal sets can work
> because we by definition have a LHS, but it is impossible to fix for named sets.
>
> IMO the correct solution is to use endian encoding for integers. Special case
> the special case, basically. By that I don't mean internally using be_integer
> and le_integer, but to only do it on the lowest possible level, set type
> declarations. Our default encoding is BE, so we add a LE integer type and *only*
> use it for set type declarations and immediately when delinearizing map it back
> to a regular integer, but adjust the byteorder appropriately.
> 
> This will fix both problems, and we can (need to) get rid of the
> integer_type_postprocess(), which can only work for literal sets.

I think I'm still in trouble to resolve another (follow up related)
problem:

If I want to create a named set that contains 'meta cpu' this selector
currently relies on the generic integer type:

# nft add set filter mycpuset { type integer\; }
<cmdline>:1:19-33: Error: unqualified key data type specified in set definition
add set test test { type integer; }
                  ^^^^^^^^^^^^^^^

this fails because integer_type lacks of byteorder and size.

I made a quick patch to add specific types for set declarations, eg.

# nft add set test test { type cpu32; }

We would have, let's say: u8, cpu16, cpu32, cpu64, be16, be32, be64,
whose base datatype is the generic integer_type.

This would also allow us to define named sets that contain elements to
be use with any kind of (integer_type) selector.

As you said, when declaring named sets we need to know the type since
we have no LHS as this is not yet referenced, this would provide the
specific datatype definition.

But if we end up having these specific integer types are in place, I
fail to see why we should not use them consistently everywhere, no
matter if this is a literal set, named set or any kind of simple
comparison.

Am I missing anything?

Please advice. Thanks!
