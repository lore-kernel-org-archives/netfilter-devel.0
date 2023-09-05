Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927B8CA0FF3
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbjIEQ1E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354628AbjIENDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 09:03:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B21A12E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 06:03:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qdVif-0000Xy-Bs; Tue, 05 Sep 2023 15:03:49 +0200
Date:   Tue, 5 Sep 2023 15:03:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] tests: shell: let netdev_chain_0 test indicate
 SKIP if kernel requires netdev device
Message-ID: <ZPcnNa34zSMghioa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230904090640.3015-1-fw@strlen.de>
 <20230904090640.3015-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904090640.3015-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 04, 2023 at 11:06:31AM +0200, Florian Westphal wrote:
> This test case only works on kernel 6.4+.
> Add feature probe for this and then exit early.
> 
> We don't want to indicate a test failure, as this test doesn't apply
> on older kernels.
> 
> But we should not indicate sucess either, else we might be fooled
> in case something went wrong during feature probe.
> 
> Add a special return value, 123, and let run-tests.sh count this
> as 'SKIPPED'.

I suggest we adhere to Gnu automake convention:

"[...] an exit status of 0
from a test script will denote a success, an exit status of 77 a skipped
test, an exit status of 99 a hard error, and any other exit status will
denote a failure."[1]

Cheers, Phil

[1] https://www.gnu.org/software/automake/manual/html_node/Scripts_002dbased-Testsuites.html
