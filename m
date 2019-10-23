Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD44CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CBDF2086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbfJWMQ2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:16:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56048 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfJWMQ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 08:16:28 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iNFYx-0003Tu-GY; Wed, 23 Oct 2019 14:16:27 +0200
Date:   Wed, 23 Oct 2019 14:16:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Use ARRAY_SIZE() macro in nft_strerror()
Message-ID: <20191023121627.GM26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191018155114.7423-1-phil@nwl.cc>
 <20191023112024.gd4dqe6qqv46hufe@salvia>
 <20191023112311.qrglbzhqad4vfqvo@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023112311.qrglbzhqad4vfqvo@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 23, 2019 at 01:23:11PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 23, 2019 at 01:20:24PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 18, 2019 at 05:51:14PM +0200, Phil Sutter wrote:
> > > Variable 'table' is an array of type struct table_struct, so this is a
> > > classical use-case for ARRAY_SIZE() macro.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> BTW, probably good to add the array check?
> 
> https://sourceforge.net/p/libhx/libhx/ci/master/tree/include/libHX/defs.h#l152

Copying from kernel sources, do you think that's fine?

|  #      ifndef ARRAY_SIZE
| -#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
| +#              define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
| +#              define __same_type(a, b) \
| +                       __builtin_types_compatible_p(typeof(a), typeof(b))
| +/*             &a[0] degrades to a pointer: a different type from an array */
| +#              define __must_be_array(a) \
| +                       BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
| +#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x))) + __must_be_array(x)
|  #      endif

Cheers, Phil
