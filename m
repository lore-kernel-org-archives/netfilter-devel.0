Return-Path: <SRS0=yGNv=5I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C76C10DCE
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 20:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C74206F9
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 20:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgCWUBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Mar 2020 16:01:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCWUBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 16:01:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B5E115AD6068;
        Mon, 23 Mar 2020 13:01:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:01:36 -0700 (PDT)
Message-Id: <20200323.130136.1140495791175015677.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, paulb@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] flow_offload: add TC_SETP_FT type in
 flow_indr_block_call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584522012-5692-1-git-send-email-wenxu@ucloud.cn>
References: <1584522012-5692-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 13:01:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu@ucloud.cn
Date: Wed, 18 Mar 2020 17:00:12 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Add TC_SETP_FT type in flow_indr_block_call for supporting indr block call
> in nf_flow_table_offload
> 
> Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

I don't understand what this patch is doing, why it is necessary, and why
it was implemented the way that it was.

You must write proper, full, commit log messages for your changes.
