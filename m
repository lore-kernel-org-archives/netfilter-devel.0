Return-Path: <SRS0=biDG=Y7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6FFC5DF61
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 12:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E417214D8
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 12:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbfKGM1F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 07:27:05 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35872 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKGM1F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 07:27:05 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iSgsS-000623-0U; Thu, 07 Nov 2019 13:27:04 +0100
Date:   Thu, 7 Nov 2019 13:27:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] files: Install sample scripts from files/examples
Message-ID: <20191107122703.GW15063@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191107114516.9258-1-phil@nwl.cc>
 <20191107114516.9258-2-phil@nwl.cc>
 <20191107120604.xrgrr5b24ewhtar2@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107120604.xrgrr5b24ewhtar2@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Nov 07, 2019 at 01:06:04PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 07, 2019 at 12:45:16PM +0100, Phil Sutter wrote:
> > Assuming these are still relevant and useful as a source of inspiration,
> > install them into DATAROOTDIR/doc/nftables/examples.
> 
> I think I found the intention of this update, it's something that
> Arturo made IIRC. I forgot about this. The idea with this shebang is
> to allow for this.
> 
>         # ./x.nft
> 
> to allow to restore a ruleset without invoking nft -f.
> 
> You have to give execution permission to nft script.

Yes, that's correct. I've used dist_pkgdoc_SCRIPTS variable
intentionally, this makes them being installed with executable bit set.

Cheers, Phil
