From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset patches for nf
Date: Sat,  7 Nov 2015 13:42:22 +0100
Message-ID: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:40210 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbbKGMkt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 07:40:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next bugfixes against the nf tree.

- Fix extensions alignment in ipset: Gerhard Wiesinger reported
  that the missing data aligments lead to crash on non-intel
  architecture. The patch was tested on armv7h by Gerhard Wiesinger
  and on x86_64 and sparc64 by me.
- An incorrect index at the hash:* types could lead to
  falsely early expired entries and memory leak when the comment
  extension was used too.
- Release empty hash bucket block when all entries are expired or
  all slots are empty instead of shrinkig the data part to zero.

Best regards,
Jozsef

----
The following changes since commit 212cd0895330b775f2db49451f046a5ca4e5704b:

  selinux: fix random read in selinux_ip_postroute_compat() (2015-11-05 16:45:51 -0500)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to 0aae24eb409fc429f54ca3809f904f1b91e295e0:

  netfilter: ipset: Fix hash type expire: release empty hash bucket block (2015-11-07 11:28:49 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (3):
      netfilter: ipset: Fix extension alignment
      netfilter: ipset: Fix hash:* type expiration
      netfilter: ipset: Fix hash type expire: release empty hash bucket block

 include/linux/netfilter/ipset/ip_set.h    |  2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 17 +++++----------
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 14 ++++--------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 64 +++++++++++++++++++++++++-----------------------------
 net/netfilter/ipset/ip_set_bitmap_port.c  | 18 ++++++---------
 net/netfilter/ipset/ip_set_core.c         | 14 +++++++-----
 net/netfilter/ipset/ip_set_hash_gen.h     | 26 ++++++++++++++--------
 net/netfilter/ipset/ip_set_list_set.c     |  5 +++--
 8 files changed, 75 insertions(+), 85 deletions(-)
