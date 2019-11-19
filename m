Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8250C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 00:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EFB022303
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 00:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKSAUh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 19:20:37 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35036 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfKSAUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 19:20:37 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iWrFz-0007Mh-02; Tue, 19 Nov 2019 01:20:35 +0100
Date:   Tue, 19 Nov 2019 01:20:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/py: Set a fixed timezone in nft-test.py
Message-ID: <20191119002034.GB8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191116213218.14698-1-phil@nwl.cc>
 <20191118183459.qkqztuc5pn4fezzn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118183459.qkqztuc5pn4fezzn@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Nov 18, 2019 at 07:34:59PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Nov 16, 2019 at 10:32:18PM +0100, Phil Sutter wrote:
> > Payload generated for 'meta time' matches depends on host's timezone and
> > DST setting. To produce constant output, set a fixed timezone in
> > nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
> > the remaining two tests.
> 
> This means that the ruleset listing for the user changes when daylight
> saving occurs, right? Just like it happened to our tests.

I think UTC-2 is a fixed offset to a time that doesn't change. During
DST in Europe, our timezone changes from CET to CEST, or from UTC+1 to
UTC+2. So by specifying the same TZ no matter if DST applies or not, the
offset added to the current time should always remain the same.

Cheers, Phil

