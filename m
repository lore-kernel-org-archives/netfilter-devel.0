Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A201C4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 23:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E73692148D
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 23:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfCKXOo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 19:14:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfCKXOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 19:14:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A938D14C73B02;
        Mon, 11 Mar 2019 16:14:43 -0700 (PDT)
Date:   Mon, 11 Mar 2019 16:14:43 -0700 (PDT)
Message-Id: <20190311.161443.2250099985009990222.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190311225035.21250-1-pablo@netfilter.org>
References: <20190311225035.21250-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Mar 2019 16:14:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 11 Mar 2019 23:50:30 +0100

> The following patchset contains Netfilter fixes for your net tree:
> 
> 1) Fix list corruption in device notifier in the masquerade
>    infrastructure, from Florian Westphal.
> 
> 2) Fix double-free of sets and use-after-free when deleting elements.
> 
> 3) Don't bogusly return EBUSY when removing a set after flush command.
> 
> 4) Use-after-free in dynamically allocate operations.
> 
> 5) Don't report a new ruleset generation to userspace if transaction
>    list is empty, this invalidates the userspace cache innecessarily.
>    From Florian Westphal.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
