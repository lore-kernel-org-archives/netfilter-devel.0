From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink_delinearize: restore listing of host
 byteorder set elements
Date: Fri, 5 Jun 2015 12:08:30 +0200
Message-ID: <20150605100830.GB1613@acer.localdomain>
References: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
 <20150604022340.GA13221@acer.localdomain>
 <20150604203031.GA25026@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58152 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbbFEKIe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 06:08:34 -0400
Content-Disposition: inline
In-Reply-To: <20150604203031.GA25026@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.06, Pablo Neira Ayuso wrote:
> On Thu, Jun 04, 2015 at 04:23:40AM +0200, Patrick McHardy wrote:
> > On 03.06, Pablo Neira Ayuso wrote:
> > The fundamental problem is that this is that integers are a special case where
> > we don't always have enough context to properly restore. Literal sets can work
> > because we by definition have a LHS, but it is impossible to fix for named sets.
> >
> > IMO the correct solution is to use endian encoding for integers. Special case
> > the special case, basically. By that I don't mean internally using be_integer
> > and le_integer, but to only do it on the lowest possible level, set type
> > declarations. Our default encoding is BE, so we add a LE integer type and *only*
> > use it for set type declarations and immediately when delinearizing map it back
> > to a regular integer, but adjust the byteorder appropriately.
> > 
> > This will fix both problems, and we can (need to) get rid of the
> > integer_type_postprocess(), which can only work for literal sets.
> 
> I think I'm still in trouble to resolve another (follow up related)
> problem:
> 
> If I want to create a named set that contains 'meta cpu' this selector
> currently relies on the generic integer type:
> 
> # nft add set filter mycpuset { type integer\; }
> <cmdline>:1:19-33: Error: unqualified key data type specified in set definition
> add set test test { type integer; }
>                   ^^^^^^^^^^^^^^^
> 
> this fails because integer_type lacks of byteorder and size.

Right.

> I made a quick patch to add specific types for set declarations, eg.
> 
> # nft add set test test { type cpu32; }
> 
> We would have, let's say: u8, cpu16, cpu32, cpu64, be16, be32, be64,
> whose base datatype is the generic integer_type.
> 
> This would also allow us to define named sets that contain elements to
> be use with any kind of (integer_type) selector.
> 
> As you said, when declaring named sets we need to know the type since
> we have no LHS as this is not yet referenced, this would provide the
> specific datatype definition.
> 
> But if we end up having these specific integer types are in place, I
> fail to see why we should not use them consistently everywhere, no
> matter if this is a literal set, named set or any kind of simple
> comparison.
> 
> Am I missing anything?
> 
> Please advice. Thanks!

The main reason is that we have integer type specific handling that would
then need to check for all possible types. Internally we don't really need
those types if we properly qualify an instantiated integer since our
datatypes specify both byteorder and size. So my idea was to map those
as soon as we have all the required information to keep the code simpler.

Regarding the set declarations - I do not like the idea of having the
user deal with byteorder and type widths directly. I'd rather add a
cpu_id type for this specific case.

I don't think we have more meta types that use plain integers. This
leaves the question of how to deal with packet data. This uXX/beXX
types unfortunately also don't solve this completely. The DCCP protocol
for instance uses 48 bits for its sequence numbers. Its of course
rather unlikely that it makes any sense to use sets for this, but
it illustrates the problem.

An alternative idea would be that instead of specifying a data type,
we allow to specify an expression type that the set should hold.
F.i.

add set filter test { typeof meta cpu; }
add set filter test { typeof dccp seqno; }

What do you think about that?
