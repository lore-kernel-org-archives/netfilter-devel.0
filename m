From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/4] netfilter: ipset: Extend netmask support for kernel
Date: Tue, 21 Mar 2017 14:29:00 -0400
Message-ID: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41440 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758011AbdCUSfD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:35:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently netmasks at set creation, for those sets which have support for it, are
limited to cidr values. This patch set extends that to also allow for
conventional netmask values and wildcard masks. We have found numerous
uses for wildcard masks and have this support deployed on our network.

This set adds this new netmask support to the ipset hash type infrastructure
and enables it for hash:ip and hash:ip,port set types. I plan to extend it
to other set types in the future.

These changes are only the kernel side. I will send a separate set for
userspace.

Josh Hunt (4):
  net: netfilter: add nf_inet_addr_mask_inplace helper fn
  netfilter: ipset: generalize netmask to support cidr and mask values
  netfilter: ipset: hash:ip: add support for new netmask types
  netfilter: ipset: hash:ipport: add netmask support

 include/linux/netfilter.h                   |  9 +++
 include/linux/netfilter/ipset/ip_set.h      |  3 +
 include/uapi/linux/netfilter/ipset/ip_set.h |  5 ++
 net/netfilter/ipset/ip_set_core.c           |  2 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 91 +++++++++++++++++++++++++----
 net/netfilter/ipset/ip_set_hash_ip.c        | 20 ++++---
 net/netfilter/ipset/ip_set_hash_ipport.c    | 29 ++++++++-
 7 files changed, 137 insertions(+), 22 deletions(-)

-- 
1.9.1

