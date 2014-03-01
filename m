From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v3 0/2] ipset: forceadd support
Date: Fri, 28 Feb 2014 22:14:56 -0500
Message-ID: <1393643698-6603-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:64818 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbaCADPA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:15:00 -0500
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

Since v2:

- Set LIBVERSION to 6.0.4
- Fix leading whitespace
- Add-in changes to include/libipset/linux_ip_set.h
- Use first bit in ipset_create_flags

Since v1:

- Address Jozsef's comments in v1
- Remove forceadd attribute and corresponding code
- Utilize new create option flags field
- Bump LIBVERSION

Josh Hunt (2):
  ipset: add forceadd kernel support for hash set types
  ipset: add userspace support for forceadd

 Make_global.am                                     |    2 +-
 include/libipset/data.h                            |    4 +-
 include/libipset/linux_ip_set.h                    |    7 +-
 kernel/include/linux/netfilter/ipset/ip_set.h      |    3 +
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    7 +-
 kernel/net/netfilter/ipset/ip_set_core.c           |    2 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   12 ++
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    2 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |    2 +-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |    3 +-
 .../net/netfilter/ipset/ip_set_hash_netportnet.c   |    3 +-
 lib/data.c                                         |    5 +
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
 src/ipset.8                                        |    7 +
 29 files changed, 1450 insertions(+), 16 deletions(-)

-- 
1.7.9.5

