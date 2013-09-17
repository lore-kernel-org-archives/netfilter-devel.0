From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 0/6] Add new comments extension to ipset.
Date: Tue, 17 Sep 2013 15:13:19 +0200
Message-ID: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60521 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3IQNON (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:14:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 8E550A3232
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 14:14:09 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id vBvrtMMMdUjA for <netfilter-devel@vger.kernel.org>;
	Tue, 17 Sep 2013 14:13:26 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This patch series adds support for a comments extensions on all ipset types via
the new extensions handling code implemented recently. A few small changes have
been made to the destroy code to make it usable in a generic manner as well as
relocating it within the header to enable it to compile (the set struct needed
to be completely defined in order to actually check whether to do cleanup).

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Oliver Smith (6):
  netfilter: ipset: Support comments for ipset entries in the core.
  netfilter: ipset: Support comments in hash-type ipsets.
  netfilter: ipset: Support comments in bitmap-type ipsets.
  ipset: Rework the "fake" argument parsing for ipset restore.
  ipset: Support comments in the userspace library.
  ipset: Add new userspace set revisions for comment support

 Make_global.am                                     |   2 +-
 include/libipset/data.h                            |   6 +-
 include/libipset/linux_ip_set.h                    |   7 +
 include/libipset/parse.h                           |   2 +
 include/libipset/print.h                           |   3 +
 kernel/include/linux/netfilter/ipset/ip_set.h      |  40 ++++-
 .../include/linux/netfilter/ipset/ip_set_comment.h |  54 ++++++
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   4 +
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  10 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |   3 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |   3 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |   3 +-
 kernel/net/netfilter/ipset/ip_set_core.c           |  14 ++
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |  10 +-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |   3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |   3 +-
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
 lib/libipset.map                                   |   6 +
 lib/parse.c                                        |  27 +++
 lib/print.c                                        |  31 ++++
 lib/session.c                                      |   8 +-
 lib/types.c                                        |   4 +-
 src/ipset.c                                        |  40 ++++-
 39 files changed, 1451 insertions(+), 34 deletions(-)
 create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h

-- 
1.8.3.2

