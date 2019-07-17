Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8962C7618F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 20:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D1C20880
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 20:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfGQULf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 16:11:35 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56054 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfGQULf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 16:11:35 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hnqGy-0004iG-D9; Wed, 17 Jul 2019 22:11:32 +0200
Date:   Wed, 17 Jul 2019 22:11:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH RFC] net: nf_tables: Support auto-loading inet family
 nat chain
Message-ID: <20190717201132.GI31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20190717171743.14754-1-phil@nwl.cc>
 <20190717183515.yym6aageq3d3imlu@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717183515.yym6aageq3d3imlu@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Jul 17, 2019 at 08:35:15PM +0200, Pablo Neira Ayuso wrote:
[...]
> Please, use (2, "nat") instead like in other extensions.
> 
>         MODULE_ALIAS_NFT_CHAIN(2, "nat");        /* NFPROTO_INET */

I sent a non-RFC patch which uses fixed value 1. Thanks for the
suggestion!

> Yes, it's not nice, but this is so far what we have.
> 
> I agree we should fix this, problem is that NFPROTO_* are enum, and
> IIRC this doesn't mix well with the existing macros.

Ah, right. The __stringify() thing bites us then. In order to use
NFPROTO_* names, those would have to be redefined as macro. And not just
like netinet/in.h does for IPPROTO_* names but with actual value.

Cheers, Phil
