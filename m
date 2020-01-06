Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0B3C33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28E52072E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgAFMUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:20:25 -0500
Received: from correo.us.es ([193.147.175.20]:43666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAFMUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:20:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DF9AF2DF4
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CBCEDA710
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 324F1DA703; Mon,  6 Jan 2020 13:20:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B0BADA703;
        Mon,  6 Jan 2020 13:20:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:20:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F3E8141E4800;
        Mon,  6 Jan 2020 13:20:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 0/7] iptables: introduce cache evaluation phase
Date:   Mon,  6 Jan 2020 13:20:11 +0100
Message-Id: <20200106122018.14090-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Happy new year.

This patchset introduces a new step to parse rules into a list
of commands:

 input -> parser -> list of commands -> list of jobs -> netlink -> kernel

This allows us to estimate the cache requirements from the list of
commands and to avoid in-transit cache cancelations while handling
a batch.

This batch is likely disabling your optimizations where selective
chain/set netlink dump speeds up things. From reading the code,
I'm not sure what paths are specifically benefiting from this
optimization since any of the existing nftnl_chain_list_get() and
nftnl_set_list_get() calls might exercise this selective netlink dump.
I think it should not be too hard to restore those, I remember you have
a few tests to evaluate the speed up. Note that this patch also disables
the pre-parsing from xtables-restore.

Downside is that there's an extra memory allocation, that could be
consolidated in the future, by having one single list of commands/jobs.
But would probably make this batch even larger, but I tried to reduce
complexity as much as possible. Debugging cache issue is hard in my
opinion, if we can avoid fetch/cancel/fetch cache scenario, the better.

The approach that 'among' follows to use the set infrastructure is
interesting, probably there's a way to simplify this, but I understand
there might be more urgent stuff to have a look.

Let me know,
Thanks.

P.S: I started this patchset by Dec 25 while traveling, tests look
     OK here, I'm just releasing this because I'm not sure I can come
     back to this anytime soon.

Pablo Neira Ayuso (7):
  nft: do not check for existing chain from parser
  nft: split parsing from netlink commands
  nft: calculate cache requirements from list of commands
  nft: restore among support
  nft: remove cache build calls
  nft: skip table list release if uninitialized
  nft: missing nft_fini() call in bridge family

 iptables/Makefile.am                               |   2 +-
 iptables/nft-arp.c                                 |   5 +-
 iptables/nft-bridge.c                              |  18 +-
 iptables/nft-cache.c                               |  72 ++--
 iptables/nft-cache.h                               |   1 +
 iptables/nft-cmd.c                                 | 389 +++++++++++++++++++++
 iptables/nft-cmd.h                                 |  79 +++++
 iptables/nft-shared.c                              |   6 +-
 iptables/nft-shared.h                              |   4 +-
 iptables/nft.c                                     | 310 +++++++++++-----
 iptables/nft.h                                     |  49 ++-
 .../shell/testcases/ip6tables/0004-return-codes_0  |   2 +-
 .../shell/testcases/iptables/0004-return-codes_0   |   2 +-
 iptables/xtables-arp.c                             |  26 +-
 iptables/xtables-eb-standalone.c                   |   2 +
 iptables/xtables-eb.c                              |  26 +-
 iptables/xtables-restore.c                         |  35 +-
 iptables/xtables-save.c                            |   3 +
 iptables/xtables.c                                 |  57 ++-
 19 files changed, 863 insertions(+), 225 deletions(-)
 create mode 100644 iptables/nft-cmd.c
 create mode 100644 iptables/nft-cmd.h

-- 
2.11.0

