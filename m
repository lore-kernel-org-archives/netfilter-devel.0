Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE0FC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 11:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJFLVW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 07:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiJFLVV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 07:21:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3603B33844
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2022 04:21:20 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ogOwH-0007vz-VX; Thu, 06 Oct 2022 13:21:18 +0200
Date:   Thu, 6 Oct 2022 13:21:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 01/12] tests: iptables-test: Implement fast test
 mode
Message-ID: <Yz66LQHVQwAe8WXF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20221006002802.4917-1-phil@nwl.cc>
 <20221006002802.4917-2-phil@nwl.cc>
 <5n9rnr39-q0q-oqsq-o0s3-n8n1s6o1rqsn@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5n9rnr39-q0q-oqsq-o0s3-n8n1s6o1rqsn@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 06, 2022 at 08:13:44AM +0200, Jan Engelhardt wrote:
> On Thursday 2022-10-06 02:27, Phil Sutter wrote:
> 
> >+def run_test_file_fast(filename, netns):
> >...
> >+    elif "libarpt_" in filename:
> >+        # only supported with nf_tables backend
> >+        if EXECUTABLE != "xtables-nft-multi":
> >+           return 0
> 
> Should this particular check for executable be part of fast_run_possible
> instead? (Or somewhere else completely - if not running under x-n-m,
> even slow mode is not possible ;)

Ah, you caught me c'n'p programming. ;)
I'll move the run_test_file_fast() call to after the same code in
run_test_file() and pass 'iptables' variable as parameter. The -save and
-restore commands may be constructed by simply appending the suffix.

Thanks, Phil
