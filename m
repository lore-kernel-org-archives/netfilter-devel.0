Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F07C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7D020656
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgBWWQL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:16:11 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45748 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgBWWQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:16:11 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j5zXl-0004CG-A6; Sun, 23 Feb 2020 23:16:09 +0100
Date:   Sun, 23 Feb 2020 23:16:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 5/5] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20200223221609.GY19559@breakpoint.cc>
References: <cover.1582488826.git.sbrivio@redhat.com>
 <02877a1cf5364db8f60a29a9a6aad705dea22dbd.1582488826.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02877a1cf5364db8f60a29a9a6aad705dea22dbd.1582488826.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> If the AVX2 set is available, we can exploit the repetitive
> characteristic of this algorithm to provide a fast, vectorised
> version by using 256-bit wide AVX2 operations for bucket loads and
> bitwise intersections.

Looks great, this needs a small rebase on top of nf-next now that
the dynamic set registration is gone.

