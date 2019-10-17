Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00D9ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 18:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D27C20872
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 18:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437997AbfJQSDO convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 14:03:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437975AbfJQSDO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 14:03:14 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26A8B13F8C90E;
        Thu, 17 Oct 2019 11:03:13 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:03:12 -0400 (EDT)
Message-Id: <20191017.140312.595649405075783834.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     pablo@netfilter.org, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at
 byte level
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4ec50937-1880-bac0-5495-c36f7e60584f@solarflare.com>
References: <20191017103059.3b7ff828@cakuba.netronome.com>
        <20191017174603.m3riooywbgy2r5hr@salvia>
        <4ec50937-1880-bac0-5495-c36f7e60584f@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 11:03:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Thu, 17 Oct 2019 19:01:36 +0100

> On 17/10/2019 18:46, Pablo Neira Ayuso wrote:
>> Making this opt-in will just leave things as bad as they are right
>> now, with drivers that are very much hard to read.
> Again, there are two driver developers in this conversation, and they
>  both disagree with you.  Reflect on that fact.

+1
