Return-Path: <SRS0=n9X8=WO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD0BC3A589
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 21:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6713A21855
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 21:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfHRVNs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Aug 2019 17:13:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRVNr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 17:13:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3182145F43A7;
        Sun, 18 Aug 2019 14:13:46 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:13:46 -0700 (PDT)
Message-Id: <20190818.141346.2186153528065492905.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, jiri@resnulli.us, wenxu@ucloud.cn,
        saeedm@mellanox.com, paulb@mellanox.com, gerlitz.or@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net,v5 0/2] flow_offload hardware priority fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816012410.31844-1-pablo@netfilter.org>
References: <20190816012410.31844-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:13:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 16 Aug 2019 03:24:08 +0200

> This patchset contains two updates for the flow_offload users:
> 
> 1) Pass the major tc priority to drivers so they do not have to
>    lshift it. This is a preparation patch for the fix coming in
>    patch #2.
> 
> 2) Set the hardware priority from the netfilter basechain priority,
>    some drivers break when using the existing hardware priority
>    number that is set to zero.
> 
> v5: fix patch 2/2 to address a clang warning and to simplify
>     the priority mapping.

Series applied.
