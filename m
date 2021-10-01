Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1F4C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B0D61267
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhJANXT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhJANXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:23:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D7FC061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:21:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mWITg-0000fJ-Oq; Fri, 01 Oct 2021 15:21:28 +0200
Date:   Fri, 1 Oct 2021 15:21:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, eric@garver.life, phil@nwl.cc,
        kadlec@netfilter.org
Subject: Re: [PATCH RFC 2/2] netfilter: nf_nat: don't allow source ports that
 shadow local port
Message-ID: <20211001132128.GG2935@breakpoint.cc>
References: <20210923131243.24071-1-fw@strlen.de>
 <20210923131243.24071-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923131243.24071-3-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> PoC, incomplete -- ipv4 udp only.
> 
> Ipv6 support needs help from ipv6 indirection infra.
> 
> Also lacks direction support: the check should only be done
> for nf_conn objects created by externally generated packets.
 
Alternate fix idea:

1. store skb->skb_iif in nf_conn.

This means locally vs. remote-generated nf_conn can be identified
via ct->skb_iff != 0.

2. For "remote" case, force following behaviour:
   check that sport > dport and sport > 1024.

OTOH, this isn't transparent to users and might cause issues
with very very old "credential passing" applications that insist
on using privileged port range (< 1024) :-/
