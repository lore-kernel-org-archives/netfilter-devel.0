Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC0AC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 22:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D1B206DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 22:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfLDWnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 17:43:10 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59418 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfLDWnK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 17:43:10 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icdMS-0004sg-Sg; Wed, 04 Dec 2019 23:43:08 +0100
Date:   Wed, 4 Dec 2019 23:43:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] Fix DEBUG build
Message-ID: <20191204224308.GZ14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191204090606.2088-1-phil@nwl.cc>
 <20191204174927.5eylewkivztqwmzh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204174927.5eylewkivztqwmzh@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Dec 04, 2019 at 06:49:27PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 04, 2019 at 10:06:05AM +0100, Phil Sutter wrote:
> > Fixed commit missed to update this conditional call to
> > nft_rule_print_save().
> > 
> > Fixes: 1e8ef6a584754 ("nft: family_ops: Pass nft_handle to 'rule_to_cs' callback")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> If you still find all this debugging useful.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Otherwise, remove the nft DEBUG is another option. IIRC those were
> added at very early stage to fix a few issues with -D and -C commands.
> 
> Pick the one you prefer. Thanks!

While it's definitely not as convenient as calling 'nft --debug=<foo>',
it's better than nothing. So I'm rather tempted to try and implement a
permanent debug output option although all the added jumps will probably
kill kubernetes. ;)

Cheers, Phil
