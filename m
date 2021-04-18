Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5DAC433B4
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 18:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D48610FC
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 18:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhDRSu3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Apr 2021 14:50:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34784 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRSu2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Apr 2021 14:50:28 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8616D63E82;
        Sun, 18 Apr 2021 20:49:29 +0200 (CEST)
Date:   Sun, 18 Apr 2021 20:49:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, dsahern@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, msoltyspl@yandex.pl,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH nf-next v2 0/2] netfilter: Dissect flow after packet
 mangling
Message-ID: <20210418184956.GA19290@salvia>
References: <20210414082033.1568363-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210414082033.1568363-1-idosch@idosch.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 14, 2021 at 11:20:31AM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes a day-one bug in the interaction between netfilter and
> sport/dport/ipproto FIB rule keys.
> 
> Patch #2 adds a corresponding test case.
> 
> Targeting at nf-next since this use case never worked.

Series applied, thanks Ido.
