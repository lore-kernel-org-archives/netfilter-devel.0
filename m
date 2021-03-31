Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D107C433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 09:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7776619DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhCaJN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhCaJNg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 05:13:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6603C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 02:13:35 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lRWup-0008Gs-As; Wed, 31 Mar 2021 11:13:31 +0200
Date:   Wed, 31 Mar 2021 11:13:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: iptables-nft fails to restore huge rulesets
Message-ID: <20210331091331.GE7863@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm currently trying to fix for an issue in Kubernetes realm[1]:
Baseline is they are trying to restore a ruleset with ~700k lines and it
fails. Needless to say, legacy iptables handles it just fine.

Meanwhile I found out there's a limit of 1024 iovecs when submitting the
batch to kernel, and this is what they're hitting.

I can work around that limit by increasing each iovec (via
BATCH_PAGE_SIZE) but keeping pace with legacy seems ridiculous:

With a scripted binary-search I checked the maximum working number of
restore items of:

(1) User-defined chains
(2) rules with merely comment match present
(3) rules matching on saddr, daddr, iniface and outiface

Here's legacy compared to nft with different factors in BATCH_PAGE_SIZE:

legacy		32 (stock)	  64		   128          256
----------------------------------------------------------------------
1'636'799	1'602'202	- NC -		  - NC -       - NC -
1'220'159	  302'079	604'160		1'208'320      - NC -
3'532'040	  242'688	485'376		  971'776    1'944'576

At this point I stopped as the VM's 20GB RAM became the limit
(iptables-nft-restore being OOM-killed instead of just failing).

What would you suggest? Should I just change BATCH_PAGE_SIZE to make it
"large enough" or is there a better approach?

Cheers, Phil

[1] https://github.com/kubernetes/kubernetes/issues/96018
