From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/2] modularize br_netfilter
Date: Mon, 22 Sep 2014 14:16:38 +0200
Message-ID: <1411388201-12124-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaIVMPl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:15:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm posting this series to take over the discussion on br_netfilter that
Florian triggered with his initial patch.

At this moment, I see two possibilities:

1) Add glue code to make br_netfilter look like it is still available from
   the bridge core and spot a warning to announce deprecation in two years
   or so.

2) Modularize br_netfilter so users can control if this feature is
   enabled/disabled through modprobe/rmmod.

Regarding 1), Patrick suggested that users may overlook the warning message
and things will break after that time.

On top of that I'm not sure anymore it is worth the effort to work on 1), given
that the design problems and limitations of br_netfilter. We cannot obviously
get rid of br_netfilter, but we can fence it and let users easily undo the
damage by including 'modprobe br_netfilter' in their scripts if they really
need it.

Let me know, thanks.

Pablo Neira Ayuso (2):
  netfilter: bridge: nf_bridge_copy_header as static inline in header
  netfilter: move br_netfilter out of the bridge core

 include/linux/netfilter_bridge.h       |   50 +++++++++++---
 include/linux/skbuff.h                 |   12 ++--
 include/net/neighbour.h                |    2 +-
 include/net/netfilter/ipv4/nf_reject.h |    2 +-
 include/net/netfilter/ipv6/nf_reject.h |    2 +-
 net/Kconfig                            |    2 +-
 net/bridge/Makefile                    |    5 +-
 net/bridge/br.c                        |   14 ++--
 net/bridge/br_device.c                 |    4 +-
 net/bridge/br_forward.c                |    2 +
 net/bridge/br_input.c                  |    1 +
 net/bridge/br_netfilter.c              |  116 +++++---------------------------
 net/bridge/br_netlink.c                |    2 +-
 net/bridge/br_nf_core.c                |   96 ++++++++++++++++++++++++++
 net/bridge/br_private.h                |   12 ++--
 net/bridge/br_sysfs_br.c               |    4 +-
 16 files changed, 186 insertions(+), 140 deletions(-)
 create mode 100644 net/bridge/br_nf_core.c

-- 
1.7.10.4

