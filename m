From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] src: proto: fix byteorder for ip headers.
Date: Thu, 5 Jun 2014 14:48:05 +0200
Message-ID: <20140605124805.GA9653@localhost>
References: <1401885989-9162-1-git-send-email-yshuiv7@gmail.com>
 <20140604164412.GA30746@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yuxuan Shui <yshuiv7@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60662 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaFEMsL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:48:11 -0400
Content-Disposition: inline
In-Reply-To: <20140604164412.GA30746@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Wed, Jun 04, 2014 at 06:44:13PM +0200, Patrick McHardy wrote:
> On Wed, Jun 04, 2014 at 08:46:29PM +0800, Yuxuan Shui wrote:
> > Add a new datatype for ip headers which specify the byteorder, this
> > fixes bug 918.
> > 
> > Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
> > ---
> >  src/proto.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/proto.c b/src/proto.c
> > index 0a37a65..f1556db 100644
> > --- a/src/proto.c
> > +++ b/src/proto.c
> > @@ -184,13 +184,21 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
> >  	proto_ctx_debug(ctx, base);
> >  }
> >  
> > +const struct datatype net_integer = {
> > +	.type = TYPE_INTEGER,
> > +	.byteorder = BYTEORDER_BIG_ENDIAN,
> > +	.name = "net_integer",
> > +	.desc = "network integer",
> > +	.basetype = &integer_type,
> > +};
> > +
> >  #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
> >  	PROTO_HDR_TEMPLATE(__name, __dtype,				\
> >  			   offsetof(__type, __member) * 8,		\
> >  			   field_sizeof(__type, __member) * 8)
> >  
> >  #define HDR_FIELD(__name, __struct, __member)				\
> > -	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
> > +	HDR_TEMPLATE(__name, &net_integer, __struct, __member)
> >  #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
> >  	PROTO_HDR_TEMPLATE(__name, __dtype, __offset, __len)
> >  #define HDR_TYPE(__name, __dtype, __struct, __member)			\
> 
> While this does make some sense, I would rather change
> byteorder_conversion_op() to return immediately for expressions of size <= 8.
> There is obviously no byteorder in this case, so this seems more like
> working around incorrect behaviour of that function.

Indeed, that should calm down that assertion.

But I think this patch also addresses another problem that we have.
The integer_type_parse function uses hostbyte order type for values in
the network header fields. I think this patch also addresses wrong
byteorder when the header field is larger than 8 bits.
