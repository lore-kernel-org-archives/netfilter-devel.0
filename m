Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048F7C4363A
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 14:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE93F20708
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 14:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgJHO60 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 10:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHO60 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 10:58:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC95CC061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 07:58:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQXN8-000606-Iv; Thu, 08 Oct 2020 16:58:22 +0200
Date:   Thu, 8 Oct 2020 16:58:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libiptc: Avoid gcc-10 zero-length array warning
Message-ID: <20201008145822.GA13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201008130116.25798-1-phil@nwl.cc>
 <s95qopq1-3o5o-oo9-1qso-osp024914p67@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s95qopq1-3o5o-oo9-1qso-osp024914p67@vanv.qr>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Thu, Oct 08, 2020 at 04:33:04PM +0200, Jan Engelhardt wrote:
[...]
> Anyway, gcc-10/C mode does not reject embedding (and a number of maintainers
> have made it abundantly clear in the past they don't care if UAPI uses anti-C++
> "features"). Nonreject example:
> 
> » cat x.c
> struct a2 {
>         int x;
>         int z[];
> };
> struct m {
>         struct a2 y;
>         long q;
> };
> » gcc -Wall -std=c11 -c -w -v x.c
> GNU C11 (SUSE Linux) version 10.2.1 20200825 [revision c0746a1beb1ba073c7981eb09f55b3d993b32e5c] (x86_64-suse-linux)

No need to pass '-w', gcc seems to accept the above unless one passes
'-pedantic' and thereby enables strict ISO C mode:

| % gcc -Wall -pedantic -std=c11 -c x.c   
| x.c:6:19: warning: invalid use of structure with flexible array member [-Wpedantic]
|     6 |         struct a2 y;
|       |                   ^

While the question of whether kernel UAPI headers should adhere to
strict ISO C or not may be debatable, my motivation for working around
the situation in user space comes from Gustavo's complaints when I tried
to convert the relevant struct members into flexible arrays. He
apparently is a burnt child looking at commit 1e6e9d0f4859e ("uapi:
revert flexible-array conversions").

Cheers, Phil
