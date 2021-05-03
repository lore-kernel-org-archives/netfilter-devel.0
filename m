Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F02C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF7661283
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhECU5r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 16:57:47 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40968 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhECU5r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 16:57:47 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4929063087;
        Mon,  3 May 2021 22:56:10 +0200 (CEST)
Date:   Mon, 3 May 2021 22:56:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tao Gong <gongtao0607@gmail.com>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: conntrackd inverted NAT address, endianness issue?
Message-ID: <20210503205649.GA13044@salvia>
References: <CAOAu+xL2ao_r-FK=XYFR3PORvE-E7zLOx0giRGjbB1E5cpUhrw@mail.gmail.com>
 <20210420091853.GA23774@salvia>
 <CAOAu+x+mHmTPi0Q9dND7WOaCNTBP0_VvJqTv=8eZOcthv-Lwhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOAu+x+mHmTPi0Q9dND7WOaCNTBP0_VvJqTv=8eZOcthv-Lwhg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 21, 2021 at 09:28:42AM -0700, Tao Gong wrote:
> Hi Pablo,
> 
> Thanks. Just had it tested (x64 -> mips and x64 -> x64). Failover is
> working now. Awesome!

For the record, patch is applied:

http://git.netfilter.org/conntrack-tools/commit/?id=b55717d46ae3b7c3769192a66e565bc7c2d833a1
