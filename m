Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB73C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 602422053B
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 15:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391047AbgEYPqC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391001AbgEYPqB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 11:46:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBB8C061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 08:46:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jdFIV-0005z4-9O; Mon, 25 May 2020 17:45:51 +0200
Date:   Mon, 25 May 2020 17:45:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/2] Fix evaluation of anonymous sets with
 concatenated ranges
Message-ID: <20200525154551.GS17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <cover.1590324033.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1590324033.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Sun, May 24, 2020 at 03:00:25PM +0200, Stefano Brivio wrote:
> As reported by both Pablo and Phil, trying to add an anonymous set
> containing a concatenated range would fail:

Thanks for getting back at this. You may consider enabling the
corresponding line in tests/py/inet/sets.t (leading dashes disable a
test in that suite).

Cheers, Phil
