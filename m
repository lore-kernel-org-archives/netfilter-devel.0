Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD62C4727E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 14:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A33D20709
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 14:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgI3OSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgI3OSb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 10:18:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A43C061755
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 07:18:31 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kNcw9-0000yq-1E; Wed, 30 Sep 2020 16:18:29 +0200
Date:   Wed, 30 Sep 2020 16:18:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables-nft-restore issue
Message-ID: <20200930141829.GD19674@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <198c69b7-d7b2-f910-c469-199bfe2fda28@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <198c69b7-d7b2-f910-c469-199bfe2fda28@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Wed, Sep 30, 2020 at 11:58:52AM +0200, Arturo Borrero Gonzalez wrote:
> I discovered my openstack neutron linuxbridge-agent malfunctioning when using
> iptables-nft and it seems this ruleset is causing the issue:

The problem is the '-' policy in builtin chains. Maybe I broke that a
while ago. I tried to come up with a fix, but it seems
iptables-legacy-restore is a bit quirky: it leaves the chain's policy
untouched, although --noflush was not given. Implementing this is a bit
problematic with how iptables-nft does the caching.

Cheers, Phil
