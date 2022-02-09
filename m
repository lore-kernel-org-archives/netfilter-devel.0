Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BFFC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 14:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiBIOWg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 09:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiBIOWg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 09:22:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301E3C06157B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 06:22:39 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nHnrg-0002vm-H0; Wed, 09 Feb 2022 15:22:36 +0100
Date:   Wed, 9 Feb 2022 15:22:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: iptables-test: Support variant deviation
Message-ID: <YgPOLCfMDlej/bvP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220204175520.29755-1-phil@nwl.cc>
 <YgPLnk/AFfRhOADQ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgPLnk/AFfRhOADQ@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 09, 2022 at 03:11:42PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 04, 2022 at 06:55:20PM +0100, Phil Sutter wrote:
> > Some test results are not consistent between variants:
> > 
> > * CLUSTERIP is not supported with nft_compat, so all related tests fail
> >   with iptables-nft.
> > * iptables-legacy mandates TCPMSS be combined with SYN flag match,
> >   iptables-nft does not care. (Or precisely, xt_TCPMSS.ko can't validate
> >   match presence.)
> > 
> > Avoid the expected failures by allowing "NFT" and "LGC" outcomes in
> > addition to "OK" and "FAIL". They specify the variant with which given
> > test should pass.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  extensions/libipt_CLUSTERIP.t | 4 ++--
> >  extensions/libxt_TCPMSS.t     | 2 +-
> >  iptables-test.py              | 7 +++++--
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/extensions/libipt_CLUSTERIP.t b/extensions/libipt_CLUSTERIP.t
> > index 5af555e005c1d..d3a2d6cbb1b2e 100644
> > --- a/extensions/libipt_CLUSTERIP.t
> > +++ b/extensions/libipt_CLUSTERIP.t
> > @@ -1,4 +1,4 @@
> >  :INPUT
> >  -d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 0 --hash-init 1;=;FAIL
> > --d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK
> 
> Could you add a new semicolon to the test line instead?
> 
> --d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK;LEGACY

Sure, will do. It means we'll have semantical aliases:

- ...;OK;LEGAY == ...;FAIL;NFT
- ...;OK:NFT == ...;FAIL;LEGACY

Not a real issue, though.

Thanks, Phil
