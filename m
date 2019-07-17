Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F83AC76195
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 22:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9DB20651
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 22:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfGQWQ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 18:16:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfGQWQ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 18:16:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4551414EB9022;
        Wed, 17 Jul 2019 15:16:28 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:16:25 -0700 (PDT)
Message-Id: <20190717.151625.1987585161672863516.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, jakub.kicinski@netronome.com
Subject: Re: [PATCH net,v3 1/4] net: openvswitch: rename flow_stats to
 sw_flow_stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717194248.2522-1-pablo@netfilter.org>
References: <20190717194248.2522-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:16:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


What is this series doing?

Where is your "0/4" cover letter which would tell us this?

Also:

> OVS compilation breaks here after this patchset since flow_stats
> structure is already defined in include/net/flow_offload.h. This patch
> is new in this batch.

You need to explain in more detail and in more context what this
means.  Does the build break when this patch is applies?  If so, why
is that OK?

I'm tossing this series until you submit it properly.
