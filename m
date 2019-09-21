Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5042BC4360D
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 19:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2575621835
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 19:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfIUTT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 15:19:28 -0400
Received: from a3.inai.de ([88.198.85.195]:38524 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbfIUTT2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 15:19:28 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7F30B3B7CE15; Sat, 21 Sep 2019 21:19:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 764AE3BACCA3;
        Sat, 21 Sep 2019 21:19:23 +0200 (CEST)
Date:   Sat, 21 Sep 2019 21:19:23 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise
 source.
In-Reply-To: <20190921122100.3740-2-jeremy@azazel.net>
Message-ID: <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
References: <20190921122100.3740-1-jeremy@azazel.net> <20190921122100.3740-2-jeremy@azazel.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2019-09-21 14:20, Jeremy Sowden wrote:

>  https://github.com/antirez/linenoise/
>
>The upstream repo doesn't contain the infrastructure for building or
>installing libraries.  There was a 1.0 release made in 2015, but there
>have been a number of bug-fixes committed since.  Therefore, add the
>latest upstream source:

> src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++

That seems like a recipe to end up with stale code. For a distribution,
it's static linking worsened by another degree.

(https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries
)
