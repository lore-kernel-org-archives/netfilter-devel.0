From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v4 0/2] ipset: add "inner" flag version support
Date: Fri, 05 Jul 2013 23:23:46 +0100
Message-ID: <51D74772.7000906@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:53637 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3GEWXz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:23:55 -0400
Received: by mail-we0-f179.google.com with SMTP id w59so2260958wes.24
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 15:23:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of 2 patches supplements the previous version (v3) and adds
"inner" flag version support to all registered ipset types
(kernel + userspace).

Dash Four (2):
   ipset: add set match "inner" flag support
   ipset (userspace): add "inner" flag version support

  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      | 10 ++-
  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   | 10 ++-
  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  4 +-
  kernel/net/netfilter/ipset/ip_set_hash_ip.c        | 13 +++-
  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    | 19 +++--
  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  | 25 ++++---
  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c | 29 +++++---
  kernel/net/netfilter/ipset/ip_set_hash_net.c       | 13 +++-
  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  | 13 +++-
  kernel/net/netfilter/ipset/ip_set_hash_netport.c   | 24 +++---
  lib/ipset_bitmap_ip.c                              | 45 ++++++++++++
  lib/ipset_bitmap_ipmac.c                           | 51 +++++++++++++
  lib/ipset_bitmap_port.c                            | 44 +++++++++++
  lib/ipset_hash_ip.c                                | 44 +++++++++++
  lib/ipset_hash_ipport.c                            | 63 ++++++++++++++++
  lib/ipset_hash_ipportip.c                          | 74 +++++++++++++++++++
  lib/ipset_hash_ipportnet.c                         | 84 +++++++++++++++++++++
  lib/ipset_hash_net.c                               | 49 +++++++++++++
  lib/ipset_hash_netiface.c                          | 64 ++++++++++++++++
  lib/ipset_hash_netport.c                           | 69 ++++++++++++++++++
  20 files changed, 694 insertions(+), 53 deletions(-)
