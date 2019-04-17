Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE14DC282DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 04:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B722620835
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 04:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfDQE11 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 00:27:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfDQE11 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 00:27:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B25C14F7D33C;
        Tue, 16 Apr 2019 21:27:26 -0700 (PDT)
Date:   Tue, 16 Apr 2019 21:27:24 -0700 (PDT)
Message-Id: <20190416.212724.633941425790173809.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 04/10] net: ipv6: split skbuff into fragments
 transformer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190415213611.21863-5-pablo@netfilter.org>
References: <20190415213611.21863-1-pablo@netfilter.org>
        <20190415213611.21863-5-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Apr 2019 21:27:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 15 Apr 2019 23:36:05 +0200

> The API consists of:
> 
> * ip6_frag_init(), that initializes the internal state of the transformer.
> * ip6_frag_next(), that allows you to fetch the next fragment. This function
>   internally allocates the skbuff that represents the fragment, it pushes
>   the IPv6, and it also copies the payload for this fragment.
    ^^^^^^^^

I think you mean "the IPv6 header" here?

