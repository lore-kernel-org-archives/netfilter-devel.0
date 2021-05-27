Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564A6C4707F
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B43A61181
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhE0SU6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 14:20:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38250 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhE0SU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 14:20:58 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9825564502;
        Thu, 27 May 2021 20:18:21 +0200 (CEST)
Date:   Thu, 27 May 2021 20:19:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: x_tables: improve limit_mt
 scalability
Message-ID: <20210527181921.GA9343@salvia>
References: <1619713573-32073-1-git-send-email-jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1619713573-32073-1-git-send-email-jbaron@akamai.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 29, 2021 at 12:26:13PM -0400, Jason Baron wrote:
> We've seen this spin_lock show up high in profiles. Let's introduce a
> lockless version. I've tested this using pktgen_sample01_simple.sh.

Applied, thanks.
