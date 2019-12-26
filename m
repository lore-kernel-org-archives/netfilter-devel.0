Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678A1C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 16:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42BB32075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 16:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLZQkF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 11:40:05 -0500
Received: from correo.us.es ([193.147.175.20]:54732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfLZQkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 11:40:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A37C4E34E7
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2019 17:40:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96B9EDA711
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2019 17:40:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C663DA70F; Thu, 26 Dec 2019 17:40:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ED66DA707;
        Thu, 26 Dec 2019 17:39:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Dec 2019 17:39:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4DFE14251481;
        Thu, 26 Dec 2019 17:39:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/4] Netfilter fixes for net
Date:   Thu, 26 Dec 2019 17:39:52 +0100
Message-Id: <20191226163956.672174-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix endianness issue in flowtable TCP flags dissector,
   from Arnd Bergmann.

2) Extend flowtable test script with dnat rules, from Florian Westphal.

3) Reject padding in ebtables user entries and validate computed user
   offset, reported by syzbot, from Florian Westphal.

4) Fix endianness in nft_tproxy, from Phil Sutter.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 0fd260056ef84ede8f444c66a3820811691fe884:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2019-12-19 14:20:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8cb4ec44de42b99b92399b4d1daf3dc430ed0186:

  netfilter: nft_tproxy: Fix port selector on Big Endian (2019-12-20 02:12:28 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: nf_flow_table: fix big-endian integer overflow

Florian Westphal (2):
      selftests: netfilter: extend flowtable test script with dnat rule
      netfilter: ebtables: compat: reject all padding in matches/watchers

Phil Sutter (1):
      netfilter: nft_tproxy: Fix port selector on Big Endian

 net/bridge/netfilter/ebtables.c                    | 33 +++++++++---------
 net/netfilter/nf_flow_table_offload.c              |  2 +-
 net/netfilter/nft_tproxy.c                         |  4 +--
 tools/testing/selftests/netfilter/nft_flowtable.sh | 39 +++++++++++++++++++---
 4 files changed, 53 insertions(+), 25 deletions(-)
