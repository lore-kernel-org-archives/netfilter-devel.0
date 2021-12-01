Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B49C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 18:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhLASGU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244320AbhLASGT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 13:06:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2178EC061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 10:02:58 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1msTwW-00080f-Bm; Wed, 01 Dec 2021 19:02:56 +0100
Date:   Wed, 1 Dec 2021 19:02:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Reduce cache overhead a bit
Message-ID: <20211201180256.GL29413@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211201150258.18436-1-phil@nwl.cc>
 <YaenaMa1rcu5BX4U@salvia>
 <20211201171857.GI29413@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201171857.GI29413@orbyte.nwl.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Quick follow-up:

On Wed, Dec 01, 2021 at 06:18:57PM +0100, Phil Sutter wrote:
> If ENOENT wasn't reported as EINVAL, We could even fall back to plain
> NLM_F_DUMP on older kernels. Maybe tackle that first and build upon
> that?

Not sure what I was seeing, but I checked again and ENOENT is indeed
returned as it should. I'll look into the fall back idea then.

Sorry for the confusion,

Phil
