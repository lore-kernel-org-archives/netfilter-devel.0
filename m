Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5267EC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2400F218A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfGCLGW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 07:06:22 -0400
Received: from mail.us.es ([193.147.175.20]:47068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbfGCLGW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 07:06:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74BEC11F133
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:06:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6518F21FE4
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:06:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6413BDA732; Wed,  3 Jul 2019 13:06:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 470939D56B;
        Wed,  3 Jul 2019 13:06:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 13:06:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 224BE4265A2F;
        Wed,  3 Jul 2019 13:06:18 +0200 (CEST)
Date:   Wed, 3 Jul 2019 13:06:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] files: Move netdev-ingress.nft to /etc/nftables as
 well
Message-ID: <20190703110616.xjci3jvm5kwr7ksf@salvia>
References: <20190624151238.4869-1-phil@nwl.cc>
 <20190624151446.2umdf4bzem4h7yqj@breakpoint.cc>
 <20190624162406.GB9218@orbyte.nwl.cc>
 <20190624164941.dhcm57r35km3azbg@breakpoint.cc>
 <20190625002404.63o7novb2ett2yoo@salvia>
 <20190703105600.GB31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703105600.GB31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 03, 2019 at 12:56:00PM +0200, Phil Sutter wrote:
> On Tue, Jun 25, 2019 at 02:24:04AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jun 24, 2019 at 06:49:41PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > Right.  Do you think we should also add in inet-nat.nft example,
> > > > > or even replace the ipvX- ones?
> > > > 
> > > > Having an inet family nat example would be wonderful! Can inet NAT
> > > > replace IPvX-ones completely or are there any limitations as to what is
> > > > possible in rules?
> > > 
> > > I'm not aware of any limitations.
> > 
> > Only limitation is that older kernels do not support NAT for the inet
> > family.
> 
> OK, so maybe add inet NAT example but not delete ip/ip6 ones?

Agreed.

> What is the status regarding my patch, please? I think fixing
> netdev-ingress.nft location is unrelated to this discussion, right?

Oh right, I got confused by the discussion.
