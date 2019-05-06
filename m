Return-Path: <SRS0=PEYv=TG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB14C04AAE
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 04:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1A22082F
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 04:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfEFEfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 May 2019 00:35:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59640 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFEfj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 May 2019 00:35:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D98A12D6BE80;
        Sun,  5 May 2019 21:35:39 -0700 (PDT)
Date:   Sun, 05 May 2019 21:35:35 -0700 (PDT)
Message-Id: <20190505.213535.1219473423282339940.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/12] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:35:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon,  6 May 2019 01:32:53 +0200

> The following batch contains Netfilter updates for net-next, they are:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
