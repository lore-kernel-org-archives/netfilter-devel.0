Return-Path: <SRS0=2b08=BD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6C0C433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jul 2020 00:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FD820792
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jul 2020 00:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgGXAWd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgGXAW3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971C4C0619D3;
        Thu, 23 Jul 2020 17:22:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C819811E48C66;
        Thu, 23 Jul 2020 17:05:43 -0700 (PDT)
Date:   Thu, 23 Jul 2020 17:22:25 -0700 (PDT)
Message-Id: <20200723.172225.364109671281508026.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Netfilter/IPVS fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723223508.17038-1-pablo@netfilter.org>
References: <20200723223508.17038-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 17:05:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 24 Jul 2020 00:35:06 +0200

> The following patchset contains Netfilter/IPVS fixes for net:
> 
> 1) Fix NAT hook deletion when table is dormant, from Florian Westphal.
> 
> 2) Fix IPVS sync stalls, from guodeqing.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
