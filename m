Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5539C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2E7206C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgESTlw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 15:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTlw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 15:41:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3DAC08C5C0;
        Tue, 19 May 2020 12:41:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 848BE128B385B;
        Tue, 19 May 2020 12:41:51 -0700 (PDT)
Date:   Tue, 19 May 2020 12:41:50 -0700 (PDT)
Message-Id: <20200519.124150.829166555278246861.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     ecree@solarflare.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519171923.GA16785@salvia>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
        <20200519171923.GA16785@salvia>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:41:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 19 May 2020 19:19:23 +0200

> This is breaking netfilter again.

This is vague and not useful feedback.

Please be specific about how the change breaks netfilter.

What breaks exactly, and how?

