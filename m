Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BBAC4CEC8
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 18:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D994206A5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 18:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbfIMSfv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 14:35:51 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44152 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbfIMSfv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 14:35:51 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i8qQ7-0001m1-Lb; Fri, 13 Sep 2019 20:35:47 +0200
Date:   Fri, 13 Sep 2019 20:35:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] parser_bison: Fix 'exists' keyword on Big Endian
Message-ID: <20190913183547.GB9943@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190913153224.486-1-phil@nwl.cc>
 <20190913153549.GB10656@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913153549.GB10656@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Sep 13, 2019 at 05:35:49PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > -					   BYTEORDER_HOST_ENDIAN, 1, buf);
> > +					   BYTEORDER_HOST_ENDIAN,
> > +					   sizeof(char) * BITS_PER_BYTE, buf);
> 
> You can omit the sizeof(char), its always 1.  Otherwise this loooks good to me.

OK, I'll send a v2.

Thanks, Phil
