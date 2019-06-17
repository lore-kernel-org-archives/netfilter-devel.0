Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCAAC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB8CB208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfFQRde (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:33:34 -0400
Received: from mail.us.es ([193.147.175.20]:33220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQRde (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:33:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 118CBC4144
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:33:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0067BDA70C
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:33:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EA1E9DA708; Mon, 17 Jun 2019 19:33:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8FAADA70C;
        Mon, 17 Jun 2019 19:33:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 19:33:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C794E4265A2F;
        Mon, 17 Jun 2019 19:33:29 +0200 (CEST)
Date:   Mon, 17 Jun 2019 19:33:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft 3/5] src: add cache level flags
Message-ID: <20190617173329.7ztc4ksvovj5cagu@salvia>
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-3-pablo@netfilter.org>
 <20190617161104.GT31548@orbyte.nwl.cc>
 <20190617162840.pqeyndnjwh4amzwx@salvia>
 <20190617164559.GV31548@orbyte.nwl.cc>
 <20190617172433.4bbyykwagxblwn4k@salvia>
 <20190617172831.GX31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617172831.GX31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 07:28:31PM +0200, Phil Sutter wrote:
> On Mon, Jun 17, 2019 at 07:24:33PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jun 17, 2019 at 06:45:59PM +0200, Phil Sutter wrote:
> > > On Mon, Jun 17, 2019 at 06:28:40PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, Jun 17, 2019 at 06:11:04PM +0200, Phil Sutter wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, Jun 17, 2019 at 02:25:16PM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > > 
> > > > We need these for references to sets, eg.
> > > > 
> > > >         add rule x y ip saddr @x
> > > > 
> > > > same for other flowtable and object.
> > > 
> > > Oh, right. I got that wrong - old code is always fetching the above
> > > items unless there's no ruleset in kernel (i.e., returned genid is 0).
> > > 
> > > I confused that with fetching rules which at some point started to
> > > happen by accident with my changes.
> > > 
> > > > We should not use NFT_CACHE_RULE in this case, if this is what you
> > > > suggest.
> > > 
> > > No, quite the opposite: I thought we could get by without fetching
> > > anything from kernel at all.
> > > 
> > > Yet now I wonder why the handle guessing stops working, because the
> > > above can't be the cause of it.
> > 
> > I think we should partial revert the changes that are doing the
> > handle guessing, would you submit a patch for this?
> 
> There are no explicit changes allowing for it. The reason it works is
> because user space doesn't care to check the given handle for existence
> and in kernel space it is valid already.

OK, but this test just works because we are being lucky in
guessing, right? I don't think we should not have a test for handles
from the batch, for an unexisting rule in the kernel.
