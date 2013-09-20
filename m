From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 0/7] Add new comments extension to ipset.
Date: Fri, 20 Sep 2013 10:30:18 +0200
Message-ID: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:45062 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3ITIbC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:31:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 8EE5EA3409
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:30:55 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id CPotOZlWxUVf for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:30:26 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Another re-roll, with requested changes applied. I've also made the allocation
code a bit more robust by having it fall back to vmalloc should kmalloc fail to
do the oh-so-needful. Additionally, the documentation was somewhat lacking
(rather, non-existent) so I've corrected that too.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Oliver Smith (7):
  netfilter: ipset: Support comments for ipset entries in the core.
  netfilter: ipset: Support comments in hash-type ipsets.
  netfilter: ipset: Support comments in bitmap-type ipsets.
  netfilter: ipset: Support comments in the list-type ipset.
  ipset: Rework the "fake" argument parsing for ipset restore.
  ipset: Support comments in the userspace library.
  ipset: Add new userspace set revisions for comment support

 Make_global.am                                     |   2 +-
 include/libipset/data.h                            |   6 +-
 include/libipset/linux_ip_set.h                    |  15 ++
 include/libipset/parse.h                           |   2 +
 include/libipset/print.h                           |   3 +
 kernel/include/linux/netfilter/ipset/ip_set.h      |  32 +++-
 .../include/linux/netfilter/ipset/ip_set_comment.h |  65 +++++++
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   7 +
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  18 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |   3 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |   3 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |   3 +-
 kernel/net/netfilter/ipset/ip_set_core.c           |  14 ++
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |  18 +-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |   3 +-
 kernel/net/netfilter/ipset/ip_set_list_set.c       |  22 ++-
 lib/data.c                                         |  34 ++++
 lib/debug.c                                        |   1 +
 lib/errcode.c                                      |   2 +
 lib/ipset_bitmap_ip.c                              | 114 ++++++++++++
 lib/ipset_bitmap_ipmac.c                           | 118 +++++++++++++
 lib/ipset_bitmap_port.c                            | 107 +++++++++++
 lib/ipset_hash_ip.c                                | 138 +++++++++++++++
 lib/ipset_hash_ipport.c                            | 161 +++++++++++++++++
 lib/ipset_hash_ipportnet.c                         | 195 +++++++++++++++++++++
 lib/ipset_hash_net.c                               | 145 +++++++++++++++
 lib/ipset_hash_netnet.c                            |  14 +-
 lib/ipset_hash_netport.c                           | 158 +++++++++++++++++
 lib/ipset_list_set.c                               | 108 ++++++++++++
 lib/libipset.map                                   |   7 +
 lib/parse.c                                        |  27 +++
 lib/print.c                                        |  31 ++++
 lib/session.c                                      |   8 +-
 lib/types.c                                        |   4 +-
 src/ipset.8                                        |  59 ++++---
 src/ipset.c                                        |  54 +++++-
 42 files changed, 1649 insertions(+), 70 deletions(-)
 create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h

-- 
1.8.3.2

