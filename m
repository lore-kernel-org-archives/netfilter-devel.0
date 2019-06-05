Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76605C28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51EA320866
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfFEQrB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:47:01 -0400
Received: from mail.us.es ([193.147.175.20]:58372 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbfFEQrA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 12:47:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EEA7DFB449
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:46:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD42FDA70F
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:46:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9902DA70E; Wed,  5 Jun 2019 18:46:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80F62DA709;
        Wed,  5 Jun 2019 18:46:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 18:46:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 565D84265A2F;
        Wed,  5 Jun 2019 18:46:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 0/4] split parse and evaluation phase to simplify cache logic
Date:   Wed,  5 Jun 2019 18:46:48 +0200
Message-Id: <20190605164652.20199-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

There are a myriad of cache_update() calls all over the evaluation phase
that are required because the parser invokes the evaluation per command.

This complicates the cache logic, since nft may have to invalid a
partial cache to upgrade to a full cache from one command to another.
This forces nft to go back re-evaluate the existing batch that is being
processed, this overly complicates things because the number of
scenarios that trigger cache updates explode. This will get even more
complicated once we do proper cache generation and ERESTART support is
added - which is still missing.

This patchset aims to simplify cache logic by performing one single
cache_update() before the evaluation phase, the idea is to iterate over
the existing commands that come from the parser to do a cache_evaluate()
call that calculates what cache nft needs to dump from the kernel
(either partial or full, actually we have more degress of completeness,
not just these two only). Then, with the proper cache in place, the
evaluation happens.

This patchset revisits the existing design to address this problem:

1) Dynamically allocate input_descriptor object, this allows error
   reporting from the evaluation phase to access file location that
   was only available from the parser phase.

2) Evaluate the ruleset once the parser is complete. So we have two
   independent phases.

3) The mixture of parsing + evaluation was introduced to display all
   errors, either from the parsing or the evaluation phases.

4) Make a single cache_update() call based on the new cache_evaluate()
   function that calculates the kernel dump that needs to be done
   before entering the evaluation phase.

Thanks.

Pablo Neira Ayuso (4):
  src: dynamic input_descriptor allocation
  src: perform evaluation after parsing
  src: Display parser and evaluate errors in one shot
  src: single cache_update() call to build cache before evaluation

 include/nftables.h |   1 +
 include/parser.h   |   4 +-
 include/rule.h     |   1 +
 src/Makefile.am    |   1 +
 src/cache.c        | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/erec.c         |  35 +--------------
 src/evaluate.c     |  76 +--------------------------------
 src/libnftables.c  |  57 +++++++++++++++++++------
 src/mnl.c          |   8 +---
 src/parser_bison.y |  28 ++----------
 src/parser_json.c  |   9 ----
 src/rule.c         |  18 +-------
 src/scanner.l      |  63 ++++++++++++++++++---------
 13 files changed, 222 insertions(+), 202 deletions(-)
 create mode 100644 src/cache.c

-- 
2.11.0

