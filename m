Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6A2C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 20:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270D3217F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 20:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbfDQUhL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:37:11 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37214 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730374AbfDQUhL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 16:37:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hGrIp-00067I-I8; Wed, 17 Apr 2019 22:37:07 +0200
Date:   Wed, 17 Apr 2019 22:37:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix nf_l4proto_log_invalid to log invalid
 packets
Message-ID: <20190417203707.vnyavz7hwns2a57q@breakpoint.cc>
References: <20190417164944.1462-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417164944.1462-1-avagin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Andrei Vagin <avagin@gmail.com> wrote:
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index b9403a266a2e..37bb530d848f 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -55,7 +55,7 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
>  	struct va_format vaf;
>  	va_list args;
>  
> -	if (net->ct.sysctl_log_invalid != protonum ||
> +	if (net->ct.sysctl_log_invalid != protonum &&
>  	    net->ct.sysctl_log_invalid != IPPROTO_RAW)

Urgh, thanks for fixing this.

Acked-by: Florian Westphal <fw@strlen.de>
