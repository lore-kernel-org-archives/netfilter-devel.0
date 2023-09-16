Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34DCCD37BC
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Sep 2023 14:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbjIPOlU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Sep 2023 10:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjIPOlC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Sep 2023 10:41:02 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF78C13E
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Sep 2023 07:40:56 -0700 (PDT)
Received: from [78.30.34.192] (port=51516 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qhWTa-00HBY6-Rs; Sat, 16 Sep 2023 16:40:53 +0200
Date:   Sat, 16 Sep 2023 16:40:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jann Haber <jannh@selfnet.de>
Cc:     netfilter-devel@vger.kernel.org, Jonas Burgdorf <jonas@selfnet.de>,
        technik@selfnet.de
Subject: Re: Issue with counter and interval map
Message-ID: <ZQW+cly8G3gjrsLl@calendula>
References: <f65ce9da-e780-433d-be98-44080754109e@selfnet.de>
 <ZQI89KmxZpTEKYN9@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZQI89KmxZpTEKYN9@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 14, 2023 at 12:52:24AM +0200, Pablo Neira Ayuso wrote:
> Hi Jann,
> 
> On Wed, Sep 13, 2023 at 07:42:01PM +0200, Jann Haber wrote:
> > Dear nftables-developers,
> > 
> > at Selfnet, we have been operating our CGN based on nftables for
> > roughly 4 years now (at that time we switched from iptables).
> > Recently, we have upgraded our first server from Debian bullseye
> > (Kernel 5.10, nftables 0.9.8) to bookworm (Kernel 6.1, nftables
> > 1.0.6). On bookworm, our ruleset that works well on bullseye fails
> > to load.
> > 
> > We have boiled it down to the minimal example attached, which fails
> > to load correctly on bookworm and also on a current Arch-Linux.
> > 
> > xxxxx@xxxxx:~$ sudo nft -f example.conf
> > example.conf:5:35-48: Error: Could not process rule: No such file or directory
> > add element inet filter testmap { 192.168.0.0/24 : "TEST" }
> >                                   ^^^^^^^^^^^^^^
> > What we have tested:
> > - Removing the last line from the file and running it later manually
> >   via the command line, there is no error
> > - Splitting the file in two (having the final line in a separate
> >   file), the two files can be applied with two nft -f calls with no
> >   error
> > - When swapping the lines 3 and 4 (i.e. first add counter, then add
> >   map), there is no error applying the file
> > - Removing "flags: interval" from the map and testing with a single
> >   IP, there is no error applying the file
> > 
> > In summary, I believe our rule syntax is ok - but something is going
> > wrong when the rules are applied in the given order atomically with
> > "nft -f". We appreciate any insight, please also let us know if we
> > did something wrong or if we can assist with debugging further.
> 
> I can reproduce it, this is a userspace bug which happens with
> interval sets in nft_cmd_post_expand(), I will post a fix asap.

Proposed patch to address this issue:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230916143549.57646-1-pablo@netfilter.org/

I am taking a look at the second issue you are reporting, I will
follow up.

Thanks.
