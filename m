Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89E0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 06:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJFGNt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 02:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJFGNs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 02:13:48 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB5D62921
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 23:13:46 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 6812E586B5F69; Thu,  6 Oct 2022 08:13:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 6513160C4DF89;
        Thu,  6 Oct 2022 08:13:44 +0200 (CEST)
Date:   Thu, 6 Oct 2022 08:13:44 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 01/12] tests: iptables-test: Implement fast test
 mode
In-Reply-To: <20221006002802.4917-2-phil@nwl.cc>
Message-ID: <5n9rnr39-q0q-oqsq-o0s3-n8n1s6o1rqsn@vanv.qr>
References: <20221006002802.4917-1-phil@nwl.cc> <20221006002802.4917-2-phil@nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2022-10-06 02:27, Phil Sutter wrote:

>+def run_test_file_fast(filename, netns):
>...
>+    elif "libarpt_" in filename:
>+        # only supported with nf_tables backend
>+        if EXECUTABLE != "xtables-nft-multi":
>+           return 0

Should this particular check for executable be part of fast_run_possible
instead? (Or somewhere else completely - if not running under x-n-m,
even slow mode is not possible ;)
