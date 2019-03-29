Return-Path: <SRS0=SelT=SA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2766C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B25820811
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Mar 2019 10:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfC2Ksv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 06:48:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53290 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbfC2Ksu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 06:48:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h9p45-0004QL-0p; Fri, 29 Mar 2019 11:48:49 +0100
Message-ID: <b29541914e7c1069752948c6376ee68980ac3eae.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 2/4] netlink: add generic object description
 infrastructure
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Date:   Fri, 29 Mar 2019 11:48:47 +0100
In-Reply-To: <20180207013713.2432-3-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-3-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2018-02-07 at 02:37 +0100, Pablo Neira Ayuso wrote:
> +++ b/include/net/net_namespace.h
> @@ -78,6 +78,7 @@ struct net {
>  
>  	struct sock 		*rtnl;			/* rtnetlink socket */
>  	struct sock		*genl_sock;
> +	struct sock		*nl_desc_sock;

Using genl would save that =)

> +enum {
> +	NLDESC_GET_CMDS		= 16,
> +	NLDESC_NEW_CMDS,

I would say all of this new API should be in a new header file.

> +enum nft_nldesc_req_attributes {

nft_ prefix also doesn't seem appropriate.

> +static int nl_desc_handle_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)

From here on it's also mostly boilerplate code that using genl handles
:-)

johannes

