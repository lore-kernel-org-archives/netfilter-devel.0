Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888FFC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D396101C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbhIFJOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 05:14:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39224 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbhIFJOO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 05:14:14 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id B5C9A6001C;
        Mon,  6 Sep 2021 11:12:03 +0200 (CEST)
Date:   Mon, 6 Sep 2021 11:13:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xiao Liang <shaw.leon@gmail.com>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] src: Check range bounds before converting to prefix
Message-ID: <20210906091304.GA2114@salvia>
References: <20210906030641.10958-1-shaw.leon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210906030641.10958-1-shaw.leon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Sep 06, 2021 at 11:06:41AM +0800, Xiao Liang wrote:
> The lower bound must be the first value of the prefix to be coverted.
> For example, range "10.0.0.15-10.0.0.240" can not be converted to
> "10.0.0.15/24". Validate it by checking if the lower bound value has
> enough trailing zeros.

# nft add rule x y ip saddr 10.0.0.15-10.0.0.240
# nft list ruleset
...
        ip saddr 10.0.0.15-10.0.0.240

Is a different range that triggers the problem?
