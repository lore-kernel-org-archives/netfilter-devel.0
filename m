Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DB4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 18:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbhLASXn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:23:43 -0500
Received: from mail.netfilter.org ([217.70.188.207]:54682 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbhLASXl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 13:23:41 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E461A605C1;
        Wed,  1 Dec 2021 19:18:01 +0100 (CET)
Date:   Wed, 1 Dec 2021 19:20:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Reduce cache overhead a bit
Message-ID: <Yae83tNU44re/UQU@salvia>
References: <20211201150258.18436-1-phil@nwl.cc>
 <YaenaMa1rcu5BX4U@salvia>
 <20211201171857.GI29413@orbyte.nwl.cc>
 <20211201180256.GL29413@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211201180256.GL29413@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 01, 2021 at 07:02:56PM +0100, Phil Sutter wrote:
> Quick follow-up:
> 
> On Wed, Dec 01, 2021 at 06:18:57PM +0100, Phil Sutter wrote:
> > If ENOENT wasn't reported as EINVAL, We could even fall back to plain
> > NLM_F_DUMP on older kernels. Maybe tackle that first and build upon
> > that?
> 
> Not sure what I was seeing, but I checked again and ENOENT is indeed
> returned as it should. I'll look into the fall back idea then.

Is the fallback really needed? As I said, if -stable kernel works with
this approach, I think it should be fine.
