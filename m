Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E39C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F547206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfL3LVv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:21:51 -0500
Received: from correo.us.es ([193.147.175.20]:59198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfL3LVv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7EDB54DE727
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 709F1DA713
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 66443DA711; Mon, 30 Dec 2019 12:21:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F0B4DA707;
        Mon, 30 Dec 2019 12:21:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D85CB41E4800;
        Mon, 30 Dec 2019 12:21:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/17] Netfilter updates for net-next
Date:   Mon, 30 Dec 2019 12:21:26 +0100
Message-Id: <20191230112143.121708-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Remove #ifdef pollution around nf_ingress(), from Lukas Wunner.

2) Document ingress hook in netdevice, also from Lukas.

3) Remove htons() in tunnel metadata port netlink attributes,
   from Xin Long.

4) Missing erspan netlink attribute validation also from Xin Long.

5) Missing erspan version in tunnel, from Xin Long.

6) Missing attribute nest in NFTA_TUNNEL_KEY_OPTS_{VXLAN,ERSPAN}
   Patch from Xin Long.

7) Missing nla_nest_cancel() in tunnel netlink dump path,
   from Xin Long.

8) Remove two exported conntrack symbols with no clients,
   from Florian Westphal.

9) Add nft_meta_get_eval_time() helper to nft_meta, from Florian.

10) Add nft_meta_pkttype helper for loopback, also from Florian.

11) Add nft_meta_socket uid helper, from Florian Westphal.

12) Add nft_meta_cgroup helper, from Florian.

13) Add nft_meta_ifkind helper, from Florian.

14) Group all interface related meta selector, from Florian.

15) Add nft_prandom_u32() helper, from Florian.

16) Add nft_meta_rtclassid helper, from Florian.

17) Add support for matching on the slave device index,
    from Florian.

This batch, among other things, contains updates for the netfilter
tunnel netlink interface: This extension is still incomplete and lacking
proper userspace support which is actually my fault, I did not find the
time to go back and finish this. This update is breaking tunnel UAPI in
some aspects to fix it but do it better sooner than never.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 6f6dded1385cfb564de85f86126f1c054c8f47b1:

  Merge branch 'WireGuard-CI-and-housekeeping' (2019-12-16 19:22:22 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to c14ceb0ec727187f71a487a592ffa91767fed66e:

  netfilter: nft_meta: add support for slave device ifindex matching (2019-12-26 17:41:34 +0100)

----------------------------------------------------------------
Florian Westphal (10):
      netfilter: conntrack: remove two export symbols
      netfilter: nft_meta: move time handling to helper
      netfilter: nft_meta: move pkttype handling to helper
      netfilter: nft_meta: move sk uid/git handling to helper
      netfilter: nft_meta: move cgroup handling to helper
      netfilter: nft_meta: move interface kind handling to helper
      netfilter: nft_meta: move all interface related keys to helper
      netfilter: nft_meta: place prandom handling in a helper
      netfilter: nft_meta: place rtclassid handling in a helper
      netfilter: nft_meta: add support for slave device ifindex matching

Lukas Wunner (2):
      netfilter: Clean up unnecessary #ifdef
      netfilter: Document ingress hook

Xin Long (5):
      netfilter: nft_tunnel: no need to call htons() when dumping ports
      netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy
      netfilter: nft_tunnel: also dump ERSPAN_VERSION
      netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
      netfilter: nft_tunnel: add the missing nla_nest_cancel()

 include/linux/netdevice.h                |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/core/dev.c                           |   2 -
 net/netfilter/nf_conntrack_core.c        |   1 -
 net/netfilter/nf_conntrack_extend.c      |   1 -
 net/netfilter/nft_meta.c                 | 440 ++++++++++++++++++++++---------
 net/netfilter/nft_tunnel.c               |  52 +++-
 7 files changed, 357 insertions(+), 144 deletions(-)
