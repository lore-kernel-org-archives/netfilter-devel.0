Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BADC33CB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 09:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5D5F20730
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 09:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgAQJh3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 04:37:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgAQJh3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 04:37:29 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC0D61554C64B;
        Fri, 17 Jan 2020 01:37:27 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:37:24 -0800 (PST)
Message-Id: <20200117.013724.132596999996286549.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Netfilter updates for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 01:37:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 16 Jan 2020 20:50:35 +0100

> The following patchset contains Netfilter fixes for net:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
