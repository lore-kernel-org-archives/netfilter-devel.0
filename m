Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0F0C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 12:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjKOMah (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 07:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjKOMag (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 07:30:36 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE589CE
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 04:30:32 -0800 (PST)
Received: from [78.30.43.141] (port=38368 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3F2G-00Bpo7-DB; Wed, 15 Nov 2023 13:30:26 +0100
Date:   Wed, 15 Nov 2023 13:30:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <ZVS530oqzSu/cgQS@calendula>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
 <ZVSgywZtf8F7nFop@calendula>
 <20231115122105.GD23742@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115122105.GD23742@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 01:21:05PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Nov 15, 2023 at 11:01:01AM +0100, Florian Westphal wrote:
> > [...]
> > > I'll double check this of course before pushing this out.
> > 
> > OK, then all has been clarified and this can follow its route to git.
> > 
> > I will follow up with my pending patches for tests/shell and older
> > kernels, with my last patch 5/4 it is done for kernel 5.4.
> 
> I"ve pushed the series out.  Note that I modified two dump files
> to account for "src: expand create commands", which did modify
> two tests in the mean time.

I see _lots_ of DUMP FAIL with kernel 5.4

I: [SKIPPED]      1/387 testcases/flowtable/0015destroy_0
W: [DUMP FAIL]    2/387 testcases/optimizations/merge_stmts_concat_vmap
I: [OK]           3/387 testcases/chains/0037policy_variable_1
I: [OK]           4/387 testcases/transactions/bad_expression
W: [DUMP FAIL]    5/387 testcases/sets/collapse_elem_0
I: [OK]           6/387 testcases/include/0009glob_nofile_1
W: [DUMP FAIL]    7/387 testcases/sets/0049set_define_0
W: [DUMP FAIL]    8/387 testcases/rule_management/0005replace_1
W: [DUMP FAIL]    9/387 testcases/flowtable/0003add_after_flush_0
W: [DUMP FAIL]   10/387 testcases/sets/0017add_after_flush_0
I: [OK]          11/387 testcases/chains/0011endless_jump_loop_1
I: [SKIPPED]     12/387 testcases/maps/0014destroy_0
I: [SKIPPED]     13/387 testcases/sets/0060set_multistmt_0
W: [DUMP FAIL]   14/387 testcases/cache/0004_cache_update_0
I: [OK]          15/387 testcases/transactions/0036set_1
W: [DUMP FAIL]   16/387 testcases/nft-f/0002rollback_rule_0
W: [DUMP FAIL]   17/387 testcases/chains/0022prio_dummy_1
W: [DUMP FAIL]   18/387 testcases/nft-f/0032pknock_0
I: [SKIPPED]     19/387 testcases/maps/0017_map_variable_0
I: [OK]          20/387 testcases/optionals/comments_objects_dup_0
I: [OK]          21/387 testcases/transactions/0014chain_1
W: [DUMP FAIL]   22/387 testcases/chains/0026prio_netdev_1
W: [DUMP FAIL]   23/387 testcases/optionals/handles_1
W: [DUMP FAIL]   24/387 testcases/include/0007glob_double_0
W: [DUMP FAIL]   25/387 testcases/transactions/0048helpers_0
W: [DUMP FAIL]   26/387 testcases/listing/0021ruleset_json_terse_0
W: [DUMP FAIL]   27/387 testcases/listing/0022terse_0
W: [DUMP FAIL]   28/387 testcases/chains/0017masquerade_jump_1
W: [DUMP FAIL]   29/387 testcases/sets/0016element_leak_0
...
