Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5570E95A96
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 11:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbjJILlm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 07:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346303AbjJILlk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 07:41:40 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B129D
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 04:41:38 -0700 (PDT)
Received: from [78.30.34.192] (port=49656 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qpodi-00DafO-Nr; Mon, 09 Oct 2023 13:41:36 +0200
Date:   Mon, 9 Oct 2023 13:41:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZSPm7SQhO/ziVMaw@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
 <20231009111543.GB27648@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231009111543.GB27648@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 09, 2023 at 01:15:43PM +0200, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> > On 10/9/23 12:44, Pablo Neira Ayuso wrote:
> > > - Another possibility is to make a nftables 1.0.6.1 or 1.0.6a -stable
> > > release from netfilter.org. netfilter.org did not follow this procedure
> > > very often (a few cases in the past in iptables IIRC).
> > 
> > Given the amount of patches, this would be the preferred method from the
> > Debian point of view.
> > 
> > 1.0.6.1 as version should be fine.

Only one thing: I just wonder if this new 4 numbers scheme might
create confusion, as there will be release with 3 numbers and -stable
releases with 4 numbers.

> In that case the only question is if we add 1.0.6.y branch to
> nftables.git or create nftables-stable.git.
> 
> I'd go with stable branches directly in nftables.git, but would
> not mind a separate repo either.

Fine with me, separated branch is fine.
