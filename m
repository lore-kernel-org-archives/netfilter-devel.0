Return-Path: <SRS0=SelT=SA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C067C10F05
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7414D20811
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfC2Kop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 06:44:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53250 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbfC2Kop (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 06:44:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h9p07-0004Kx-Gt; Fri, 29 Mar 2019 11:44:43 +0100
Message-ID: <3fdd5b418c07c98075e807b878a24571ec025eca.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 1/4] netlink: add NLA_PAD definition
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Date:   Fri, 29 Mar 2019 11:44:42 +0100
In-Reply-To: <20180207013713.2432-2-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-2-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2018-02-07 at 02:37 +0100, Pablo Neira Ayuso wrote:
> The new generic netlink description infrastructure needs this new type
> to describe padding attributes.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netlink.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 0c154f98e987..76e850ead593 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -180,6 +180,7 @@ enum {
>  	NLA_S32,
>  	NLA_S64,
>  	NLA_BITFIELD32,
> +	NLA_PAD,
>  	__NLA_TYPE_MAX,
>  };
>  
> @@ -209,6 +210,7 @@ enum {
>   *                         given type fits, using it verifies minimum length
>   *                         just like "All other"
>   *    NLA_BITFIELD32      A 32-bit bitmap/bitselector attribute
> + *    NLA_PAD		   Empty attribute to align next attribute to 64-bits

I guess this should also move to uapi/linux/netlink.h.

johannes

