Return-Path: <SRS0=F0cc=5M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC86C2D0EC
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 03:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 972EF20787
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 03:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgC0DKv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 23:10:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgC0DKu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 23:10:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C98EA15CE75F1;
        Thu, 26 Mar 2020 20:10:49 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:10:48 -0700 (PDT)
Message-Id: <20200326.201048.137227897330235782.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     ozsh@mellanox.com, pablo@netfilter.org, majd@mellanox.com,
        roid@mellanox.com, netdev@vger.kernel.org, saeedm@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] netfilter: flowtable: Support offload of
 tuples in parallel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
References: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:10:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Tue, 24 Mar 2020 15:17:18 +0200

> The following patchset opens support for offloading tuples in parallel.
> 
> Patches for netfilter replace the flow table block lock with rw sem,
> and use a work entry per offload command, so they can be run in
> parallel under rw sem read lock.
> 
> MLX5 patch removes the unguarded ct entries list, and instead uses
> rhashtable's iterator to support the above.

This doesn't apply cleanly, please respin.

Thank you.
