Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530A3C64EC4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 09:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjBVJVv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 04:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjBVJVq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 04:21:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FD8137F02;
        Wed, 22 Feb 2023 01:21:42 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/8] Netfilterf fixes for net
Date:   Wed, 22 Feb 2023 10:21:29 +0100
Message-Id: <20230222092137.88637-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix broken listing of set elements when table has an owner.

2) Fix conntrack refcount leak in ctnetlink with related conntrack
   entries, from Hangyu Hua.

3) Fix use-after-free/double-free in ctnetlink conntrack insert path,
   from Florian Westphal.

4) Fix ip6t_rpfilter with VRF, from Phil Sutter.

5) Fix use-after-free in ebtables reported by syzbot, also from Florian.

6) Use skb->len in xt_length to deal with IPv6 jumbo packets,
   from Xin Long.

7) Fix NETLINK_LISTEN_ALL_NSID with ctnetlink, from Florian Westphal.

8) Fix memleak in {ip_,ip6_,arp_}tables in ENOMEM error case,
   from Pavel Tikhomirov.

The fixes address broken stuff for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit bbb253b206b9c417928a6c827d038e457f3012e9:

  selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive (2023-02-07 12:20:21 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 0af8c09c896810879387decfba8c942994bb61f5:

  netfilter: x_tables: fix percpu counter block leak on error path when creating new netns (2023-02-22 10:11:27 +0100)

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: conntrack: fix rmmod double-free race
      netfilter: ebtables: fix table blob use-after-free
      netfilter: ctnetlink: make event listener tracking global

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Pablo Neira Ayuso (1):
      netfilter: nf_tables: allow to fetch set elements when table has an owner

Pavel Tikhomirov (1):
      netfilter: x_tables: fix percpu counter block leak on error path when creating new netns

Phil Sutter (1):
      netfilter: ip6t_rpfilter: Fix regression with VRF interfaces

Xin Long (1):
      netfilter: xt_length: use skb len to match in length_mt6

 include/linux/netfilter.h                  |  5 +++++
 include/net/netns/conntrack.h              |  1 -
 net/bridge/netfilter/ebtables.c            |  2 +-
 net/ipv4/netfilter/arp_tables.c            |  4 ++++
 net/ipv4/netfilter/ip_tables.c             |  7 +++++--
 net/ipv6/netfilter/ip6_tables.c            |  7 +++++--
 net/ipv6/netfilter/ip6t_rpfilter.c         |  4 +++-
 net/netfilter/core.c                       |  3 +++
 net/netfilter/nf_conntrack_bpf.c           |  1 -
 net/netfilter/nf_conntrack_core.c          | 25 +++++++++++++----------
 net/netfilter/nf_conntrack_ecache.c        |  2 +-
 net/netfilter/nf_conntrack_netlink.c       |  8 ++++----
 net/netfilter/nf_tables_api.c              |  2 +-
 net/netfilter/nfnetlink.c                  |  9 +++++----
 net/netfilter/xt_length.c                  |  3 +--
 tools/testing/selftests/netfilter/rpath.sh | 32 ++++++++++++++++++++++++------
 16 files changed, 79 insertions(+), 36 deletions(-)
