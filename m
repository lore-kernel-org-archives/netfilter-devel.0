Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DED0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 07:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6677660FF2
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 07:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJ1HNX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 03:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhJ1HNW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 03:13:22 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044AC061570
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2021 00:10:55 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id E6E2628000F26;
        Thu, 28 Oct 2021 09:10:53 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D97BE234391; Thu, 28 Oct 2021 09:10:53 +0200 (CEST)
Date:   Thu, 28 Oct 2021 09:10:53 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support netdev egress hook
Message-ID: <20211028071053.GA20838@wunner.de>
References: <20211027101715.47905-1-pablo@netfilter.org>
 <20211027121442.GA20375@wunner.de>
 <YXlUIuoRaI8WmbZT@salvia>
 <20211027221301.GA5956@wunner.de>
 <YXnYPnrm/gUf0a/6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXnYPnrm/gUf0a/6@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[+cc Phil]

On Thu, Oct 28, 2021 at 12:52:46AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 28, 2021 at 12:13:01AM +0200, Lukas Wunner wrote:
> > When running tests I noted an oddity:
> > 
> > tests/shell/testcases/0031set_timeout_size_0 fails because
> > 1d2h3m4s10ms is reported as 1d2h3m4s8ms, so 2 msec less.
> > Might be caused by the kernel I tested against (v5.13.12),
> > doesn't seem related to my patches, but odd nevertheless.
> 
> Likely related to:
> 
> commit c9c5b5f621c37d17140dac682d211825ef321093
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Mon Jul 26 15:27:32 2021 +0200
> 
>     tests: shell: Fix bogus testsuite failure with 100Hz

Debian uses CONFIG_HZ_250=y in their x86_64 default config,
that's what I'm using.  I guess changing the regex to match
(8|10)ms would fix the issue.

Thanks,

Lukas
