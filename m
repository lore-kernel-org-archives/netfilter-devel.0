Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C37C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjJXKYP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbjJXKYO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:24:14 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE74BA
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:24:11 -0700 (PDT)
Received: from [78.30.35.151] (port=44116 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvEZz-005uGi-JF; Tue, 24 Oct 2023 12:24:09 +0200
Date:   Tue, 24 Oct 2023 12:24:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
Message-ID: <ZTebRvOP2pEoHsV+@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
 <ZTeVIzWLhSWn4wsA@calendula>
 <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 12:15:22PM +0200, Thomas Haller wrote:
> On Tue, 2023-10-24 at 11:57 +0200, Pablo Neira Ayuso wrote:
> > Series aplied, thanks.
> 
> Thank you.
> 
> > 
> > After all these updates I see this failure:
> > 
> > W: [FAILED]     1/1 testcases/sets/elem_opts_compat_0
> > 
> > I: results: [OK] 0 [SKIPPED] 0 [FAILED] 1 [TOTAL] 1
> > 
> > when running tests.
> > 
> 
> Hm. I don't get such failure (Kernel 6.5.6-200.fc38.x86_64).
> But regardless of that, I don't think that my patches had anything to
> do with that test, do they?
> 
> 
> Can you provide more information? Can you bisect the failure?
> 
> Could you share:
> 
>   make && ./tests/shell/run-tests.sh ./tests/shell/testcases/sets/elem_opts_compat_0 -x -k
>   grep -R ^ /tmp/nft-test.latest.*/

/tmp/nft-test.latest.root/times:2.3
/tmp/nft-test.latest.root/times:3067.20
/tmp/nft-test.latest.root/times:3069.50
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/times:0.12
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/times:3069.38
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/times:3069.50
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:table ip t {
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:       set s {
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:               type inet_service
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:               counter
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:               timeout 30s
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:       }
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/ruleset-after:}
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/rc-failed:2
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/name:testcases/sets/elem_opts_compat_0
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/testout.log:Command: testcases/sets/elem_opts_compat_0 
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/testout.log:testcases/sets/elem_opts_compat_0: 20: Syntax error: redirection unexpected
/tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/rc-failed-exit:2
