Return-Path: <SRS0=wwvA=4S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AC8C3F2CE
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 05:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B2621556
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 05:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCAFWU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Mar 2020 00:22:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgCAFWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Mar 2020 00:22:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0D2815BD850F;
        Sat, 29 Feb 2020 21:22:19 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:22:19 -0800 (PST)
Message-Id: <20200229.212219.743116782927481253.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH net] netlink: Use netlink header as base to calculate
 bad attribute offset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226184734.1866-1-pablo@netfilter.org>
References: <20200226184734.1866-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:22:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 26 Feb 2020 19:47:34 +0100

> Userspace might send a batch that is composed of several netlink
> messages. The netlink_ack() function must use the pointer to the netlink
> header as base to calculate the bad attribute offset.
> 
> Fixes: 2d4bc93368f5 ("netlink: extended ACK reporting")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied and queued up for -stable, thanks Pablo.
