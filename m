From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 0/2] netfilter: complete nft log flags support
Date: Sun, 25 Sep 2016 16:35:55 +0800
Message-ID: <1474792557-3349-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:55406 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935933AbcIYIgr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:36:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In iptables, user can specify log flags in LOG target, for exmaple:
  # iptables -A OUTPUT -j LOG --log-uid
  # iptables -A INPUT -j LOG --log-uid --log-tcp-sequence
  ...

But this is not supported in nft, because related NF_LOG_XXX is not
exposed to the userspace. So user cannot set the specific log flags
explicitly. Now, this problem is solved by patch #1.

The another issue is that nf_log is used by both nftables and iptables,
so use XT_LOG_XXX macros is not very appropriate, replaces them with
NF_LOG_XXX in patch #2.

Liping Zhang (2):
  netfilter: nft_log: complete NFTA_LOG_FLAGS attr support
  netfilter: nf_log: get rid of XT_LOG_XXX macros

 include/net/netfilter/nf_log.h        | 11 +++--------
 include/uapi/linux/netfilter/nf_log.h | 12 ++++++++++++
 net/bridge/netfilter/ebt_log.c        |  2 +-
 net/ipv4/netfilter/ip_tables.c        |  2 +-
 net/ipv4/netfilter/nf_log_arp.c       |  2 +-
 net/ipv4/netfilter/nf_log_ipv4.c      | 10 +++++-----
 net/ipv6/netfilter/ip6_tables.c       |  2 +-
 net/ipv6/netfilter/nf_log_ipv6.c      | 18 +++++++++---------
 net/netfilter/nf_log_common.c         |  4 ++--
 net/netfilter/nf_tables_core.c        |  2 +-
 net/netfilter/nft_log.c               |  9 ++++++++-
 11 files changed, 44 insertions(+), 30 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nf_log.h

-- 
2.5.5


