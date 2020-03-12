Return-Path: <SRS0=u4Sz=45=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A848C4CECE
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 22:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB11206CD
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 22:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCLWox (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:44:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLWow (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Mar 2020 18:44:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D92C15842391;
        Thu, 12 Mar 2020 15:44:51 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:44:51 -0700 (PDT)
Message-Id: <20200312.154451.1866184120850044341.davem@davemloft.net>
To:     joe@perches.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/3] net: [IPv4/IPv6]: Use fallthrough;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5206a625c967dfbbe305d17948692c74d8f8da7d.1584040050.git.joe@perches.com>
References: <cover.1584040050.git.joe@perches.com>
        <5206a625c967dfbbe305d17948692c74d8f8da7d.1584040050.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:44:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


The appropriate subject prefix here would be simply "inet: " or similar.

Please resubmit this with a proper Subject line.

Thank you.
