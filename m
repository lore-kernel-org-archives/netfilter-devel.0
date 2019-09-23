Return-Path: <SRS0=FqmY=XS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A0DC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 08:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51AB320820
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 08:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfIWIrp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 04:47:45 -0400
Received: from a3.inai.de ([88.198.85.195]:42184 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731460AbfIWIro (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 04:47:44 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id E07233B7CE15; Mon, 23 Sep 2019 10:47:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id DCC423B96F87;
        Mon, 23 Sep 2019 10:47:40 +0200 (CEST)
Date:   Mon, 23 Sep 2019 10:47:40 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise
 source.
In-Reply-To: <20190922070924.uzfjofvga3nufulb@salvia>
Message-ID: <nycvar.YFH.7.76.1909231041310.14433@n3.vanv.qr>
References: <20190921122100.3740-1-jeremy@azazel.net> <20190921122100.3740-2-jeremy@azazel.net> <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr> <20190922070924.uzfjofvga3nufulb@salvia>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Sunday 2019-09-22 09:09, Pablo Neira Ayuso wrote:

>> > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
>> 
>> That seems like a recipe to end up with stale code. For a distribution,
>> it's static linking worsened by another degree.
>> 
>> (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)
>
>I thought this is like mini-gmp.c? Are distributors packaging this as
>a library?

Yes; No.

After an update to a static library, a distro would have to rebuild
dependent packages and then distribute that. Doable, but cumbersome.

But bundled code evades even that. If there is a problem, all instances
of the "static library" would need updating. Doable, but even more cumbersome.

Basically the question is: how is NF going to guarantee that linenoise (or
mini-gmp for that matter) are always up to date?
