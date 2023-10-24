Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33360C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjJXK3P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjJXK3O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:29:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6D4DE
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:29:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qvEel-0007Zv-SD; Tue, 24 Oct 2023 12:29:03 +0200
Date:   Tue, 24 Oct 2023 12:29:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] tests/shell: add
 "bogons/nft-f/zero_length_devicename2_assert"
Message-ID: <20231024102903.GC2255@breakpoint.cc>
References: <20231023170058.919275-1-thaller@redhat.com>
 <ZTeVIzWLhSWn4wsA@calendula>
 <24637db2fe827e321ea152b5b24cfa3a29d3660d.camel@redhat.com>
 <ZTebRvOP2pEoHsV+@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTebRvOP2pEoHsV+@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> /tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/testout.log:testcases/sets/elem_opts_compat_0: 20: Syntax error: redirection unexpected
> /tmp/nft-test.latest.root/test-testcases-sets-elem_opts_compat_0.1/rc-failed-exit:2

The test case is broken, it uses /bin/sh but needs /bin/bash.
