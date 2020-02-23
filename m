Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CCCC35670
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1CFB20880
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgBWXPe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:15:34 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45866 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbgBWXPe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 18:15:34 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j60TA-0004aQ-0o; Mon, 24 Feb 2020 00:15:28 +0100
Date:   Mon, 24 Feb 2020 00:15:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/5] nft_set_pipapo: Prepare for vectorised
 implementation: alignment
Message-ID: <20200223231528.GD19559@breakpoint.cc>
References: <cover.1582488826.git.sbrivio@redhat.com>
 <2723f85da2cd9d6b7158c7a2514c6b22f044b1b6.1582488826.git.sbrivio@redhat.com>
 <20200223221435.GX19559@breakpoint.cc>
 <20200224000429.7997696b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224000429.7997696b@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> '*scratch' is actually needed at lookup time for implementations that
> don't need stricter alignment than natural one, but I could probably
> use some macro trickery and "move" it as needed.

Ah I see, don't bother then for now.

> I'm not sure how to deal with fields after f[0], syntactically. Do you
> have some, er, pointers?

Don't bother, its very ugly.

Base hook chains do this, it involves a comment at the tail of the
struct, see struct nf_hook_entries in include/linux/netfilter.h.
