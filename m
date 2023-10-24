Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC19C07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 11:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjJXLuO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 07:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjJXLuM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 07:50:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596B3D79
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 04:50:10 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qvFv7-0000IQ-Kf; Tue, 24 Oct 2023 13:50:01 +0200
Date:   Tue, 24 Oct 2023 13:50:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
Message-ID: <ZTevabsm2ubu5iOW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20231023170058.919275-1-thaller@redhat.com>
 <ZTeVIzWLhSWn4wsA@calendula>
 <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
 <ZTebRvOP2pEoHsV+@calendula>
 <20231024102903.GC2255@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Gna, I keep forgetting that here-strings are a Bashism, sorry for the
mess.

Cheers, Phil
