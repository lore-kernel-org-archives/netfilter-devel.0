Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FE8C4724C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14002076D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD3PlH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgD3PlH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:41:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E04C035494
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 08:41:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jUBJC-0000AT-A9; Thu, 30 Apr 2020 17:41:06 +0200
Date:   Thu, 30 Apr 2020 17:41:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] rule: memleak in __do_add_setelems()
Message-ID: <20200430154106.GO15009@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200430121845.10388-1-pablo@netfilter.org>
 <20200430130820.GA11056@salvia>
 <20200430135217.GJ15009@orbyte.nwl.cc>
 <20200430144714.GA1454@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430144714.GA1454@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 04:47:14PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 03:52:17PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Thu, Apr 30, 2020 at 03:08:20PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 30, 2020 at 02:18:45PM +0200, Pablo Neira Ayuso wrote:
> > > > This patch invokes interval_map_decompose() with named sets:
> > > > 
> > > > ==3402== 2,352 (128 direct, 2,224 indirect) bytes in 1 blocks are definitely lost in loss record 9 of 9
> > > > ==3402==    at 0x483577F: malloc (vg_replace_malloc.c:299)
> > > > ==3402==    by 0x48996A8: xmalloc (utils.c:36)
> > > > ==3402==    by 0x4899778: xzalloc (utils.c:65)
> > > > ==3402==    by 0x487CB46: expr_alloc (expression.c:45)
> > > > ==3402==    by 0x487E2A0: mapping_expr_alloc (expression.c:1140)
> > > > ==3402==    by 0x4898AA8: interval_map_decompose (segtree.c:1095)
> > > > ==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1569)
> > > > ==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1559)
> > > > ==3402==    by 0x4877936: do_command (rule.c:2710)
> > > > ==3402==    by 0x489F1CB: nft_netlink.isra.5 (libnftables.c:42)
> > > > ==3402==    by 0x489FB07: nft_run_cmd_from_filename (libnftables.c:508)
> > > > ==3402==    by 0x10A9AA: main (main.c:455)
> > > > 
> > > > Fixes: dd44081d91ce ("segtree: Fix add and delete of element in same batch")
> > > 
> > > This fixes the problem for anonymous sets, still named sets are
> > > showing a memleak.
> > 
> > The change is strange: My fix (dd44081d91ce) was about anonymous sets.
> 
> It was about named sets, right?
> 
> # nft 'add element t s { 22-25 }; delete element t s { 22-25 }'

Oh, hehe. I was staring at exactly that line and concluded it's about
anonymous sets. Maybe I should call it a day. %)

[...]
> I think I found the root cause:
> 
> https://marc.info/?l=netfilter-devel&m=158825784609307&w=2

Good catch!

Thanks, Phil
