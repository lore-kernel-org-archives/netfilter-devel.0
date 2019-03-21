Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627DBC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 17:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3173F218B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 17:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfCURHZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:07:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfCURHY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 13:07:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88FDE133E976A;
        Thu, 21 Mar 2019 10:07:24 -0700 (PDT)
Date:   Thu, 21 Mar 2019 10:07:23 -0700 (PDT)
Message-Id: <20190321.100723.783685956469717987.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190321112845.10627-1-pablo@netfilter.org>
References: <20190321112845.10627-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Mar 2019 10:07:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 21 Mar 2019 12:28:36 +0100

> The following patchset contains Netfilter fixes for your net tree:
> 
> 1) Remove a direct dependency with IPv6 introduced by the
>    sip_external_media feature, from Alin Nastac.
> 
> 2) Fix bogus ENOENT when removing interval elements from set.
> 
> 3) Set transport_header from br_netfilter to mimic the stack
>    behaviour, this partially fixes a checksum validation bug
>    from the SCTP connection tracking, from Xin Long.
> 
> 4) Fix undefined reference to symbol in xt_TEE, due to missing
>    Kconfig dependencies, from Arnd Bergmann.
> 
> 5) Check for NULL in skb_header_pointer() calls in ip6t_shr,
>    from Kangjie Lu.
> 
> 6) Fix bogus EBUSY when removing an existing conntrack helper from
>    a transaction.
> 
> 7) Fix module autoload of the redirect extension.
> 
> 8) Remove duplicated transition in flowtable diagram in the existing
>    documentation.
> 
> 9) Missing .release_ops call from error path in newrule() which
>    results module refcount leak, from Taehee Yoo.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
