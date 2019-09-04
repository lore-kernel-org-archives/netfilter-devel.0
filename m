Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C278C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 08:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E11022CF7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 08:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfIDIVc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:21:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45714 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbfIDIVc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 04:21:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i5QXg-0001tP-Nq; Wed, 04 Sep 2019 10:21:28 +0200
Date:   Wed, 4 Sep 2019 10:21:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] conntrack: Fix CIDR to mask conversion
 on Big Endian
Message-ID: <20190904082128.GG13660@breakpoint.cc>
References: <20190902164431.18398-1-phil@nwl.cc>
 <20190903203447.saqplkgbbxlajkqr@salvia>
 <20190904065356.GF25650@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904065356.GF25650@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> What we need in b is 'ff ff ff 00' for a prefix length of 24. Your
> suggested alternative does not compile, so I tried both options for the
> closing brace:
> 
> | htonl((1 << 24) - 1)
> 
> This turns into '00 ff ff ff' for both LE and BE, the opposite of what
> we need.
> 
> | htonl((1 << 24)) - 1
> 
> This turns into '00 00 00 00' on LE and '00 ff ff ff' on BE.
> 
> My code leads to correct result on either architecture and I don't see a
> simpler way of doing it.

htonl(~0u << (32 - i)) would work, assuming i > 0 and <= 32.
