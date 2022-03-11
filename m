Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831F3C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Mar 2022 14:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiCKOFA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 09:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbiCKOE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 09:04:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CBF7464
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 06:03:55 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nSfs0-0007O0-SS; Fri, 11 Mar 2022 15:03:52 +0100
Date:   Fri, 11 Mar 2022 15:03:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 3/3] desc: add set description
Message-ID: <YitWyJ73Gl/Tf00Z@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220120000402.916332-1-pablo@netfilter.org>
 <20220120000402.916332-4-pablo@netfilter.org>
 <Yinhg4XTUjuTuezv@orbyte.nwl.cc>
 <YiqIsbxAQUlIpJSY@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiqIsbxAQUlIpJSY@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 11, 2022 at 12:24:33AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 10, 2022 at 12:31:15PM +0100, Phil Sutter wrote:
> > Hi,
> > 
> > On Thu, Jan 20, 2022 at 01:04:02AM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > diff --git a/src/desc.c b/src/desc.c
> > > index f73e74c2c7d3..c8b3195db850 100644
> > > --- a/src/desc.c
> > > +++ b/src/desc.c
> > [...]
> > > +static int nftnl_set_desc_build_dtype(struct nftnl_udata_buf *udbuf,
> > > +				      const struct nftnl_set_desc *dset)
> > > +{
> > > +	struct nftnl_udata *nest;
> > > +	int i, err;
> > > +
> > > +	switch (dset->type) {
> > > +	case NFTNL_DESC_SET_TYPEOF:
> > > +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY);
> > > +		for (i = 0; i < dset->key.num_type; i++) {
> > > +			err = __nftnl_udata_set_dtype_build(udbuf, dset->key.dtype[i], i);
> > > +			if (err < 0)
> > > +				return err;
> > > +		}
> > > +		nftnl_udata_nest_end(udbuf, nest);
> > > +		break;
> > > +	case NFTNL_DESC_SET_DATATYPE:
> > > +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA);
> > > +		for (i = 0; i < dset->data.num_type; i++) {
> > > +			err = __nftnl_udata_set_dtype_build(udbuf, dset->data.dtype[i], i);
> > > +			if (err < 0)
> > > +				return err;
> > > +		}
> > > +		nftnl_udata_nest_end(udbuf, nest);
> > > +		break;
> > > +	case NFTNL_DESC_SET_UNSPEC:
> > > +		return -1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int __nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
> > > +					 const struct nftnl_expr_desc *dexpr,
> > > +					 uint8_t attr_type)
> > > +{
> > > +	struct nftnl_udata *nest;
> > > +	int err;
> > > +
> > > +	nest = nftnl_udata_nest_start(udbuf, attr_type);
> > > +	err = nftnl_expr_desc_build(udbuf, dexpr);
> > > +	nftnl_udata_nest_end(udbuf, nest);
> > > +
> > > +	return err;
> > > +}
> > > +
> > > +static int nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
> > > +				       const struct nftnl_set_desc *dset)
> > > +{
> > > +	struct nftnl_udata *nest;
> > > +	int i;
> > > +
> > > +	switch (dset->type) {
> > > +	case NFTNL_DESC_SET_TYPEOF:
> > > +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
> > > +		for (i = 0; i < dset->key.num_typeof; i++)
> > > +			__nftnl_set_desc_build_typeof(udbuf, dset->key.expr[i], i);
> > > +
> > > +		nftnl_udata_nest_end(udbuf, nest);
> > > +		break;
> > > +	case NFTNL_DESC_SET_DATATYPE:
> > > +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
> > > +		for (i = 0; i < dset->key.num_typeof; i++)
> > > +			__nftnl_set_desc_build_typeof(udbuf, dset->data.expr[i], i);
> > > +
> > > +		nftnl_udata_nest_end(udbuf, nest);
> > > +		break;
> > > +	case NFTNL_DESC_SET_UNSPEC:
> > > +		return -1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +EXPORT_SYMBOL(nftnl_set_desc_build_udata);
> > > +int nftnl_set_desc_build_udata(struct nftnl_udata_buf *udbuf,
> > > +			       const struct nftnl_set_desc *dset)
> > > +{
> > > +	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_FLAGS, dset->flags))
> > > +		return -1;
> > > +
> > > +	switch (dset->type) {
> > > +	case NFTNL_DESC_SET_DATATYPE:
> > > +		return nftnl_set_desc_build_dtype(udbuf, dset);
> > > +	case NFTNL_DESC_SET_TYPEOF:
> > > +		return nftnl_set_desc_build_typeof(udbuf, dset);
> > > +	case NFTNL_DESC_SET_UNSPEC:
> > > +		return -1;
> > > +	}
> > > +
> > > +	if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_COMMENT, dset->comment))
> > > +		return -1;
> > > +
> > > +	return -1;
> > > +}
> > 
> > This is odd: Depending on dset->type, nftnl_set_desc_build_udata() calls
> > either nftnl_set_desc_build_dtype() or nftnl_set_desc_build_typeof().
> 
> That's indeed incorrect, nftnl_set_desc_build_typeof() should be:
> 
> static int nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
> 				       const struct nftnl_set_desc *dset)
> {
> 	struct nftnl_udata *nest;
> 	int i;
> 
> 	nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
> 	for (i = 0; i < dset->key.num_typeof; i++)
> 		__nftnl_set_desc_build_typeof(udbuf, dset->key.expr[i], i);
> 
> 	nftnl_udata_nest_end(udbuf, nest);
> 
> 	return 0;
> }

Ah, so only the NFTNL_DESC_SET_TYPEOF case content.

> The idea is: A set can either use datatype or typeof to define the
> elements that it stores. Then, a concatenation is possible.
> 
> > Yet both check dset->type again. This looks like a mix-up of set/map key
> > and data definitions and typeof vs. "regular" definition styles.
> 
> This patchset was a sketch PoC, I should have label it more explicit
> as such.

Sure, I was aware of that. Figuring out how to make use of it is a bit
of forensics though. The API is not identical to the one internally in
nftables it replaces and since I don't know how it is supposed to
function but only see how it may function based on the existing code, it
is not easy to figure out which pieces are missing or where to adjust
either this series or nftables code.

Cheers, Phil
