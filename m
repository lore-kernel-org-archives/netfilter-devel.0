Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A802CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 11:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbjJQLkk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 07:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbjJQLki (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 07:40:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52952129
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 04:40:34 -0700 (PDT)
Received: from [78.30.34.192] (port=39682 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qsiR4-0058TZ-0B; Tue, 17 Oct 2023 13:40:32 +0200
Date:   Tue, 17 Oct 2023 13:40:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 2/3] tests/shell: skip "table_onoff" test on older
 kernels
Message-ID: <ZS5yrFEVapwXier3@calendula>
References: <20231017085133.1203402-1-thaller@redhat.com>
 <20231017085133.1203402-3-thaller@redhat.com>
 <ZS5OKQycMX0cScgb@calendula>
 <fa46d54e30cc0c603d555b7446d5a5485374b49a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa46d54e30cc0c603d555b7446d5a5485374b49a.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 17, 2023 at 01:21:54PM +0200, Thomas Haller wrote:
> On Tue, 2023-10-17 at 11:04 +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 17, 2023 at 10:49:07AM +0200, Thomas Haller wrote:
> > > The "table_onoff" test can only pass with certain (recent) kernels.
> > > Conditionally exit with status 77, if "eval-exit-code" determines
> > > that
> > > we don't have a suitable kernel version.
> > > 
> > > In this case, we can find the fixes in:
> > > 
> > >  v6.6      :
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1
> > >  v6.5.6    :
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5e5754e9e77ce400d70ff3c30fea466c8dfe9a9f
> > >  v6.1.56   :
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c4b0facd5c20ceae3d07018a3417f06302fa9cd1
> > >  v5.15.135 :
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0dcc9b4097d860d9af52db5366a8755c13468d13
> > 
> > I am not sure it worth this level of tracking.
> > 
> > Soon these patches will be in upstream stable and this extra shell
> > code will be simply deadcode in little time.
> 
> I am not concerned about dead code in old tests that keep passing.
> The code was useful once, now the test passes. No need to revisit them,
> unless you see a real problem with them.
> 
> If it would be only little time, the tests should wait. But how much is
> the right time? You are not waiting for your use-case, you are holding
> back to not to break the unknown use cases of others.
> 
> IMO merging tests is good. The problem just needs a good solution.

Apologies, I don't think this kind of hints is worth.

It might be a bug that resurrects in the future and then the
suggestion that a commit is missing will be misleading.
