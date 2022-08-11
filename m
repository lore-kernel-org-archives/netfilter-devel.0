Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08236C19F2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 14:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiHKOlu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 10:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKOlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 10:41:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EC808E0F6
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 07:41:49 -0700 (PDT)
Date:   Thu, 11 Aug 2022 16:41:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, alexanderduyck@fb.com,
        edumazet@google.com
Subject: Re: [PATCH nf 0/4] netfilter: conntrack: remove 64kb max size
 assumptions
Message-ID: <YvUVJwW4QhCVcHik@salvia>
References: <20220809131635.3376-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809131635.3376-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 09, 2022 at 03:16:31PM +0200, Florian Westphal wrote:
> Some of our dated conntrack helpers assume skbs can't contain
> tcp packets larger than 64kb.
> 
> Update those.  For SANE, I don't see a reason for the
> 'full-packet-copy', just extract the sane header.
> 
> For h323, packet gets capped at 64k; larger one will be
> seen as truncated.
> 
> For irc, cap at 4k: a line length should not exceed 512 bytes.
> For ftp, use skb_linearize(), its the most simple way to resolve this.

Applied, thanks.
