Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFE8EB64D8
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 14:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjFUOmE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjFUOmC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 10:42:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB0C31BD2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 07:41:55 -0700 (PDT)
Date:   Wed, 21 Jun 2023 16:41:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: avoid IPPROTO_MAX for array definitions
Message-ID: <ZJMMLq8MAw6VLq4N@calendula>
References: <20230620200836.22041-1-fw@strlen.de>
 <ZJIpBfHFHYj6PWfx@calendula>
 <20230621111815.GC24035@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230621111815.GC24035@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 01:18:15PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Jun 20, 2023 at 10:08:36PM +0200, Florian Westphal wrote:
> > > ip header can only accomodate 8but value, but IPPROTO_MAX has been bumped
> > > due to uapi reasons to support MPTCP (262, which is used to toggle on
> > > multipath support in tcp).
> > 
> > Maybe use IPPROTO_RAW + 1, hopefully that won't ever change.
> 
> If you don't like UINT8_MAX+1, would you be fine with open-coding, i.e.
> [256] ?

UINT8_MAX+1 is OK with me
