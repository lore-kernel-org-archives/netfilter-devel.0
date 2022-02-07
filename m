Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCBEC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 10:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiBGKvw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 05:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352364AbiBGKoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 05:44:55 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8354DC043181
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 02:44:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nH1Vs-0005oy-FI; Mon, 07 Feb 2022 11:44:52 +0100
Date:   Mon, 7 Feb 2022 11:44:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <20220207104452.GA25000@breakpoint.cc>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120120458.GF31905@breakpoint.cc>
 <YgBmr3+IqGXQ4M6E@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgBmr3+IqGXQ4M6E@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> There is no pkt_buff layout freeze. If we want to change it in future, we bump
> the major version of libnetfilter_queue.so, same as we would do if changing the
> signature of an existing function.

ABI breakage is bad, just say no.
