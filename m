Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E2DC2D0C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 22:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C21D20658
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 22:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfL3W3t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 17:29:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfL3W3t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 17:29:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE9CC14A635F1;
        Mon, 30 Dec 2019 14:29:48 -0800 (PST)
Date:   Mon, 30 Dec 2019 14:29:46 -0800 (PST)
Message-Id: <20191230.142946.1156115100060876162.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 14:29:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 30 Dec 2019 12:21:26 +0100

> The following patchset contains Netfilter updates for net-next:
 ...
> This batch, among other things, contains updates for the netfilter
> tunnel netlink interface: This extension is still incomplete and lacking
> proper userspace support which is actually my fault, I did not find the
> time to go back and finish this. This update is breaking tunnel UAPI in
> some aspects to fix it but do it better sooner than never.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
