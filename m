Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AFBC61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 17:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjKVRuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 12:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjKVRuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 12:50:15 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2019E1B5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 09:50:11 -0800 (PST)
Received: from [78.30.43.141] (port=58262 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r5rMV-00DlAF-Bg; Wed, 22 Nov 2023 18:50:09 +0100
Date:   Wed, 22 Nov 2023 18:50:06 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix sets/reset_command_0 for current
 kernels
Message-ID: <ZV4/Tu8Ga7A924+O@calendula>
References: <20231102150342.3543-1-phil@nwl.cc>
 <08a7ddd943c17548bbe4a72d6c0aae3110b0d39e.camel@redhat.com>
 <ZUPXGnrqVajvEryb@orbyte.nwl.cc>
 <ZUQHXkoa+Nr6byb/@calendula>
 <ZUoTmq8cwj+A9WO+@orbyte.nwl.cc>
 <ZV3mcc4otdRS0gL3@calendula>
 <ZV4DmmW7+oceP4jo@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZV4DmmW7+oceP4jo@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 22, 2023 at 02:35:22PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Nov 22, 2023 at 12:30:57PM +0100, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > Picking up on this because I still see:
> > 
> > W: [FAILED]     331/389 testcases/sets/reset_command_0
> > 
> > here, maybe you can merge this change now? 6.5.x -stable will also
> > enter EoL in one more.
> 
> There is a v2 of this patch adding an explicit check for expiry to not
> change upon element reset. Are you fine with that? For reference, its
> message ID is 20231102175754.15020-1-phil@nwl.cc.

If it works reliable and you are happy with it, all fine with me.
