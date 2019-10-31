Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885F0CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 13:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662A82080F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 13:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJaNnX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 09:43:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47254 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbfJaNnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 09:43:23 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iQAjR-0004kp-52; Thu, 31 Oct 2019 14:43:21 +0100
Date:   Thu, 31 Oct 2019 14:43:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 2/2] Deprecate untyped data setters
Message-ID: <20191031134321.GC8531@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191030174948.12493-1-phil@nwl.cc>
 <20191030174948.12493-2-phil@nwl.cc>
 <20191031124920.4p2frkvfwgktaxqz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031124920.4p2frkvfwgktaxqz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 31, 2019 at 01:49:20PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 30, 2019 at 06:49:48PM +0100, Phil Sutter wrote:
> > These functions make assumptions on size of passed data pointer and
> > therefore tend to hide programming mistakes. Instead either one of the
> > type-specific setters or the generic *_set_data() setter should be used.
> 
> Please, confirm that the existing iptables / nft codebase will not hit
> compilation warnings because of deprecated functions.

Yes, current code base does not use those functions.

Cheers, Phil
