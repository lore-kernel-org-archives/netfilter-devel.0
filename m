Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920ADC47072
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjKOKZh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjKOKZg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:25:36 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC7EF5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:25:32 -0800 (PST)
Received: from [78.30.43.141] (port=55326 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3D5L-00BMXE-T5; Wed, 15 Nov 2023 11:25:29 +0100
Date:   Wed, 15 Nov 2023 11:25:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVScl0WNyKIQlghR@calendula>
References: <ZVORoqFJonvQaABS@calendula>
 <20231115100950.6553-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115100950.6553-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 09:09:50PM +1100, Duncan Roe wrote:
> +EXPORT_SYMBOL
> +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
> +				uint16_t flags)
>  {
>  	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
>  	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
> -	nlh->nlmsg_flags = NLM_F_REQUEST
> +	nlh->nlmsg_flags = flags;

Leave this as is.

NLM_F_REQUEST means this message goes to the kernel, this flag is a
must have.
