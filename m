Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557ABC43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 19:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 276122173E
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 19:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLFTpY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 14:45:24 -0500
Received: from correo.us.es ([193.147.175.20]:41726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfLFTpX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 14:45:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9541BC514C
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 20:45:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85DF8DA703
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 20:45:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B589DA702; Fri,  6 Dec 2019 20:45:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46CCBDA701;
        Fri,  6 Dec 2019 20:45:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Dec 2019 20:45:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 21A064265A5A;
        Fri,  6 Dec 2019 20:45:17 +0100 (CET)
Date:   Fri, 6 Dec 2019 20:45:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,nf-next RFC 1/2] netfilter: nf_tables: add
 nft_setelem_parse_key()
Message-ID: <20191206194517.gg6e34uekje647sn@salvia>
References: <20191202131407.500999-1-pablo@netfilter.org>
 <20191202131407.500999-2-pablo@netfilter.org>
 <20191205234350.3dd81c1c@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205234350.3dd81c1c@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 05, 2019 at 11:43:50PM +0100, Stefano Brivio wrote:
> Hi Pablo,
> 
> Just two nits:
> 
> On Mon,  2 Dec 2019 14:14:06 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > Add helper function to parse the set element key netlink attribute.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 56 ++++++++++++++++++++++++-------------------
> >  1 file changed, 32 insertions(+), 24 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 0db2784fee9a..13e291fac26f 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -4490,11 +4490,31 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
> >  	return 0;
> >  }
> >  
> > +static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
> > +				 struct nft_data *key, struct nlattr *attr)
> > +{
> > +	struct nft_data_desc desc;
> > +	int err;
> > +
> > +	err = nft_data_init(ctx, key, sizeof(*key), &desc, attr);
> > +	if (err < 0)
> > +		goto err1;
> > +
> > +	err = -EINVAL;
> > +	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
> > +		goto err2;
> > +
> > +	return 0;
> > +err2:
> > +	nft_data_release(key, desc.type);
> > +err1:
> > +	return err;
> > +}
> > +
> >  static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  			    const struct nlattr *attr)
> >  {
> >  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
> > -	struct nft_data_desc desc;
> >  	struct nft_set_elem elem;
> >  	struct sk_buff *skb;
> >  	uint32_t flags = 0;
> > @@ -4513,15 +4533,11 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  	if (err < 0)
> >  		return err;
> >  
> > -	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
> > -			    nla[NFTA_SET_ELEM_KEY]);
> > +	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
> > +				    nla[NFTA_SET_ELEM_KEY]);
> >  	if (err < 0)
> >  		return err;
> >  
> > -	err = -EINVAL;
> > -	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
> > -		return err;
> > -
> >  	priv = set->ops->get(ctx->net, set, &elem, flags);
> >  	if (IS_ERR(priv))
> >  		return PTR_ERR(priv);
> > @@ -4720,13 +4736,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  {
> >  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
> >  	u8 genmask = nft_genmask_next(ctx->net);
> > -	struct nft_data_desc d1, d2;
> >  	struct nft_set_ext_tmpl tmpl;
> >  	struct nft_set_ext *ext, *ext2;
> >  	struct nft_set_elem elem;
> >  	struct nft_set_binding *binding;
> >  	struct nft_object *obj = NULL;
> >  	struct nft_userdata *udata;
> > +	struct nft_data_desc d2;
> 
> At this point, this could simply be desc, or data_desc.
> 
> >  	struct nft_data data;
> >  	enum nft_registers dreg;
> >  	struct nft_trans *trans;
> > @@ -4792,15 +4808,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  			return err;
> >  	}
> >  
> > -	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
> > -			    nla[NFTA_SET_ELEM_KEY]);
> > +	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
> > +				    nla[NFTA_SET_ELEM_KEY]);
> >  	if (err < 0)
> >  		goto err1;
> > -	err = -EINVAL;
> > -	if (d1.type != NFT_DATA_VALUE || d1.len != set->klen)
> > -		goto err2;
> >  
> > -	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, d1.len);
> > +	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
> >  	if (timeout > 0) {
> >  		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
> >  		if (timeout != set->timeout)
> > @@ -4942,7 +4955,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  	if (nla[NFTA_SET_ELEM_DATA] != NULL)
> >  		nft_data_release(&data, d2.type);
> >  err2:
> > -	nft_data_release(&elem.key.val, d1.type);
> > +	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
> >  err1:
> >  	return err;
> >  }
> > @@ -5038,7 +5051,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
> >  {
> >  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
> >  	struct nft_set_ext_tmpl tmpl;
> > -	struct nft_data_desc desc;
> >  	struct nft_set_elem elem;
> >  	struct nft_set_ext *ext;
> >  	struct nft_trans *trans;
> > @@ -5063,16 +5075,12 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
> >  	if (flags != 0)
> >  		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
> >  
> > -	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
> > -			    nla[NFTA_SET_ELEM_KEY]);
> > +	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
> > +				    nla[NFTA_SET_ELEM_KEY]);
> >  	if (err < 0)
> >  		goto err1;
> >  
> > -	err = -EINVAL;
> > -	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
> > -		goto err2;
> > -
> > -	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, desc.len);
> > +	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
> >  
> >  	err = -ENOMEM;
> >  	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
> > @@ -5109,7 +5117,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
> >  err3:
> >  	kfree(elem.priv);
> >  err2:
> > -	nft_data_release(&elem.key.val, desc.type);
> > +	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
> 
> I'm not sure if this can actually happen, but in
> nft_setelem_parse_key() you are checking that the type is
> NFT_DATA_VALUE, and returning error if it's not.

Exactly.

> If the type is not NFT_DATA_VALUE, I guess we shouldn't pass
> NFT_DATA_VALUE to nft_data_release() here.

The new nft_setelem_parse_key() function makes sure that the key is
NFT_DATA_VALUE, otherwise bails out and calls nft_data_release() with
desc.type.

Then, moving forward in nft_add_set_elem() after the
nft_setelem_parse_key(), if an error occurs, nft_data_release() can be
called with NFT_DATA_VALUE, because that was already validated by
nft_setelem_parse_key().

> Maybe nft_setelem_parse_key() could clean up after itself on error.

It's doing so already, right? See err2: label.

> After all, nft_data_init() is now called from there.
> 
> >  err1:
> >  	return err;
> >  }
> 
> Otherwise, it looks good to me. Note that, while I'm working on
> integrating this with the rest of kernel changes right now, I haven't
> tested it in any way (that needs your changes for userspace).

Great.

Let me know if you have more questions, thanks!
