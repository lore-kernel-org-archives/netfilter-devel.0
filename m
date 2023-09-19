Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A667CD5BA8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 12:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjISMUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 08:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjISMUG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 08:20:06 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37381BC7
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 05:18:46 -0700 (PDT)
Received: from [78.30.34.192] (port=48292 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qiZgf-00Fbta-UC; Tue, 19 Sep 2023 14:18:43 +0200
Date:   Tue, 19 Sep 2023 14:18:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] datatype: explicitly set missing datatypes for
 TYPE_CT_LABEL,TYPE_CT_EVENTBIT
Message-ID: <ZQmRoKljTJJWEGx1@calendula>
References: <20230919112811.2752909-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230919112811.2752909-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Tue, Sep 19, 2023 at 01:28:03PM +0200, Thomas Haller wrote:
> It's not obvious that two enum values are missing (or why). Explicitly
> set the values to NULL, so we can see this more easily.

I think this is uncovering a bug with these selectors.

When concatenations are used, IIRC the delinerize path needs this.

TYPE_CT_EVENTBIT does not need this, because this is a statement to
globally filter ctnetlink events events.

But TYPE_CT_LABEL is likely not working fine with concatenations.

Let me take a closer look.

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  src/datatype.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 70c84846f70e..bb0c3cf79150 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -65,6 +65,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
>  	[TYPE_CT_DIR]		= &ct_dir_type,
>  	[TYPE_CT_STATUS]	= &ct_status_type,
>  	[TYPE_ICMP6_TYPE]	= &icmp6_type_type,
> +	[TYPE_CT_LABEL]		= NULL,
>  	[TYPE_PKTTYPE]		= &pkttype_type,
>  	[TYPE_ICMP_CODE]	= &icmp_code_type,
>  	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
> @@ -72,8 +73,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
>  	[TYPE_DEVGROUP]		= &devgroup_type,
>  	[TYPE_DSCP]		= &dscp_type,
>  	[TYPE_ECN]		= &ecn_type,
> -	[TYPE_FIB_ADDR]         = &fib_addr_type,
> +	[TYPE_FIB_ADDR]		= &fib_addr_type,
>  	[TYPE_BOOLEAN]		= &boolean_type,
> +	[TYPE_CT_EVENTBIT]	= NULL,
>  	[TYPE_IFNAME]		= &ifname_type,
>  	[TYPE_IGMP_TYPE]	= &igmp_type_type,
>  	[TYPE_TIME_DATE]	= &date_type,
> -- 
> 2.41.0
> 
