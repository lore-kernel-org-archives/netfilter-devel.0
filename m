Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1621C388F7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A81D21734
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgKDOMB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 09:12:01 -0500
Received: from correo.us.es ([193.147.175.20]:35718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgKDOMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46BE3B60C8
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 15:11:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EE8CDA797
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 15:11:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A21BDA793; Wed,  4 Nov 2020 15:11:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA036DA78A;
        Wed,  4 Nov 2020 15:11:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:11:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AE06942EF9E0;
        Wed,  4 Nov 2020 15:11:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/8] Netfilter updates for net-next
Date:   Wed,  4 Nov 2020 15:11:41 +0100
Message-Id: <20201104141149.30082-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Move existing bridge packet reject infra to nf_reject_{ipv4,ipv6}.c
   from Jose M. Guisado.

2) Consolidate nft_reject_inet initialization and dump, also from Jose.

3) Add the netdev reject action, from Jose.

4) Allow to combine the exist flag and the destroy command in ipset,
   from Joszef Kadlecsik.

5) Expose bucket size parameter for hashtables, also from Jozsef.

6) Expose the init value for reproducible ipset listings, from Jozsef.

7) Use __printf attribute in nft_request_module, from Andrew Lunn.

8) Allow to use reject from the inet ingress chain.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 37d38ece9b898ea183db9e5a6582651e6ed64c9a:

  net/mac8390: discard unnecessary breaks (2020-10-29 19:03:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 117ca1f8920cf4087bf82f44bd2a51b49d6aae63:

  netfilter: nft_reject_inet: allow to use reject from inet ingress (2020-11-01 12:52:17 +0100)

----------------------------------------------------------------
Andrew Lunn (1):
      netfilter: nftables: Add __printf() attribute

Jose M. Guisado Gomez (3):
      netfilter: nf_reject: add reject skbuff creation helpers
      netfilter: nft_reject: unify reject init and dump into nft_reject
      netfilter: nft_reject: add reject verdict support for netdev

Jozsef Kadlecsik (3):
      netfilter: ipset: Support the -exist flag with the destroy command
      netfilter: ipset: Add bucketsize parameter to all hash types
      netfilter: ipset: Expose the initval hash parameter to userspace

Pablo Neira Ayuso (1):
      netfilter: nft_reject_inet: allow to use reject from inet ingress

 include/linux/netfilter/ipset/ip_set.h       |   5 +
 include/net/netfilter/ipv4/nf_reject.h       |  10 ++
 include/net/netfilter/ipv6/nf_reject.h       |   9 +
 include/uapi/linux/netfilter/ipset/ip_set.h  |   6 +-
 net/bridge/netfilter/Kconfig                 |   2 +-
 net/bridge/netfilter/nft_reject_bridge.c     | 255 +--------------------------
 net/ipv4/netfilter/nf_reject_ipv4.c          | 128 +++++++++++++-
 net/ipv6/netfilter/nf_reject_ipv6.c          | 139 ++++++++++++++-
 net/netfilter/Kconfig                        |  10 ++
 net/netfilter/Makefile                       |   1 +
 net/netfilter/ipset/ip_set_core.c            |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h        |  45 +++--
 net/netfilter/ipset/ip_set_hash_ip.c         |   7 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |   6 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |   7 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |   7 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   7 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   7 +-
 net/netfilter/ipset/ip_set_hash_mac.c        |   6 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   7 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   7 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |   7 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   7 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |   7 +-
 net/netfilter/nf_tables_api.c                |   3 +-
 net/netfilter/nft_reject.c                   |  12 +-
 net/netfilter/nft_reject_inet.c              |  68 ++-----
 net/netfilter/nft_reject_netdev.c            | 189 ++++++++++++++++++++
 28 files changed, 615 insertions(+), 355 deletions(-)
 create mode 100644 net/netfilter/nft_reject_netdev.c
