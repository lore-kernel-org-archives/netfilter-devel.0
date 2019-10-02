Return-Path: <SRS0=1WdE=X3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83662C10F14
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Oct 2019 18:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6983321A4C
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Oct 2019 18:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfJBSxx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 14:53:53 -0400
Received: from correo.us.es ([193.147.175.20]:52758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBSxw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 14:53:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 41EFB15AEA6
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2019 20:53:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31F012DC95
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2019 20:53:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27A35CE39C; Wed,  2 Oct 2019 20:53:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11E10B7FF6;
        Wed,  2 Oct 2019 20:53:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Oct 2019 20:53:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DBB5C42EE38E;
        Wed,  2 Oct 2019 20:53:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter fixes for net
Date:   Wed,  2 Oct 2019 20:53:43 +0200
Message-Id: <20191002185345.3137-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Remove the skb_ext_del from nf_reset, and renames it to a more
   fitting nf_reset_ct(). Patch from Florian Westphal.

2) Fix deadlock in nft_connlimit between packet path updates and
   the garbage collector.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 9cfc370240c31c7f31f445e69190dd15be8e5d7d:

  Merge tag 'mac80211-for-davem-2019-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2019-10-01 09:28:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 34a4c95abd25ab41fb390b985a08a651b1fa0b0f:

  netfilter: nft_connlimit: disable bh on garbage collection (2019-10-01 18:42:15 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: drop bridge nf reset from nf_reset

Pablo Neira Ayuso (1):
      netfilter: nft_connlimit: disable bh on garbage collection

 drivers/net/ppp/pptp.c                | 4 ++--
 drivers/net/tun.c                     | 2 +-
 drivers/net/virtio_net.c              | 2 +-
 drivers/net/vrf.c                     | 8 ++++----
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 drivers/staging/octeon/ethernet-tx.c  | 6 ++----
 include/linux/skbuff.h                | 5 +----
 net/batman-adv/soft-interface.c       | 2 +-
 net/core/skbuff.c                     | 2 +-
 net/dccp/ipv4.c                       | 2 +-
 net/ipv4/ip_input.c                   | 2 +-
 net/ipv4/ipmr.c                       | 4 ++--
 net/ipv4/netfilter/nf_dup_ipv4.c      | 2 +-
 net/ipv4/raw.c                        | 2 +-
 net/ipv4/tcp_ipv4.c                   | 2 +-
 net/ipv4/udp.c                        | 4 ++--
 net/ipv6/ip6_input.c                  | 2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c      | 2 +-
 net/ipv6/raw.c                        | 2 +-
 net/l2tp/l2tp_core.c                  | 2 +-
 net/l2tp/l2tp_eth.c                   | 2 +-
 net/l2tp/l2tp_ip.c                    | 2 +-
 net/l2tp/l2tp_ip6.c                   | 2 +-
 net/netfilter/ipvs/ip_vs_xmit.c       | 2 +-
 net/netfilter/nft_connlimit.c         | 7 ++++++-
 net/openvswitch/vport-internal_dev.c  | 2 +-
 net/packet/af_packet.c                | 4 ++--
 net/sctp/input.c                      | 2 +-
 net/xfrm/xfrm_input.c                 | 2 +-
 net/xfrm/xfrm_interface.c             | 2 +-
 net/xfrm/xfrm_output.c                | 2 +-
 net/xfrm/xfrm_policy.c                | 2 +-
 32 files changed, 46 insertions(+), 46 deletions(-)
