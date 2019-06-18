Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783EAC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5758120B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfFRQQN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 12:16:13 -0400
Received: from mail.us.es ([193.147.175.20]:39586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfFRQQN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 12:16:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0AA8153AA1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:16:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90E74DA70E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:16:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86702DA70C; Tue, 18 Jun 2019 18:16:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D570DA701;
        Tue, 18 Jun 2019 18:16:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 18:16:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5B3E44265A2F;
        Tue, 18 Jun 2019 18:16:08 +0200 (CEST)
Date:   Tue, 18 Jun 2019 18:16:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to  python3
Message-ID: <20190618161607.3oewnnznnzm7tln4@salvia>
References: <20190614143144.10482-1-shekhar250198@gmail.com>
 <20190618143106.tgpedjytw74octms@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618143106.tgpedjytw74octms@egarver.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 10:31:06AM -0400, Eric Garver wrote:
> On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> > 
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The version hystory of this patch is:
> > v1:conversion to py3 by changing the print statements.
> > v2:add the '__future__' package for compatibility with py2 and py3.
> > v3:solves the 'version' problem in argparse by adding a new argument.
> > v4:uses .format() method to make print statements clearer.
> > v5:updated the shebang and corrected the sequence of import statements.
> > v6:resent the same with small changes
> > v7:resent with small changes

I apply this patch, then, from the nftables/tests/py/ folder I run:

# python3 nft-test.py

I get:

INFO: Log will be available at /tmp/nftables-test.log
Traceback (most recent call last):
  File "nft-test.py", line 1454, in <module>
    main()
  File "nft-test.py", line 1422, in main
    result = run_test_file(filename, force_all_family_option, specific_file)
  File "nft-test.py", line 1290, in run_test_file
    filename_path)
  File "nft-test.py", line 774, in rule_add
    payload_log = os.tmpfile()
AttributeError: module 'os' has no attribute 'tmpfile'
