Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF78BC5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6910217D7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfKFLMp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:12:45 -0500
Received: from correo.us.es ([193.147.175.20]:44010 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfKFLMp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 06:12:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 277283066A3
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 135D9D1929
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08DA74D744; Wed,  6 Nov 2019 12:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C5D9B8001;
        Wed,  6 Nov 2019 12:12:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 12:12:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CF28241E4803;
        Wed,  6 Nov 2019 12:12:38 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/9] Netfilter fixes for net
Date:   Wed,  6 Nov 2019 12:12:28 +0100
Message-Id: <20191106111237.3183-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Missing register size validation in bitwise and cmp offloads.

2) Fix error code in ip_set_sockfn_get() when copy_to_user() fails,
   from Dan Carpenter.

3) Oneliner to copy MAC address in IPv6 hash:ip,mac sets, from
   Stefano Brivio.

4) Missing policy validation in ipset with NL_VALIDATE_STRICT,
   from Jozsef Kadlecsik.

5) Fix unaligned access to private data area of nf_tables instructions,
   from Lukas Wunner.

6) Relax check for object updates, reported as a regression by
   Eric Garver, patch from Fernando Fernandez Mancera.

7) Crash on ebtables dnat extension when used from the output path.
   From Florian Westphal.

8) Fix bogus EOPNOTSUPP when updating basechain flags.

9) Fix bogus EBUSY when updating a basechain that is already offloaded.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1204c70d9dcba31164f78ad5d8c88c42335d51f8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-11-01 17:48:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 774e4d34dbebc9dc441535c4712794d336a9478c:

  Merge branch 'master' of git://blackhole.kfki.hu/nf (2019-11-04 20:59:00 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Fernando Fernandez Mancera (1):
      netfilter: nf_tables: fix unexpected EOPNOTSUPP error

Florian Westphal (1):
      bridge: ebtables: don't crash when using dnat target in output chains

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Pablo Neira Ayuso (4):
      netfilter: nf_tables_offload: check for register data length mismatches
      netfilter: nf_tables: bogus EOPNOTSUPP on basechain update
      netfilter: nf_tables_offload: skip EBUSY on chain update
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Stefano Brivio (1):
      netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets

 include/net/netfilter/nf_tables.h        |  3 +-
 net/bridge/netfilter/ebt_dnat.c          | 19 ++++++++++---
 net/netfilter/ipset/ip_set_core.c        | 49 +++++++++++++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ipmac.c  |  2 +-
 net/netfilter/ipset/ip_set_hash_net.c    |  1 +
 net/netfilter/ipset/ip_set_hash_netnet.c |  1 +
 net/netfilter/nf_tables_api.c            |  7 ++---
 net/netfilter/nf_tables_offload.c        |  3 +-
 net/netfilter/nft_bitwise.c              |  5 ++--
 net/netfilter/nft_cmp.c                  |  2 +-
 10 files changed, 62 insertions(+), 30 deletions(-)
