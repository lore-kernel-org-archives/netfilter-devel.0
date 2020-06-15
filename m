Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7740C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 09:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D6C2065F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 09:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgFOJAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 05:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbgFOJAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 05:00:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BE7C061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 02:00:49 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jkkyy-0004rU-Jm; Mon, 15 Jun 2020 11:00:44 +0200
Date:   Mon, 15 Jun 2020 11:00:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Message-ID: <20200615090044.GH23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Sun, Jun 14, 2020 at 11:41:49PM +0200, Stefano Brivio wrote:
> Commit 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")
> introduced the definition of DIFF at the top of run-tests.sh, to make
> it visually part of the configuration section. Commit 68310ba0f9c2
> ("tests: shell: Search diff tool once and for all") override this
> definition.
> 
> Drop the unexpected redefinition of DIFF.

I would fix it the other way round, dropping the first definition. It's
likely a missing bit from commit 68310ba0f9c20, the second definition is
in line with FIND and MODPROBE definitions immediately preceding it.

Cheers, Phil
