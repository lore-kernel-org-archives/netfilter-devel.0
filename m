Return-Path: <SRS0=t5ds=XV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C31C432C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 08:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5428222C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 08:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfIZI3u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Sep 2019 04:29:50 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47046 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbfIZI3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Sep 2019 04:29:50 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iDP9o-0003XO-KA; Thu, 26 Sep 2019 10:29:48 +0200
Date:   Thu, 26 Sep 2019 10:29:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 03/14] nft: Keep nft_handle pointer in nft_xt_ctx
Message-ID: <20190926082948.GG22129@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-4-phil@nwl.cc>
 <20190824164107.qrccw4nwp62acdcr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824164107.qrccw4nwp62acdcr@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sat, Aug 24, 2019 at 06:41:07PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 21, 2019 at 11:25:51AM +0200, Phil Sutter wrote:
> > Instead of carrying the family value, carry the handle (which contains
> > the family value) and relieve expression parsers from having to call
> > nft_family_ops_lookup().
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

I broke things when reordering, this patch depends on later changes.
Hence I'll push only the first two and get the rest sorted for upcoming
v2.

Sorry, Phil
