Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF89C433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 08:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E11522272
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 08:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbgJIIvt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:51:49 -0400
Received: from correo.us.es ([193.147.175.20]:41308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732492AbgJIIvt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 04:51:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 95ACB396275
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 10:51:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 872A3DA844
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 10:51:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7C1DDDA7E1; Fri,  9 Oct 2020 10:51:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52883DA730;
        Fri,  9 Oct 2020 10:51:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Oct 2020 10:51:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3025642EF4E0;
        Fri,  9 Oct 2020 10:51:44 +0200 (CEST)
Date:   Fri, 9 Oct 2020 10:50:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201009085039.GB7851@salvia>
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia>
 <20201009082953.GD13016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201009082953.GD13016@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc'ing Jozsef.

On Fri, Oct 09, 2020 at 10:29:53AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Oct 08, 2020 at 07:31:56PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 02, 2020 at 01:44:36PM +0200, Arturo Borrero Gonzalez wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > Previous to this patch, the basechain policy could not be properly configured if it wasn't
> > > explictly set when loading the ruleset, leading to iptables-nft-restore (and ip6tables-nft-restore)
> > > trying to send an invalid ruleset to the kernel.
> > 
> > I have applied this with some amendments to the test file to cover
> > the --noflush case. I think this is a real problem there, where you
> > can combine to apply incremental updates to the ruleset.
> 
> Yes, at least I can imagine people relying upon this behaviour.
> 
> > For the --flush case, I still have doubts how to use this feature, not
> > sure it is worth the effort to actually fix it.
> 
> I even find it unintuitive as it retains state despite flushing.

So am I.

> But that is a significant divergence between legacy and nft:
> 
> | # iptables -P FORWARD DROP
> | # iptables-restore <<EOF
> | *filter
> | COMMIT
> | EOF
> | # iptables-save
>
> With legacy, the output is:
> 
> | *filter
> | :INPUT ACCEPT [0:0]
> | :FORWARD DROP [0:0]
> | :OUTPUT ACCEPT [0:0]
> | COMMIT
>
> With nft, there's no output at all. What do you think, should we fix
> that? If so, which side?

Looks like a variant of the same usecase.

So if basechains are not specified, then basechains policies are left
as is, but ruleset is flushed.

Semantics for this are: Flush out _everything_ (existing rules and
non-chains) but only leave existing basechain policies in place as is.

I wonder if this is intentional or a side effect of the --noflush support.

I'm Cc'ing Jozsef, maybe he remembers. Because you're reaching my
boundaries on the netfilter history for this one :-)

> > We can revisit later, you can rewrite this later Phil.
> 
> Sure, no problem.

Thanks.
