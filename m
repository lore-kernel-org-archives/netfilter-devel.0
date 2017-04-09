From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 0/2] netfilter: reject cthelper del request if it is in use
Date: Sun,  9 Apr 2017 16:22:12 +0800
Message-ID: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:43422 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbdDIIXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Apr 2017 04:23:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

User can still delete the cthelper even if it is in use:
  # nfct helper add ssdp inet udp
  # iptables -t raw -A OUTPUT -p udp -j CT --helper ssdp
  # nfct helper delete ssdp //--> succeed!

This will cause a use-after-free error. So we shoule add a refcnt to
fix this issue. Before accomplishing this, it's better to introduce a
nf_conntrack_helper_put helper function.

Note, this patch set is based on http://patchwork.ozlabs.org/patch/748533/.
But I think it may still conflict with other patches. If so, I can rebase it.

Liping Zhang (2):
  netfilter: introduce nf_conntrack_helper_put helper function
  netfilter: nfnl_cthelper: reject del request if helper obj is in use

 include/net/netfilter/nf_conntrack_helper.h |  4 ++++
 net/netfilter/nf_conntrack_helper.c         | 12 ++++++++++++
 net/netfilter/nfnetlink_cthelper.c          | 17 +++++++++++------
 net/netfilter/xt_CT.c                       |  6 +++---
 net/openvswitch/conntrack.c                 |  4 ++--
 5 files changed, 32 insertions(+), 11 deletions(-)

-- 
2.5.5


