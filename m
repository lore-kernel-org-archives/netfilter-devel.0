From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 0/5] netfilter: nfnl_cthelper: fix some bugs
Date: Sun, 19 Mar 2017 22:35:57 +0800
Message-ID: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49341 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbdCSOgy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 10:36:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

This patch set aims to fix some bugs related to nfnetlink_cthelper.
They are:
1. if NFCTH_PRIV_DATA_LEN attr is empty, we cannot create a cthelper
   via nfnetlink
2. helper->expect_class_max is incorrect
3. when update cthelper via nfnetlink, memory leak will happen. It's
   ok to modify the nf_conntrack_expect_policy directly when do update,
   but drop the const qualifier is required
4. introduce a dummy list to fix a race when operate nfnl_cthelper

Note, the patch set is based on these three patches which have not
been applied or showed in nf picktree:
http://patchwork.ozlabs.org/patch/740302/
http://patchwork.ozlabs.org/patch/740300/
http://patchwork.ozlabs.org/patch/739509/

Liping Zhang (5):
  netfilter: nfnl_cthelper: don't report error if NFCTH_PRIV_DATA_LEN is
    empty
  netfilter: nfnl_cthelper: fix incorrect helper->expect_class_max
  netfilter: drop const qualifier from struct nf_conntrack_expect_policy
  netfilter: nfnl_cthelper: fix memory leak when do update
  netfilter: nfnl_cthelper: fix a race when walk the nf_ct_helper_hash
    table

 include/net/netfilter/nf_conntrack_helper.h |   4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c      |   2 +-
 net/netfilter/nf_conntrack_amanda.c         |   2 +-
 net/netfilter/nf_conntrack_expect.c         |   2 +-
 net/netfilter/nf_conntrack_ftp.c            |   2 +-
 net/netfilter/nf_conntrack_h323_main.c      |   6 +-
 net/netfilter/nf_conntrack_helper.c         |   2 +-
 net/netfilter/nf_conntrack_pptp.c           |   2 +-
 net/netfilter/nf_conntrack_sane.c           |   2 +-
 net/netfilter/nf_conntrack_sip.c            |   2 +-
 net/netfilter/nf_conntrack_tftp.c           |   2 +-
 net/netfilter/nfnetlink_cthelper.c          | 226 +++++++++++++++-------------
 12 files changed, 135 insertions(+), 119 deletions(-)

-- 
2.5.5


