Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D786CC76186
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 20:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA4C20838
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 20:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfGTULh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 16:11:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41348 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfGTULh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 16:11:37 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hovhd-0007Zg-VL; Sat, 20 Jul 2019 22:11:34 +0200
Date:   Sat, 20 Jul 2019 22:11:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 09/12] xtables-save: Make COMMIT line optional
Message-ID: <20190720201133.GE32501@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190720163026.15410-1-phil@nwl.cc>
 <20190720163026.15410-10-phil@nwl.cc>
 <20190720192918.ckfbq22si4tundhx@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720192918.ckfbq22si4tundhx@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 20, 2019 at 09:29:18PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Change xtables_save_main to support optional printing of COMMIT line as
> > it is not used in arp- or ebtables.
> 
> Why?  Is this so ebt-save dumps are compatible with the
> old ebt-restore?

Hmm. I haven't considered deviating in ebtables-nft-save format from
legacy one yet, but it may actually be no problem given that people
shouldn't switch between both. The only bummer might be if someone has a
custom script which then trips over the unknown non-comment line.

I'm undecided, but not against "breaking" with legacy save dumps per se.
If you think it's not a problem, we could just simplify things. OTOH
this is not a big patch, either so maybe not even worth the risk. :)

Thanks, Phil
