Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1269C5DF63
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 14:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82E720663
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 14:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbfKFOAw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:00:52 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:33666 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfKFOAw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 09:00:52 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iSLre-0002B6-Ez; Wed, 06 Nov 2019 15:00:50 +0100
Date:   Wed, 6 Nov 2019 15:00:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] libnftables: Store top_scope in struct nft_ctx
Message-ID: <20191106140050.GQ15063@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191030212854.19494-1-phil@nwl.cc>
 <20191106124017.trvdxr4dylvigg5g@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106124017.trvdxr4dylvigg5g@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Nov 06, 2019 at 01:40:17PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 30, 2019 at 10:28:54PM +0100, Phil Sutter wrote:
> > Allow for interactive sessions to make use of defines. Since parser is
> > initialized for each line, top scope defines didn't persist although
> > they are actually useful for stuff like:
> > 
> > | # nft -i
> > | goodports = { 22, 23, 80, 443 }
>    ^
> 'define' is missing here, right?

Oh yes, of course.

> > | add rule inet t c tcp dport $goodports accept
> > | add rule inet t c tcp sport $goodports accept
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> One more comment, possible follow up, just an idea.

Added those, sent v2 just to be sure.

Thanks, Phil
