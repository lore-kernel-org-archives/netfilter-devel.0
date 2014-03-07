From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables 0/3] ebtables patchset
Date: Fri,  7 Mar 2014 20:33:22 +0100
Message-ID: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36900 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaCGTcm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:32:42 -0500
Received: by mail-ea0-f169.google.com with SMTP id h14so2560760eaj.28
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 11:32:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
I reworked the patchset.

The basic operations (-A/-I/-L/-D) are working,
see the examples below:

ebtables-compat -A INPUT -i eth0 -j ACCEPT
ebtables-compat -A INPUT -p arp -s 11:22:33:44:55:66 -j ACCEPT
ebtables-compat -A INPUT -p arp -d 11:22:33:44:55:66 -j ACCEPT
ebtables-compat -L --Ln

Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1 -i eth0 -j ACCEPT
2 -p ARP -s 11:22:33:44:55:66/0:0:0:0:0:0 -j ACCEPT
3 -p ARP -d 11:22:33:44:55:66/0:0:0:0:0:0 -j ACCEPT

ebtables-compat -D INPUT 2:3
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination
1 -i eth0 -j ACCEPT

As you can see, a minor issue have to be fixed when printing rules.
I have no idea how to handle --logical-in/out interfaces currently,
so please let me know if you have an idea or an advice.

Giuseppe Longo (3):
  xtables: bootstrap xtables-eb for nftables
  Operations for bridge family
  nft-shared: make compare_matches as public

 include/linux/netfilter_bridge.h            |   33 +
 include/linux/netfilter_bridge/ebtables.h   |  276 +++++++
 include/linux/netfilter_bridge/ethernetdb.h |   58 ++
 iptables/Makefile.am                        |    4 +-
 iptables/getethertype.c                     |  161 ++++
 iptables/nft-bridge.c                       |  439 ++++++++++
 iptables/nft-shared.c                       |    7 +-
 iptables/nft-shared.h                       |    1 +
 iptables/nft.c                              |   28 +
 iptables/nft.h                              |   12 +
 iptables/xtables-compat-multi.c             |    1 +
 iptables/xtables-eb-standalone.c            |   87 ++
 iptables/xtables-eb.c                       | 1164 +++++++++++++++++++++++++++
 iptables/xtables-ebtables.h                 |   49 ++
 iptables/xtables-multi.c                    |    1 +
 iptables/xtables-multi.h                    |    1 +
 16 files changed, 2319 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebtables.h
 create mode 100644 include/linux/netfilter_bridge/ethernetdb.h
 create mode 100644 iptables/getethertype.c
 create mode 100644 iptables/nft-bridge.c
 create mode 100644 iptables/xtables-eb-standalone.c
 create mode 100644 iptables/xtables-eb.c
 create mode 100644 iptables/xtables-ebtables.h

-- 
1.8.3.2

