From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V2 0/2] netfilter: reject cthelper del request if it is in use
Date: Sun,  7 May 2017 22:01:54 +0800
Message-ID: <20170507140156.16487-1-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:37951 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755003AbdEGVsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2017 17:48:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

User can still delete the cthelper even if it is in use:
  # nfct helper add ssdp inet udp
  # iptables -t raw -A OUTPUT -p udp -j CT --helper ssdp
  # nfct helper delete ssdp //--> succeed!

This will cause a use-after-free error. So we should add a refcnt to
fix this issue. Before accomplishing this, it's better to introduce a
nf_conntrack_helper_put helper function, this is done by PATCH #1.

Liping Zhang (2):
  netfilter: introduce nf_conntrack_helper_put helper function
  netfilter: nfnl_cthelper: reject del request if helper obj is in use

 include/net/netfilter/nf_conntrack_helper.h |  4 ++++
 net/netfilter/nf_conntrack_helper.c         | 12 ++++++++++++
 net/netfilter/nfnetlink_cthelper.c          | 17 +++++++++++------
 net/netfilter/nft_ct.c                      |  4 ++--
 net/netfilter/xt_CT.c                       |  6 +++---
 net/openvswitch/conntrack.c                 |  4 ++--
 6 files changed, 34 insertions(+), 13 deletions(-)

-- 
2.9.3


