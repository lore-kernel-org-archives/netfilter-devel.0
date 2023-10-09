Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB69AE95A91
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 11:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346194AbjJILPs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 07:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346170AbjJILPr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 07:15:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C11194
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 04:15:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qpoEh-0008RF-QA; Mon, 09 Oct 2023 13:15:43 +0200
Date:   Mon, 9 Oct 2023 13:15:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arturo Borrero Gonzalez <arturo@debian.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <20231009111543.GB27648@breakpoint.cc>
References: <ZSPZiekbEmjDfIF2@calendula>
 <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> On 10/9/23 12:44, Pablo Neira Ayuso wrote:
> > - Another possibility is to make a nftables 1.0.6.1 or 1.0.6a -stable
> > release from netfilter.org. netfilter.org did not follow this procedure
> > very often (a few cases in the past in iptables IIRC).
> 
> Given the amount of patches, this would be the preferred method from the
> Debian point of view.
> 
> 1.0.6.1 as version should be fine.

In that case the only question is if we add 1.0.6.y branch to
nftables.git or create nftables-stable.git.

I'd go with stable branches directly in nftables.git, but would
not mind a separate repo either.
