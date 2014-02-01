From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/2] ipset: forceadd support
Date: Sat,  1 Feb 2014 05:30:50 -0800
Message-ID: <1391261452-11266-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:51609 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbaBANkD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Feb 2014 08:40:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Forceadd is a property for hash set types and is passed in duration creation.
When sets with this property enabled are full each subsequent 'add' operation
will attempt to evict a random entry from the set. The implementation tries to
keep the overhead low by checking to see which bucket the new entry hashes to.
If that bucket has any entries it will evict the first one and add the new
entry.

Ex usage:
ipset create foo hash:ip forceadd

The intended usecase is for things like 'ban' lists where you may not be concerned
with possibly evicting something early, and more concerned with the size of
the hash itself.


Josh Hunt (2):
  ipset: add forceadd kernel support for hash set types
  ipset: add forceadd userspace support for hash set types

 include/libipset/data.h                            |    4 +-
 include/libipset/linux_ip_set.h                    |    1 +
 include/libipset/parse.h                           |    3 +
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    1 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   26 +++-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |    4 +-
 .../net/netfilter/ipset/ip_set_hash_netportnet.c   |    4 +-
 lib/data.c                                         |    8 +
 lib/debug.c                                        |    1 +
 lib/ipset_hash_ip.c                                |  123 ++++++++++++++
 lib/ipset_hash_ipmark.c                            |  142 ++++++++++++++++
 lib/ipset_hash_ipport.c                            |  147 +++++++++++++++++
 lib/ipset_hash_ipportip.c                          |  158 ++++++++++++++++++
 lib/ipset_hash_ipportnet.c                         |  169 ++++++++++++++++++++
 lib/ipset_hash_net.c                               |  119 ++++++++++++++
 lib/ipset_hash_netiface.c                          |  125 +++++++++++++++
 lib/ipset_hash_netnet.c                            |  125 +++++++++++++++
 lib/ipset_hash_netport.c                           |  132 +++++++++++++++
 lib/ipset_hash_netportnet.c                        |  149 +++++++++++++++++
 lib/parse.c                                        |   21 +++
 lib/print.c                                        |    4 +
 lib/session.c                                      |    4 +
 src/ipset.8                                        |    7 +
 31 files changed, 1494 insertions(+), 13 deletions(-)

