Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5DAC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084092084D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfFRRem (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:34:42 -0400
Received: from mail.us.es ([193.147.175.20]:41538 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbfFRRem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:34:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8489C40E4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 19:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98006DA70E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 19:34:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D6D0DA70B; Tue, 18 Jun 2019 19:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EF97DA701;
        Tue, 18 Jun 2019 19:34:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 19:34:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1D7114265A2F;
        Tue, 18 Jun 2019 19:34:37 +0200 (CEST)
Date:   Tue, 18 Jun 2019 19:34:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Eric Garver <eric@garver.life>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to python3
Message-ID: <20190618173436.xmrq7ue7746jfatu@salvia>
References: <20190614143144.10482-1-shekhar250198@gmail.com>
 <20190618143106.tgpedjytw74octms@egarver.localdomain>
 <20190618161607.3oewnnznnzm7tln4@salvia>
 <CAN9XX2rHwLNQT3Doa121u_gTPwCrT0icszdFgJH8ZcWdYfSbVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2rHwLNQT3Doa121u_gTPwCrT0icszdFgJH8ZcWdYfSbVg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 10:59:53PM +0530, shekhar sharma wrote:
> Hi Pablo!
> 
> On Tue, Jun 18, 2019 at 9:46 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Tue, Jun 18, 2019 at 10:31:06AM -0400, Eric Garver wrote:
> > > On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> > > > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> > > >
> > > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > > ---
> > > > The version hystory of this patch is:
> > > > v1:conversion to py3 by changing the print statements.
> > > > v2:add the '__future__' package for compatibility with py2 and py3.
> > > > v3:solves the 'version' problem in argparse by adding a new argument.
> > > > v4:uses .format() method to make print statements clearer.
> > > > v5:updated the shebang and corrected the sequence of import statements.
> > > > v6:resent the same with small changes
> > > > v7:resent with small changes
> >
> > I apply this patch, then, from the nftables/tests/py/ folder I run:
> >
> > # python3 nft-test.py
> >
> > I get:
> >
> > INFO: Log will be available at /tmp/nftables-test.log
> > Traceback (most recent call last):
> >   File "nft-test.py", line 1454, in <module>
> >     main()
> >   File "nft-test.py", line 1422, in main
> >     result = run_test_file(filename, force_all_family_option, specific_file)
> >   File "nft-test.py", line 1290, in run_test_file
> >     filename_path)
> >   File "nft-test.py", line 774, in rule_add
> >     payload_log = os.tmpfile()
> > AttributeError: module 'os' has no attribute 'tmpfile'
> 
> I do not know why this error is occurring but may i suggest
> you to try the v8 of the netns patch, (as it is a continuation of this patch),
> if that works, we will know that there is some problem in this patch
> specifically.

Still the same problem with v8:

    Date:   Mon Jun 17 19:45:58 2019 +0530

    tests: py: add netns feature

    This patch adds the netns feature to the 'nft-test.py' file.
