Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54388C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F2E60E08
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhIUB5P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:57:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39594 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbhIUBs5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 21:48:57 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5C8E963EA9;
        Tue, 21 Sep 2021 03:46:02 +0200 (CEST)
Date:   Tue, 21 Sep 2021 03:47:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/5] netfilter: conntrack: make zone id part of
 conntrack hash
Message-ID: <YUk5o8UCz7rdmhdH@salvia>
References: <20210908122839.7526-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210908122839.7526-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 08, 2021 at 02:28:33PM +0200, Florian Westphal wrote:
> This patch set makes the zone id part of the conntrack hash again.
> 
> First patch is a followup to
> d7e7747ac5c2496c9,
> "netfilter: refuse insertion if chain has grown too large".
> 
> Instead of a fixed-size limit, allow for some slack in the drop
> limit.  This makes it harder to extract information about hash
> table collisions/bucket overflows.
> 
> Second patch makes the zone id part of the tuple hash again.
> This was removed six years ago to allow split-zone support.
> 
> Last two patches add test cases for zone support with colliding
> tuples. First test case emulates split zones, where NAT is responsible
> to expose the overlapping networks and provide unique source ports via
> nat port translation.
> 
> Second test case exercises overlapping tuples in distinct zones.
> 
> Expectation is that all connection succeed (first self test) and
> that all insertions work (second self test).

Series applied, thanks.
