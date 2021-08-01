Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD96C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 10:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F40610A2
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 10:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhHAKPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 06:15:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47720 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHAKPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 06:15:10 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B266B60033;
        Sun,  1 Aug 2021 12:14:27 +0200 (CEST)
Date:   Sun, 1 Aug 2021 12:14:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: ipset: Limit the maximal range of
 consecutive elements to add/delete
Message-ID: <20210801101455.GA20612@salvia>
References: <20210728150115.5107-1-kadlec@netfilter.org>
 <20210728150115.5107-2-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210728150115.5107-2-kadlec@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 28, 2021 at 05:01:15PM +0200, Jozsef Kadlecsik wrote:
> The range size of consecutive elements were not limited. Thus one could
> define a huge range which may result soft lockup errors due to the long
> execution time. Now the range size is limited to 2^20 entries.

Applied, thanks.
