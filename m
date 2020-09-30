Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8B1C4727F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33212075F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgI3L71 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 07:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgI3L71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 07:59:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A2DC061755
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 04:59:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kNalW-0005AU-Ug; Wed, 30 Sep 2020 13:59:22 +0200
Date:   Wed, 30 Sep 2020 13:59:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables-nft-restore issue
Message-ID: <20200930115922.GC20140@breakpoint.cc>
References: <198c69b7-d7b2-f910-c469-199bfe2fda28@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <198c69b7-d7b2-f910-c469-199bfe2fda28@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> Hi Phil,
> 
> (CC'ing netfilter-devel)
> 
> I discovered my openstack neutron linuxbridge-agent malfunctioning when using
> iptables-nft and it seems this ruleset is causing the issue:
 
> === 8< ===
> *raw
> :OUTPUT - [0:0]
> :PREROUTING - [0:0]
> :neutron-linuxbri-OUTPUT - [0:0]
> :neutron-linuxbri-PREROUTING - [0:0]
> -I OUTPUT 1 -j neutron-linuxbri-OUTPUT
> -I PREROUTING 1 -j neutron-linuxbri-PREROUTING
> -I neutron-linuxbri-PREROUTING 1 -m physdev --physdev-in brq7425e328-56 -m
> comment --comment "Set zone for f101a28-1d" -j CT --zone 4097
> -I neutron-linuxbri-PREROUTING 2 -i brq7425e328-56 -m comment --comment "Set
> zone for f101a28-1d" -j CT --zone 4097
> -I neutron-linuxbri-PREROUTING 3 -m physdev --physdev-in tap7f101a28-1d -m
> comment --comment "Set zone for f101a28-1d" -j CT --zone 4097
> 
> COMMIT

git bisect start
# good: [bba6bc692b0e6137e13881a1f398c134822e9f83] configure: bump
# versions for 1.8.2 release
git bisect good bba6bc692b0e6137e13881a1f398c134822e9f83
# bad: [72ed608bf1ea550ac13b5b880afc7ad3ffa0afd0] nft: Fix for broken
# address mask match detection
git bisect bad 72ed608bf1ea550ac13b5b880afc7ad3ffa0afd0
# good: [4e9782cae29034c4eefd31703ba77aee7eca2233] nft: Pass nft_handle
# to flush_cache()
git bisect good 4e9782cae29034c4eefd31703ba77aee7eca2233
# good: [f56d91bd80f0e86aaad56a32ddc84f373bb80745] connlabel: Allow
# numeric labels even if connlabel.conf exists
git bisect good f56d91bd80f0e86aaad56a32ddc84f373bb80745
# bad: [869e38fcdecda3de35d999b75fbaacc750fe3aaa] ebtables: Free
# statically loaded extensions again
git bisect bad 869e38fcdecda3de35d999b75fbaacc750fe3aaa
# good: [72470c66326d9b5186dd4614bc2d18269324e54b] nft: cache: Eliminate
# init_chain_cache()
git bisect good 72470c66326d9b5186dd4614bc2d18269324e54b
# bad: [6d1d5aa5c93eca890e28b508ef426b7844caf2b7] nft: cache: Introduce
# struct nft_cache_req
git bisect bad 6d1d5aa5c93eca890e28b508ef426b7844caf2b7
# bad: [9d07514ac5c7a27ec72df5a81bf067073d63bd99] nft: calculate cache
# requirements from list of commands
git bisect bad 9d07514ac5c7a27ec72df5a81bf067073d63bd99
# good: [accaecdf5889911e6a1ca4737c6f6599a77afe24] nft: cache: Fetch
# sets per table
git bisect good accaecdf5889911e6a1ca4737c6f6599a77afe24
# bad: [a7f1e208cdf9c6392c99d3c52764701d004bdde7] nft: split parsing
# from netlink commands
git bisect bad a7f1e208cdf9c6392c99d3c52764701d004bdde7
# good: [70a3c1a07585de64b5780a415dc157079c34911b] ebtables-restore:
# Table line to trigger implicit commit
git bisect good 70a3c1a07585de64b5780a415dc157079c34911b
# first bad commit: [a7f1e208cdf9c6392c99d3c52764701d004bdde7] nft:
# split parsing from netlink commands

Can't look at it further ATM, I double-checked that the commit
preceeding
a7f1e208cdf9c6392c99d3c52764701d004bdde7 works.
