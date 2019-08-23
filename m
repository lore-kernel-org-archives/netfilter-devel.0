Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA1BC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0ECC2173E
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733074AbfHWMj1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:39:27 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44103 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731780AbfHWMj1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 08:39:27 -0400
Received: from [31.4.212.198] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i18qe-0007JL-0A; Fri, 23 Aug 2019 14:39:26 +0200
Date:   Fri, 23 Aug 2019 14:39:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v8 2/2] meta: Introduce new conditions 'time', 'day'
 and 'hour'
Message-ID: <20190823123917.uxdlb7gzfbgamfxc@salvia>
References: <20190821151802.6849-1-a@juaristi.eus>
 <20190821151802.6849-2-a@juaristi.eus>
 <20190821162341.GB20113@breakpoint.cc>
 <20190821205055.dss3wfiv4pogyhjl@salvia>
 <20190821210417.GD20113@breakpoint.cc>
 <f7b2dec4-d58e-e65b-296a-11061b4af90f@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b2dec4-d58e-e65b-296a-11061b4af90f@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 23, 2019 at 09:08:47AM +0200, Ander Juaristi wrote:
> On 21/8/19 23:04, Florian Westphal wrote:
> > > > 
> > > > Pablo, please see this "-t" option -- should be just re-use -n instead?
> > > > 
> > > > Other than this, this patch looks good and all tests pass for me.
> > > 
> > > this should be printed numerically with -n (global switch to disable
> > > literal printing).
> > > 
> > > Then, -t could be added for disabling literal in a more fine grain, as
> > > Phil suggest time ago with other existing options that are similar to
> > > this one.
> > 
> > Ander, would you mind respinning this once more and excluding the -t
> > option?  You can reuse -n (OPT_NUMERIC) to print raw time values for
> > the time being.
> > 
> 
> You mean removing the -t option altogether?

Phil likes having fine grain knobs. I (as a user) particularly prefer
the global -n switch, but I also see value in those fine grain knobs.

Anyway, I let you choose on this one.

Thanks.
