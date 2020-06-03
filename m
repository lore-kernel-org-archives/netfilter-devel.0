Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136BDC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 15:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01C920663
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 15:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFCPfg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 11:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgFCPfg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 11:35:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4FEC08C5C0
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 08:35:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jgVQR-0002xY-4E; Wed, 03 Jun 2020 17:35:31 +0200
Date:   Wed, 3 Jun 2020 17:35:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Don't account for expired elements on
 insertion
Message-ID: <20200603153531.GS31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Jun 03, 2020 at 01:50:11AM +0200, Stefano Brivio wrote:
> While checking the validity of insertion in __nft_rbtree_insert(),
> we currently ignore conflicting elements and intervals only if they
> are not active within the next generation.

Yes, it seems I missed insert path entirely when adding
nft_set_elem_expired() checks. Assuming that it is fine that expired
elements block insertions until gc-interval has passed, I missed the
chance for one end of an interval to be accepted while the other is not.

Thanks for clearing up my mess!

[...]

> Reported-by: Mike Dillinger <miked@softtalker.com>
> Cc: <stable@vger.kernel.org> # 5.6.x
> Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>

Cheers, Phil
