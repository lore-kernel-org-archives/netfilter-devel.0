Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393CCC31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 10:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E9F620B1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 10:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfFSKju (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 06:39:50 -0400
Received: from mail.us.es ([193.147.175.20]:60848 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfFSKju (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 06:39:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D6D68168B
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 12:39:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D4ABDA711
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 12:39:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82AAADA70E; Wed, 19 Jun 2019 12:39:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBA3CDA710;
        Wed, 19 Jun 2019 12:39:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 12:39:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C9BCB40705C4;
        Wed, 19 Jun 2019 12:39:44 +0200 (CEST)
Date:   Wed, 19 Jun 2019 12:39:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>
Cc:     shekhar sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] nft-test.py: use tempfile module
Message-ID: <20190619103944.acxr3rw7cbj4eylh@salvia>
References: <CAN9XX2pWQY0Rz2cGv7V=v8+g0mUTNGWS4pf0FJwScmrNpC5Kjg@mail.gmail.com>
 <20190618182127.21110-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618182127.21110-1-eric@garver.life>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 02:21:27PM -0400, Eric Garver wrote:
> os.tmpfile() is not in python3.

If I apply:

https://patchwork.ozlabs.org/patch/1116034/

and this patch, it's getting better, but still I hit one problem:

# python3 nft-test.py
INFO: Log will be available at /tmp/nftables-test.log
any/fwd.t: OK
any/rt.t: OK
any/queue.t: OK
any/dup.t: OK
any/log.t: OK
Traceback (most recent call last):
  File "nft-test.py", line 1455, in <module>
    main()
  File "nft-test.py", line 1423, in main
    result = run_test_file(filename, force_all_family_option,
specific_file)
  File "nft-test.py", line 1291, in run_test_file
    filename_path)
  File "nft-test.py", line 846, in rule_add
    rule_output.rstrip()) != 0:
  File "nft-test.py", line 495, in set_check_element
    if (cmp(rule1[:pos1], rule2[:pos2]) != 0):
NameError: name 'cmp' is not defined
