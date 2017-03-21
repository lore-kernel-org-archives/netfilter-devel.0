From: fgao@ikuai8.com
Subject: [PATCH nf v3 0/2] Fix invoking expectfn unloaded
Date: Tue, 21 Mar 2017 14:06:24 +0800
Message-ID: <cover.1490060879.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree_wind@126.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgjp3.qq.com ([54.92.39.34]:56285 "EHLO smtpbgjp3.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752036AbdCUGHx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 02:07:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

It is possible that invoke one expectfn whose module is already unloaded.
These two patches are used to fix it.

Gao Feng (2):
  netfilter: helper: Rename struct nf_ct_helper_expectfn to
    nf_ct_nat_helper
  netfilter: helper: Fix possible panic caused by invoking expectfn
    unloaded

 include/net/netfilter/nf_conntrack_expect.h |  2 +
 include/net/netfilter/nf_conntrack_helper.h | 15 ++---
 net/ipv4/netfilter/nf_nat_h323.c            | 14 +++--
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_expect.c         |  1 +
 net/netfilter/nf_conntrack_helper.c         | 95 +++++++++++++++++------------
 net/netfilter/nf_conntrack_netlink.c        | 21 ++++---
 net/netfilter/nf_nat_core.c                 |  7 ++-
 net/netfilter/nf_nat_sip.c                  |  7 ++-
 9 files changed, 95 insertions(+), 68 deletions(-)

-- 
1.9.1




