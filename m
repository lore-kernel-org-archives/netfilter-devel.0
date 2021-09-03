Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F09C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 14:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25D760555
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 14:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbhICOB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhICOB4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 10:01:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD79C061575
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 07:00:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mM9kS-0003qc-IO; Fri, 03 Sep 2021 16:00:52 +0200
Date:   Fri, 3 Sep 2021 16:00:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Benjamin Hesmans <benjamin.hesmans@tessares.net>
Cc:     netfilter-devel@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH nf] netfilter: socket: icmp6: fix use-after-scope
Message-ID: <20210903140052.GC23554@breakpoint.cc>
References: <20210903132335.25355-1-benjamin.hesmans@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903132335.25355-1-benjamin.hesmans@tessares.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Benjamin Hesmans <benjamin.hesmans@tessares.net> wrote:
> Bug reported by KASAN:
> 
> BUG: KASAN: use-after-scope in inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
> Call Trace:
> (...)
> inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
> (...)
> nf_sk_lookup_slow_v6 (net/ipv6/netfilter/nf_socket_ipv6.c:91
> net/ipv6/netfilter/nf_socket_ipv6.c:146)

Similar construct in the branch above is fine because
sport and dport are copied (rather than passing pointer to address).

Reviewed-by: Florian Westphal <fw@strlen.de>
