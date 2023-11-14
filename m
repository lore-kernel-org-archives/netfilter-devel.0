Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234E6C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjKNP0f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjKNP0e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 10:26:34 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640A511D
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 07:26:31 -0800 (PST)
Received: from [78.30.43.141] (port=41980 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r2vJ5-0075hv-F6; Tue, 14 Nov 2023 16:26:29 +0100
Date:   Tue, 14 Nov 2023 16:26:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] src: Add nfq_nlmsg_put2() -
 header flags include NLM_F_ACK
Message-ID: <ZVORoqFJonvQaABS@calendula>
References: <20231112221235.4086-1-duncan_roe@optusnet.com.au>
 <20231112221235.4086-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231112221235.4086-2-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 13, 2023 at 09:12:35AM +1100, Duncan Roe wrote:
> Enable mnl programs to check whether a config request was accepted.
> (nfnl programs do this already).
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
>  src/nlmsg.c                                   | 72 ++++++++++++++++---
>  2 files changed, 65 insertions(+), 8 deletions(-)
> 
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index 3d8e444..084a2ea 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
>  
>  int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
>  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
> +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num);

I like this, but I'd suggest instead:

  struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_flags);

I should have expose those netlink flags in first place.

There are more useful netlink flags, so just expose them all.

Please send a v2.

Thanks.
