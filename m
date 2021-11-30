Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B05C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 13:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhK3NuY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 08:50:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhK3NuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 08:50:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 53C76605C7;
        Tue, 30 Nov 2021 14:44:47 +0100 (CET)
Date:   Tue, 30 Nov 2021 14:46:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/7] set: Introduce NFTNL_SET_DESC_CONCAT_DATA
Message-ID: <YaYrUvXHfPLBYskH@salvia>
References: <20211124172242.11402-1-phil@nwl.cc>
 <20211124172242.11402-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211124172242.11402-4-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Nov 24, 2021 at 06:22:38PM +0100, Phil Sutter wrote:
> Analogous to NFTNL_SET_DESC_CONCAT, introduce a data structure
> describing individual data lengths of elements' concatenated data
> fields.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/libnftnl/set.h | 1 +
>  include/set.h          | 2 ++
>  src/set.c              | 8 ++++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> index 1ffb6c415260d..958bbc9065f67 100644
> --- a/include/libnftnl/set.h
> +++ b/include/libnftnl/set.h
> @@ -33,6 +33,7 @@ enum nftnl_set_attr {
>  	NFTNL_SET_EXPR,
>  	NFTNL_SET_EXPRESSIONS,
>  	NFTNL_SET_DESC_BYTEORDER,
> +	NFTNL_SET_DESC_CONCAT_DATA,

This information is already encoded in NFTNL_SET_DATA_TYPE, the
datatypes that are defined in libnftables have an explicit byteorder
and length.

For concatenation, this information is stored in 6 bits (see
TYPE_BITS). By parsing the NFTNL_SET_DATA_TYPE field you can extract
both types (and byteorders) of the set definition.

For the typeof case, where a generic datatype such as integer is used,
this information is stored in the SET_USERDATA area.

This update for libnftnl is adding a third way to describe the
datatypes in the set, right?

>  	__NFTNL_SET_MAX
>  };
>  #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
