Return-Path: <SRS0=o7qJ=6G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33112C5518A
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 19:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 182D62071E
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 19:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDVTsk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Apr 2020 15:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725779AbgDVTsk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Apr 2020 15:48:40 -0400
X-Greylist: delayed 89868 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 12:48:40 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83294C03C1A9;
        Wed, 22 Apr 2020 12:48:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24496120ED563;
        Wed, 22 Apr 2020 12:48:38 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:48:37 -0700 (PDT)
Message-Id: <20200422.124837.1955674853738164431.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     paulb@mellanox.com, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: act_ct: update nf_conn_acct for
 act_ct SW offload in flowtable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
References: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:48:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu@ucloud.cn
Date: Tue, 21 Apr 2020 07:55:43 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> When the act_ct SW offload in flowtable, The counter of the conntrack
> entry will never update. So update the nf_conn_acct conuter in act_ct
> flowtable software offload.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied to net-next, thanks.
