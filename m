Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A61C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 11:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA0C604DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 11:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhIPL2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 07:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbhIPL2K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 07:28:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2909DC061574;
        Thu, 16 Sep 2021 04:26:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQpXN-0002K7-IT; Thu, 16 Sep 2021 13:26:41 +0200
Date:   Thu, 16 Sep 2021 13:26:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v4] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210916112641.GC20414@breakpoint.cc>
References: <20210916041057.459-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916041057.459-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> +	/* Avoid applying nat->range to the reply direction */
> +	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max_proto.all) {
> +		min = ntohs(exp->saved_proto.tcp.port);
> +		range_size = 65535 - min + 1;
> +	} else {
> +		min = ntohs(nat->range_info.min_proto.all);
> +		range_size = ntohs(nat->range_info.max_proto.all) - min + 1;
> +	}
> +
>  	/* Try to get same port: if not, try to change it. */
> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
> -		int ret;
> +	first_port = ntohs(exp->saved_proto.tcp.port);
> +	if (min > first_port || first_port > (min + range_size - 1))
> +		first_port = min;
>  
> +	for (i = 0, port = first_port; i < range_size; i++, port = (port - first_port + i) % range_size) {

This looks complicated.  As far as I understand, this could instead be
written like this (not even compile tested):

	/* Avoid applying nat->range to the reply direction */
	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max_proto.all) {
		min = 1;
		max = 65535;
		range_size = 65535;
	} else {
		min = ntohs(nat->range_info.min_proto.all);
		max = ntohs(nat->range_info.max_proto.all);
		range_size = max - min + 1;
	}

  	/* Try to get same port: if not, try to change it. */
	port = ntohs(exp->saved_proto.tcp.port);

	if (port < min || port > max)
		port = min;

	for (i = 0; i < range_size; i++) {
  		exp->tuple.dst.u.tcp.port = htons(port);
  		ret = nf_ct_expect_related(exp, 0);
		if (ret != -EBUSY)
 			break;
		port++;
		if (port > max)
			port = min;
  	}

	if (ret != 0) {
	...

AFAICS this is the same, we loop at most range_size times,
in case range_size is 64k, we will loop through all (hmmm,
not good actually, but better make that a different change)
else through given min - max range.

If orig port was in-range, we try it first, then increment.
If port exceeds upper bound, cycle back to min.

What do you think?
