Return-Path: <SRS0=n5XH=7O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B52BC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 18:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D630207D0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 18:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbgFASqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbgFASqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 14:46:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C362FC061A0E;
        Mon,  1 Jun 2020 11:46:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0267B11D53F8B;
        Mon,  1 Jun 2020 11:46:47 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:46:46 -0700 (PDT)
Message-Id: <20200601.114646.1311525662848731154.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/9] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:46:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 29 May 2020 19:50:17 +0200

> The following patchset contains Netfilter updates for net-next
> to extend ctnetlink and the flowtable infrastructure:
> 
> 1) Extend ctnetlink kernel side netlink dump filtering capabilities,
>    from Romain Bellan.
> 
> 2) Generalise the flowtable hook parser to take a hook list.
> 
> 3) Pass a hook list to the flowtable hook registration/unregistration.
> 
> 4) Add a helper function to release the flowtable hook list.
> 
> 5) Update the flowtable event notifier to pass a flowtable hook list.
> 
> 6) Allow users to add new devices to an existing flowtables.
> 
> 7) Allow users to remove devices to an existing flowtables.
> 
> 8) Allow for registering a flowtable with no initial devices.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thank you.
