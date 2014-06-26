From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [linux PATCH 0/5] NAT updates for nf_tables.
Date: Thu, 26 Jun 2014 14:19:49 +0200
Message-ID: <20140626121823.3985.22905.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42647 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757016AbaFZMT7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:19:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements some updates for NAT in nf_tables.

First of all, I add a new flag attribute to allow clients of nft_nat to
specify additional config flags. This enables implementing port randomization
and persistence to be set from nft.

Two patches split the masquerade code from ip[6]t_MASQUERADE.c to generic
modules, so we can use this NAT type from nft_nat.

Then, the nft_nat code is splitted in AF specific parts, so we avoid potential
dependencies regarding AF specific symbols in the last patch.

The last patch finally implements masquerade for nft_nat.

Please, note that this series applies on top of a patch by Pablo:
 netfilter: nft_nat: don't dump port information if unset
 (http://patchwork.ozlabs.org/patch/361400/)

Comments are welcomed.
---

Arturo Borrero Gonzalez (5):
      netfilter: nft_nat: include a flag attribute
      netfilter: nf_nat_masquerade_ipv4: code factorization
      netfilter: nf_nat_masquerade_ipv6: code factorization
      netfilter: nft_nat: split code in AF parts
      netfilter: nft_nat: add masquerade support


 .../net/netfilter/ipv4/nf_nat_masquerade_ipv4.h    |   14 ++
 .../net/netfilter/ipv6/nf_nat_masquerade_ipv6.h    |   10 +
 include/net/netfilter/nft_nat.h                    |   20 ++
 include/uapi/linux/netfilter/nf_tables.h           |    7 +
 net/ipv4/netfilter/Kconfig                         |   14 ++
 net/ipv4/netfilter/Makefile                        |    2 
 net/ipv4/netfilter/ipt_MASQUERADE.c                |  108 +------------
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        |  155 +++++++++++++++++++
 net/ipv4/netfilter/nft_nat_ipv4.c                  |  164 ++++++++++++++++++++
 net/ipv6/netfilter/Kconfig                         |   14 ++
 net/ipv6/netfilter/Makefile                        |    2 
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |   76 +--------
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        |  121 ++++++++++++++
 net/ipv6/netfilter/nft_nat_ipv6.c                  |  163 ++++++++++++++++++++
 net/netfilter/nft_nat.c                            |  167 +++-----------------
 15 files changed, 725 insertions(+), 312 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nf_nat_masquerade_ipv4.h
 create mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade_ipv6.h
 create mode 100644 include/net/netfilter/nft_nat.h
 create mode 100644 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
 create mode 100644 net/ipv4/netfilter/nft_nat_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
 create mode 100644 net/ipv6/netfilter/nft_nat_ipv6.c

-- 
Arturo Borrero Gonzalez
