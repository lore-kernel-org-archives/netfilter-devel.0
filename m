Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A241C5B578
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 05:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A2B820651
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 05:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfGHFR7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 01:17:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGHFR7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 01:17:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA259152F8546;
        Sun,  7 Jul 2019 22:17:58 -0700 (PDT)
Date:   Sun, 07 Jul 2019 22:17:58 -0700 (PDT)
Message-Id: <20190707.221758.556845043888628281.davem@davemloft.net>
To:     GLin@suse.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, FVogt@suse.com
Subject: Re: [PATCH] net: bpfilter: print umh messages to /dev/kmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705035357.3995-1-glin@suse.com>
References: <20190705035357.3995-1-glin@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 22:17:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Gary Lin <GLin@suse.com>
Date: Fri, 5 Jul 2019 03:54:58 +0000

> bpfilter_umh currently printed all messages to /dev/console and this
> might interfere the user activity(*).
> 
> This commit changes the output device to /dev/kmsg so that the messages
> from bpfilter_umh won't show on the console directly.
> 
> (*) https://bugzilla.suse.com/show_bug.cgi?id=1140221
> 
> Signed-off-by: Gary Lin <glin@suse.com>

Applied.
