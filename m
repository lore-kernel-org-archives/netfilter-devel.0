From: gfree.wind@foxmail.com
Subject: [PATCH nf v5 0/3] Refine the robust of helper expectfn
Date: Fri, 31 Mar 2017 18:38:18 +0800
Message-ID: <cover.1490955730.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:56732 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754213AbdCaKij (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 06:38:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

These patches are used to refine the codes of helper expectfn, and
enhance its robust, including fixing possible panic bug.

Gao Feng (3):
  netfilter: helper: Rename struct nf_ct_helper_expectfn to
    nf_ct_nat_helper
  netfilter: nat_helper: Make sure every proto nat module uses its
    nat_helper
  netfilter: nat_helper: Remove the expectations when its module is
    unloaded

 include/net/netfilter/nf_conntrack_expect.h |  5 +-
 include/net/netfilter/nf_conntrack_helper.h | 13 ++--
 net/ipv4/netfilter/nf_nat_h323.c            | 55 +++++++++++------
 net/netfilter/ipvs/ip_vs_nfct.c             |  8 ++-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_core.c           |  4 +-
 net/netfilter/nf_conntrack_expect.c         | 10 ++-
 net/netfilter/nf_conntrack_helper.c         | 94 +++++++++++++++++------------
 net/netfilter/nf_conntrack_netlink.c        | 20 +++---
 net/netfilter/nf_conntrack_pptp.c           | 15 ++++-
 net/netfilter/nf_nat_amanda.c               | 10 ++-
 net/netfilter/nf_nat_core.c                 |  7 ++-
 net/netfilter/nf_nat_ftp.c                  | 10 ++-
 net/netfilter/nf_nat_irc.c                  | 10 ++-
 net/netfilter/nf_nat_sip.c                  | 23 ++++---
 net/netfilter/nf_nat_tftp.c                 | 10 ++-
 16 files changed, 194 insertions(+), 102 deletions(-)

-- 
1.9.1




