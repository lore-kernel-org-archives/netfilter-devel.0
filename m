Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B565C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 21:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjKCVek (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 17:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjKCVej (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 17:34:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6E2D63
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 14:34:35 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qz1M5-0003ah-Mn; Fri, 03 Nov 2023 22:05:25 +0100
Date:   Fri, 3 Nov 2023 22:05:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 2/4] nft-arp: add missing mask support
Message-ID: <ZUVglaiD3ZXuK3XM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-3-fw@strlen.de>
 <ZUVcznVHvRjyooEm@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUVcznVHvRjyooEm@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 09:49:18PM +0100, Phil Sutter wrote:
> On Fri, Nov 03, 2023 at 11:23:24AM +0100, Florian Westphal wrote:
> > arptables-legacy supports masks for --h-type, --opcode
> > and --proto-type, but arptables-nft did not.
> > 
> > Add this.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> This does not apply without patch 1. Could you please rebase?

A test would be good, too. Something like:

| --h-length=6/0xffff --opcode=1/255 --h-type=1/0x00ff --proto-type=0x800/0xff00;--h-length=6/65535 --opcode=1/255 --h-type=1/255 --proto-type=0x800/0xff00=;OK

appended to extensions/libarpt_standard.t?

I notice that number bases expected on input and used on output don't
match, this could be a problem in 'arptables-save | arptables-restore'.

Cheers, Phil
