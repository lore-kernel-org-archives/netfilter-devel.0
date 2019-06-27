Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AABAC48BD7
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 19:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 014BA208E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 19:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0TbX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 15:31:23 -0400
Received: from mail.us.es ([193.147.175.20]:57554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0TbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 15:31:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02CA2C4140
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 21:31:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6497DA3F4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 21:31:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4667DA704; Thu, 27 Jun 2019 21:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C64B2DA704;
        Thu, 27 Jun 2019 21:31:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 21:31:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A19984265A2F;
        Thu, 27 Jun 2019 21:31:18 +0200 (CEST)
Date:   Thu, 27 Jun 2019 21:31:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] selftests: netfilter: add nfqueue test case
Message-ID: <20190627193118.qrpkojwidqoowmdw@salvia>
References: <20190626184234.3172-1-fw@strlen.de>
 <20190626185216.egekz5qpe2ggzj6j@salvia>
 <20190626185653.7xeno66crjigeyul@breakpoint.cc>
 <20190626190503.jibrghju35bgofxx@salvia>
 <20190626190929.qkhxqcep4faoj65d@salvia>
 <20190627190348.lvho4m4aum27habh@salvia>
 <20190627192525.w4d4vf2iqsc44mup@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627192525.w4d4vf2iqsc44mup@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 09:25:25PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jun 26, 2019 at 09:09:29PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Jun 26, 2019 at 09:05:03PM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Jun 26, 2019 at 08:56:53PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > On Wed, Jun 26, 2019 at 08:42:34PM +0200, Florian Westphal wrote:
> > > > > > > diff --git a/tools/testing/selftests/netfilter/nf-queue.c b/tools/testing/selftests/netfilter/nf-queue.c
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..897274bd6f4a
> > > > > > > --- /dev/null
> > > > > > > +++ b/tools/testing/selftests/netfilter/nf-queue.c
> > > > > > 
> > > > > > Oh well. Lots of copied and pasted code from the libraries.
> > > > > > 
> > > > > > We'll have to remind to take patches for the example in the library
> > > > > > and the kernel.
> > > > > 
> > > > > Do you have an alternative proposal?
> > > > 
> > > > Probably install this nf-queue tool from libraries? Then, selftest use
> > > > this binary? So we have a single copy of this code :-)
> > > 
> > > Or move this C code to a new git tree under netfilter, eg.
> > > netfilter-tests.git, you may need something similar for
> > > libnetfilter_log I suspect, and so on for other stuff.
> > > 
> > > Such new git tree would compile all testing tools for netfilter and
> > > install them.
> > > 
> > > kselftest depends on external tooling anyway, this should be fine.
> > 
> > You could also integrate the tcpdr tool that Mate was using to test
> > tproxy, there will be a test for tproxy too at some point, right? And
> > you don't want to push that into the kernel?
> 
> Actually ... yes :/
> 
> I had hoped that we could maximize coverage of netfilter core infra
> this way.
> 
> We have an embarassing number of regressions and really stupid bugs.
> Largely because we don't have tests at all, or because they
> live outside of kernel/are not run with a certain config.

I think they cover different aspects, so far we have good coverage
for the control plane, which are the tests you are refering to.

> > Having all this testing tools in the git repository somewhere where it
> > can be collected could be useful. Users could invoke it from command
> > line to collect packets and print them. I mean, add the nfqueue tool,
> > then the nflog tool too, and so on.
> 
> Yes, but that means that anyone running make run_tests will get a 'SKIP'
> for these tests UNLESS they also installed the netfilter-test.git
> tools.

Is there any script that pulls dependencies and install them to run
this kselftests?

> If you think thats fine, I can start accumulating tools in a new repo.

I'm just brainstorming where to go, and see if you think it can be
useful to start collecting testing/debugging tools that might be not
only useful for this test infrastructure, but for general
troubleshooting.

My only concern is that we might end up with a bit of C code spread
over the test tree for all these tooling. Probably these tooling could
reside in the kernel tree if you prefer.
