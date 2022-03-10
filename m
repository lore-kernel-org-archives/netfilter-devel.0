Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3077AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 11:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbiCJLcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 06:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiCJLcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 06:32:18 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F24141FC5
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 03:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dca6DgGE8A5ax6C3rXeqMly2KN4U+kb5bzLDB1Jtywk=; b=nYAn2tlMkLmZ9p/p6HyoEmPhWl
        TBiGiffq/r4mB6ZzCXnasOSRRblEdvGM3a6i8lTL1kMVAvwkeGk6BDKy5jJ0DJpqvopqBCQqUTKRu
        r2+r0KcAayqK1/xIZx3ryBebM90AZC7nNex3piL8/9OkAUTfyLVSyBL1yTTybaLpi6GKf16mK16d4
        6K6PHGLWgdAKWkuM4YCwNr73iZDilPFmYjrFsCpVkFcggQhU0hiSh6RBw4RCJRwksTyg6sLd/sUd6
        37L3UIHk7asbi13ZzCx9GwERtMqPjSz0WXoQluNNZumavvlWnQjWgNES4xM3LVsr4aimlse1Hfc81
        BGn4KyQg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nSH0l-0000MI-Bf; Thu, 10 Mar 2022 12:31:15 +0100
Date:   Thu, 10 Mar 2022 12:31:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 3/3] desc: add set description
Message-ID: <Yinhg4XTUjuTuezv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220120000402.916332-1-pablo@netfilter.org>
 <20220120000402.916332-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120000402.916332-4-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jan 20, 2022 at 01:04:02AM +0100, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/desc.c b/src/desc.c
> index f73e74c2c7d3..c8b3195db850 100644
> --- a/src/desc.c
> +++ b/src/desc.c
[...]
> +static int nftnl_set_desc_build_dtype(struct nftnl_udata_buf *udbuf,
> +				      const struct nftnl_set_desc *dset)
> +{
> +	struct nftnl_udata *nest;
> +	int i, err;
> +
> +	switch (dset->type) {
> +	case NFTNL_DESC_SET_TYPEOF:
> +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY);
> +		for (i = 0; i < dset->key.num_type; i++) {
> +			err = __nftnl_udata_set_dtype_build(udbuf, dset->key.dtype[i], i);
> +			if (err < 0)
> +				return err;
> +		}
> +		nftnl_udata_nest_end(udbuf, nest);
> +		break;
> +	case NFTNL_DESC_SET_DATATYPE:
> +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA);
> +		for (i = 0; i < dset->data.num_type; i++) {
> +			err = __nftnl_udata_set_dtype_build(udbuf, dset->data.dtype[i], i);
> +			if (err < 0)
> +				return err;
> +		}
> +		nftnl_udata_nest_end(udbuf, nest);
> +		break;
> +	case NFTNL_DESC_SET_UNSPEC:
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
> +					 const struct nftnl_expr_desc *dexpr,
> +					 uint8_t attr_type)
> +{
> +	struct nftnl_udata *nest;
> +	int err;
> +
> +	nest = nftnl_udata_nest_start(udbuf, attr_type);
> +	err = nftnl_expr_desc_build(udbuf, dexpr);
> +	nftnl_udata_nest_end(udbuf, nest);
> +
> +	return err;
> +}
> +
> +static int nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
> +				       const struct nftnl_set_desc *dset)
> +{
> +	struct nftnl_udata *nest;
> +	int i;
> +
> +	switch (dset->type) {
> +	case NFTNL_DESC_SET_TYPEOF:
> +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
> +		for (i = 0; i < dset->key.num_typeof; i++)
> +			__nftnl_set_desc_build_typeof(udbuf, dset->key.expr[i], i);
> +
> +		nftnl_udata_nest_end(udbuf, nest);
> +		break;
> +	case NFTNL_DESC_SET_DATATYPE:
> +		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
> +		for (i = 0; i < dset->key.num_typeof; i++)
> +			__nftnl_set_desc_build_typeof(udbuf, dset->data.expr[i], i);
> +
> +		nftnl_udata_nest_end(udbuf, nest);
> +		break;
> +	case NFTNL_DESC_SET_UNSPEC:
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +EXPORT_SYMBOL(nftnl_set_desc_build_udata);
> +int nftnl_set_desc_build_udata(struct nftnl_udata_buf *udbuf,
> +			       const struct nftnl_set_desc *dset)
> +{
> +	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_FLAGS, dset->flags))
> +		return -1;
> +
> +	switch (dset->type) {
> +	case NFTNL_DESC_SET_DATATYPE:
> +		return nftnl_set_desc_build_dtype(udbuf, dset);
> +	case NFTNL_DESC_SET_TYPEOF:
> +		return nftnl_set_desc_build_typeof(udbuf, dset);
> +	case NFTNL_DESC_SET_UNSPEC:
> +		return -1;
> +	}
> +
> +	if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_COMMENT, dset->comment))
> +		return -1;
> +
> +	return -1;
> +}

This is odd: Depending on dset->type, nftnl_set_desc_build_udata() calls
either nftnl_set_desc_build_dtype() or nftnl_set_desc_build_typeof().
Yet both check dset->type again. This looks like a mix-up of set/map key
and data definitions and typeof vs. "regular" definition styles.

Cheers, Phil
