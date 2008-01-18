From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 00/09]: Netfilter update + minor fixes
Date: Fri, 18 Jan 2008 17:55:47 +0100 (MET)
Message-ID: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42953 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbYARQzs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches restructure the libnl nfnetlink_log code as discussed earlier                    
by splitting it into two seperate object types, one to represent the log
instance and one for the actual messages. They also add support for
nfnetlink_queue, which follows the same pattern, and for basic conntrack
requests (add/delete/query).

Additionally they contains a few minor fixes that don't relate to netfilter,
but I had them queued in the same tree, so I've included them for simplicity.

Comments and/or applying welcome :)


 include/Makefile                          |    2 +
 include/linux/if_vlan.h                   |   61 ++++
 include/linux/netfilter.h                 |   39 +++
 include/linux/netfilter/nfnetlink_log.h   |    1 +
 include/linux/netfilter/nfnetlink_queue.h |   94 ++++++
 include/netlink-types.h                   |   78 ++++-
 include/netlink/netfilter/ct.h            |    9 +
 include/netlink/netfilter/log.h           |  110 ++++----
 include/netlink/netfilter/log_msg.h       |   98 ++++++
 include/netlink/netfilter/netfilter.h     |   31 ++
 include/netlink/netfilter/queue.h         |   86 +++++
 include/netlink/netfilter/queue_msg.h     |  101 ++++++
 lib/netfilter/ct.c                        |  153 +++++++++
 lib/netfilter/log.c                       |  325 +++++++-------------
 lib/netfilter/log_msg.c                   |  218 +++++++++++++
 lib/netfilter/log_msg_obj.c               |  456 +++++++++++++++++++++++++++
 lib/netfilter/log_obj.c                   |  420 +++++++++-----------------
 lib/netfilter/netfilter.c                 |   53 ++++
 lib/netfilter/queue.c                     |  233 ++++++++++++++
 lib/netfilter/queue_msg.c                 |  240 ++++++++++++++
 lib/netfilter/queue_msg_obj.c             |  480 +++++++++++++++++++++++++++++
 lib/netfilter/queue_obj.c                 |  213 +++++++++++++
 lib/route/route_utils.c                   |   10 +
 src/nf-log.c                              |   55 +++-
 src/{nf-log.c => nf-queue.c}              |   64 +++-
 25 files changed, 3038 insertions(+), 592 deletions(-)
 create mode 100644 include/linux/if_vlan.h
 create mode 100644 include/linux/netfilter.h
 create mode 100644 include/linux/netfilter/nfnetlink_queue.h
 create mode 100644 include/netlink/netfilter/log_msg.h
 create mode 100644 include/netlink/netfilter/netfilter.h
 create mode 100644 include/netlink/netfilter/queue.h
 create mode 100644 include/netlink/netfilter/queue_msg.h
 create mode 100644 lib/netfilter/log_msg.c
 create mode 100644 lib/netfilter/log_msg_obj.c
 create mode 100644 lib/netfilter/netfilter.c
 create mode 100644 lib/netfilter/queue.c
 create mode 100644 lib/netfilter/queue_msg.c
 create mode 100644 lib/netfilter/queue_msg_obj.c
 create mode 100644 lib/netfilter/queue_obj.c
 copy src/{nf-log.c => nf-queue.c} (63%)

Patrick McHardy (9):
      [LIBNL]: Add if_vlan.h
      [LIBNL]: Fix minor memleaks on exit
      [LIBNL]: Generic netfilter stuff
      [LIBNL]: Add nfnetlink_queue support
      [LIBNL]: nfnetlink_log: only set hwproto if not zero
      [LIBNL]: nfnetlink_log: support NUFLA_GID attribute
      [LIBNL]: Split up nfnetlink_log into log and msg objects
      [LIBNL]: Support conntrack add/delete/query requests
      [LIBNL]: Install netfilter headers
