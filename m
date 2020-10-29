Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5F8C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D25820780
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgJ2Lo1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:44:27 -0400
Received: from correo.us.es ([193.147.175.20]:60896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgJ2Lo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:44:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC8CFFC5F1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 12:44:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F251DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 12:44:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9497ADA78F; Thu, 29 Oct 2020 12:44:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27AE8DA704;
        Thu, 29 Oct 2020 12:44:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 29 Oct 2020 12:44:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 08B3642EF9E2;
        Thu, 29 Oct 2020 12:44:21 +0100 (CET)
Date:   Thu, 29 Oct 2020 12:44:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/shell: Restore
 testcases/sets/0036add_set_element_expiration_0
Message-ID: <20201029114421.GA13395@salvia>
References: <20201028170338.32033-1-phil@nwl.cc>
 <20201028190538.GA4169@salvia>
 <20201028190847.GA4360@salvia>
 <20201029111824.GV13016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201029111824.GV13016@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 29, 2020 at 12:18:24PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Oct 28, 2020 at 08:08:47PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Oct 28, 2020 at 08:05:38PM +0100, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Wed, Oct 28, 2020 at 06:03:38PM +0100, Phil Sutter wrote:
> > > > This reverts both commits 46b54fdcf266d3d631ffb6102067825d7672db46 and
> > > > 0e258556f7f3da35deeb6d5cfdec51eafc7db80d.
> > > > 
> > > > With both applied, the test succeeded *only* if 'nft monitor' was
> > > > running in background, which is equivalent to the original problem
> > > > (where the test succeeded only if *no* 'nft monitor' was running).
> > > > 
> > > > The test merely exposed a kernel bug, so in fact it is correct.
> > > 
> > > Please, do not revert this.
> > > 
> > > This kernel patch needs this fix:
> > > 
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20201022204032.28904-1-pablo@netfilter.org/
> > 
> > With the kernel patch above, this test does not break anymore.
> > 
> > ie. --echo is not printing the generation ID because kernel bug.
> 
> Oh, I mis-read the kernel patch, sorry for the mess. I would suggest to
> change your test case fix into this though:
> 
> | -test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | head -n -1)
> | +test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | grep -v '# new generation')
> 
> This makes it clear what is to be omitted and also makes the test work
> with unpatched kernels as well. Fine with you?

That's fine indeed and more readable indeed.
