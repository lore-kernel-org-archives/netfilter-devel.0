Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610BDC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 17:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2CE60F5E
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 17:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhH3RyQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 13:54:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44958 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhH3RyP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 13:54:15 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 083516006F;
        Mon, 30 Aug 2021 19:52:17 +0200 (CEST)
Date:   Mon, 30 Aug 2021 19:53:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] netlink_delinearize: incorrect meta protocol
 dependency kill
Message-ID: <20210830175312.GA27429@salvia>
References: <20210826104952.4812-1-pablo@netfilter.org>
 <20210830164041.GP7616@orbyte.nwl.cc>
 <20210830172114.GA26444@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210830172114.GA26444@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 30, 2021 at 07:21:14PM +0200, Pablo Neira Ayuso wrote:
[...]
> Look: If we want to fix this right(tm), we should update
> payload_try_merge() to actually remove this redundant dependency at
> rule load time, instead of doing this lazy dependency removal at
> listing time.

Or actually, this match statement could be just canceled from the
evaluation phase for these cases:

        ip family meta protocol ip
        ip6 family meta protocol ip6
