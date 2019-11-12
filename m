Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E66C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D95B21783
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfKLLgo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:36:44 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47770 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfKLLgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 06:36:43 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iUUTR-0005Ax-K6; Tue, 12 Nov 2019 12:36:41 +0100
Date:   Tue, 12 Nov 2019 12:36:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] files: Drop shebangs from config files
Message-ID: <20191112113641.GA11663@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191107114516.9258-1-phil@nwl.cc>
 <99bf1a8a-96e9-3ad6-bef4-3defe0da951b@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99bf1a8a-96e9-3ad6-bef4-3defe0da951b@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Tue, Nov 12, 2019 at 12:15:07PM +0100, Arturo Borrero Gonzalez wrote:
> On 11/7/19 12:45 PM, Phil Sutter wrote:
> > These are not meant to be executed as is but instead loaded via
> > 'nft -f' - all-in-one.nft even points this out in header comment.
> > While being at it, drop two spelling mistakes found along the way.
> > 
> > Consequently remove executable bits - being registered in automake as
> > dist_pkgsysconf_DATA, they're changed to 644 upon installation anyway.
> > 
> > Also there is obviously no need for replacement of nft binary path
> > anymore, drop that bit from Makefile.am.
> 
> If you drop the shebang, the shell may not know how to execute these files. Why
> not executing them with the python interpreter instead of `nft -f`?

Even without dropping it, shell won't execute them because we don't
install them with executable bit set.

> As pablo commented, the intention was to allow simple use cases like:
> 
> root@server:~# ./load-my-ruleset.nft
> 
> This use case would still be allowed after this patch but it would be a little
> less obvious (less examples). So I'm not sure about ACK'ing this patch.

While it is inconvenient for users to set the file executable first,
adding a shebang is certainly beyond that. IMO, we basically have two
options:

A) Apply my patch and stick to all-in-one.nft's header comment ("This
   script is meant to be loaded with `nft -f <file>`").

B) Ignore my patch and declare the configs as dist_pkgsysconf_SCRIPTS
   (untested) so they are installed with executable bit set.

Personally I find it awkward to directly execute files in /etc other
than sysv init scripts, hence why I prefer (A). For an example of "real"
nft scripts, there are the samples in files/examples/ which get
installed into $docdir/examples/ with executable bit set if my other
patch is applied.

But for me, (B) is fine as well. I just think we should be consistent.
:)

Cheers, Phil
