Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8A7C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 10:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiLVKwz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 05:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVKwy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 05:52:54 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0514327912
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 02:52:53 -0800 (PST)
Date:   Thu, 22 Dec 2022 11:52:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] scanner: treat invalid octal strings as strings
Message-ID: <Y6Q3AUkBrNbB2JBO@salvia>
References: <20221216202714.1413699-1-jeremy@azazel.net>
 <Y6Qzq48e+ihIf4La@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y6Qzq48e+ihIf4La@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 22, 2022 at 11:38:39AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 16, 2022 at 08:27:14PM +0000, Jeremy Sowden wrote:
[...]
> > We get:
> > 
> >   $ sudo ./src/nft -f - <<<'
> >   > table x {
> >   >   chain y {
> >   >     ip saddr 0308 continue comment "error"
> >   >   }
> >   > }
> >   > '
> >   /dev/stdin:4:14-17: Error: Could not resolve hostname: Name or service not known
> >       ip saddr 0308 continue comment "error"
> >                ^^^^
> > 
> > Add a test-case.
> 
> Applied, thanks.
> 
> I am sorry I missed this patch before the release.

Hm. I thought this patch just fixes the parsing of octals.

iptables and iproute seem to support for octals?
