Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037DCC7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Apr 2023 11:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDLLGK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDLLGK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 07:06:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3D6A6A6F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:06:06 -0700 (PDT)
Date:   Wed, 12 Apr 2023 13:06:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZDaQmlLBAnopcqdO@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
 <20230411122140.GA1279805@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411122140.GA1279805@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 11, 2023 at 01:21:40PM +0100, Jeremy Sowden wrote:
> On 2023-03-26, at 22:39:42 +0200, Pablo Neira Ayuso wrote:
> > Jeremy, may I suggest you pick up on the bitwise _SREG2 support?  I
> > will post a v4 with small updates for ("mark statement support for
> > non-constant expression") tomorrow. Probably you don't need the new
> > AND and OR operations for this? Only the a new _SREG2 to specify that
> > input comes from non-constant?
> 
> Just to clarify, do you want just the `_SREG2` infrastructure from the
> last patch series but without the new bitwise ops?  That is to say it
> would be possible to send two operands to the kernel in registers, but
> no use would be made of it (yet).  Or are you proposing to update the
> existing mask-and-xor ops to send right hand operands via registers?

I mean, would it be possible to add a NFT_BITWISE_BOOL variant that
takes _SREG2 via select_ops?
