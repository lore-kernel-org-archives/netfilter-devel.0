From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 0/3] ebtables compat layer
Date: Fri, 22 Aug 2014 11:29:12 +0200
Message-ID: <1408699755-17785-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37777 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHVJZe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:25:34 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so10395705wgh.32
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:25:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
the btables-compat is almost ready,
I've fixed the issues with flags, there are two small issues
to be fixed yet:

- rules with logical interfaces are not deleted
- when listing rule, the mask is printed when it's not set

The filter table is working properly except these issues,
that I'm going to fix in these days.

There is no support yet for nat and brouting,
I'm working on checksum expr.

I would know what you have in mind for these patches,
if you want to accept them when the issues are fixed
even if there is no nat support yet or or what else?

So I can organize the work to do.

There are still some extensions that have to be moved
to libxtables.

Thanks

Giuseppe Longo (3):
  xtables: bootstrap xtables-eb for nftables
  nft-shared: make compare_matches as public
  Operations for bridge family

 include/linux/netfilter/nf_tables.h         |    4 +
 include/linux/netfilter_bridge.h            |   33 +
 include/linux/netfilter_bridge/ebtables.h   |  276 +++++++
 include/linux/netfilter_bridge/ethernetdb.h |   58 ++
 iptables/Makefile.am                        |    6 +-
 iptables/getethertype.c                     |  161 ++++
 iptables/nft-bridge.c                       |  545 ++++++++++++
 iptables/nft-shared.c                       |   14 +-
 iptables/nft-shared.h                       |    3 +-
 iptables/nft.c                              |   28 +
 iptables/nft.h                              |   12 +
 iptables/xtables-compat-multi               |  210 +++++
 iptables/xtables-compat-multi.c             |    1 +
 iptables/xtables-eb-standalone.c            |   87 ++
 iptables/xtables-eb.c                       | 1186 +++++++++++++++++++++++++++
 iptables/xtables-ebtables.h                 |   49 ++
 iptables/xtables-multi.c                    |    1 +
 iptables/xtables-multi.h                    |    1 +
 18 files changed, 2667 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebtables.h
 create mode 100644 include/linux/netfilter_bridge/ethernetdb.h
 create mode 100644 iptables/getethertype.c
 create mode 100644 iptables/nft-bridge.c
 create mode 100755 iptables/xtables-compat-multi
 create mode 100644 iptables/xtables-eb-standalone.c
 create mode 100644 iptables/xtables-eb.c
 create mode 100644 iptables/xtables-ebtables.h

-- 
1.8.3.2

