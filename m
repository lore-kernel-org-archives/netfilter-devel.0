Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AABC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjJXKn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJXKn6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:43:58 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71445110
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:43:55 -0700 (PDT)
Received: from [78.30.35.151] (port=52602 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvEt1-0060Of-JT; Tue, 24 Oct 2023 12:43:53 +0200
Date:   Tue, 24 Oct 2023 12:43:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
Message-ID: <ZTef4k6ycUOY2Kx8@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
 <ZTeVIzWLhSWn4wsA@calendula>
 <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
 <ZTebRvOP2pEoHsV+@calendula>
 <20231024102903.GC2255@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024102903.GC2255@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 12:29:03PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > /tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/testout.log:testcases/sets/elem_opts_compat_0: 20: Syntax error: redirection unexpected
> > /tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/rc-failed-exit:2
> 
> The test case is broken, it uses /bin/sh but needs /bin/bash.

Nice, it works now :)

http://git.netfilter.org/nftables/commit/?id=d3e941668be1d3922832fd70788fb248fd11f6c7
