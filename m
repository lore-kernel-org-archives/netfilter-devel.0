From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nft_hash: support of symmetric
 hash
Date: Wed, 1 Mar 2017 12:49:37 +0100
Message-ID: <20170301114937.GA8511@salvia>
References: <20170228173826.e2lx4f2yrbn7aegn@nevthink>
 <CAML_gOc8AAQ6ijDS65c1Qb6cYhBWFbEs814yDH5_27m1t6hsQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdCAMAp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 07:00:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E198117D853
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:49:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D20B4DA801
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:49:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A3B8DA855
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:49:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOc8AAQ6ijDS65c1Qb6cYhBWFbEs814yDH5_27m1t6hsQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 12:11:54PM +0800, Liping Zhang wrote:
> Hi,
> 
> 2017-03-01 1:38 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
> [...]
> > +static const struct nft_expr_ops *
> > +nft_hash_select_ops(const struct nft_ctx *ctx,
> > +                   const struct nlattr * const tb[])
> > +{
> > +       u32 type;
> > +
> > +       if (!tb[NFTA_HASH_TYPE])
> > +               return ERR_PTR(-EINVAL);
> 
> For compatibility reason, if tb[NFTA_HASH_TYPE] is NULL, maybe it's better
> to return &nft_jhash_ops instead of reporting error.

Right.

I think this function should end up looking like this:

static const struct nft_expr_ops *
nft_hash_select_ops(const struct nft_ctx *ctx,
                    const struct nlattr * const tb[])
{
       u32 type;

       if (!tb[NFTA_HASH_TYPE])
               return &nft_jhash_ops;

       type = ntohl(nla_get_be32(tb[NFTA_HASH_TYPE]));
       switch (type) {
       case NFT_HASH_SYM:
               return &nft_symhash_ops;
       case NFT_HASH_JENKINS:
               return &nft_jhash_ops;
       default:
               break;
       }
       return ERR_PTR(-EOPNOTSUPP);
}

So, this returns nft_jhash_ops if not NFTA_HASH_TYPE is set.

Then, if NFTA_HASH_TYPE is set, select the type according to what
userspace requests.

If userspace request a hash type we don't support, then bail out with
"operation not supported".

Thanks.
