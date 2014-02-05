From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 0/2] xtables-eb for the compatibility layer
Date: Wed,  5 Feb 2014 19:17:57 +0100
Message-ID: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:46508 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaBESSb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:18:31 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so342088eaj.17
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2014 10:18:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
this patchset implements ebtables for the nftables compatibility layer.
I would explain some points:

- The code is not built with the gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.3, pie-0.5.5):
xtables_multi-nft-bridge.o:/home/giuseppe/git/iptables-nftables/iptables/nft-bridge.c:53: first defined here
xtables_multi-nft-bridge.o: In function `nft_rule_to_xtables_ebt_entry':
/home/giuseppe/git/iptables-nftables/iptables/nft-bridge.c:226: multiple definition of `nft_rule_to_xtables_ebt_entry'
xtables_multi-nft-bridge.o:/home/giuseppe/git/iptables-nftables/iptables/nft-bridge.c:226: first defined here
xtables_multi-nft-bridge.o:(.data+0x0): multiple definition of `nft_family_ops_bridge'
xtables_multi-nft-bridge.o:(.data+0x0): first defined here
collect2: error: ld returned 1 exit status

but, with the gcc version 4.8.2 (Debian 4.8.2-1) (on my vm) it works fine.
I didn't figure out the reason, honestly.

- I didn't figure out how to replace some parts of codes, for istance:
  from xtables-eb.c, line 928:
  t = (struct ebt_u_target *)new_entry->t;
  if ((t->parse(c - t->option_offset, argv, argc, new_entry, &t->flags, &t->t))) {
	  if (ebt_errormsg[0] != '\0')
		  return -1;
	  goto check_extension;
  }

  /* Is it a match_option? */
  for (m = ebt_matches; m; m = m->next)
	  if (m->parse(c - m->option_offset, argv, argc, new_entry, &m->flags, &m->m))
		  break;

  if (m != NULL) {
	  if (ebt_errormsg[0] != '\0')
		  return -1;
	  if (m->used == 0) {
		  ebt_add_match(new_entry, m);
		  m->used = 1;
	  }
	  goto check_extension;
  }
  
Looking at extensions, I noticed that any xtables_match/xtables_target have parse functions. Maybe I'm wrong.
Even the code from line 992 is not very clear, about final checks. I don't know if I can remove this part of code.

Thanks

Giuseppe Longo (2):
  xtables: bootstrap xtables-eb for nftables
  Operations for bridge family

 include/linux/netfilter_bridge.h            |   33 +
 include/linux/netfilter_bridge/ebtables.h   |  276 +++++++
 include/linux/netfilter_bridge/ethernetdb.h |   58 ++
 iptables/Makefile.am                        |    8 +-
 iptables/getethertype.c                     |  161 ++++
 iptables/nft-bridge.c                       |  384 +++++++++
 iptables/nft-shared.c                       |    3 +
 iptables/nft.c                              |   28 +
 iptables/nft.h                              |   12 +
 iptables/xtables-eb-standalone.c            |   87 +++
 iptables/xtables-eb.c                       | 1122 +++++++++++++++++++++++++++
 iptables/xtables-ebtables.h                 |   39 +
 iptables/xtables-multi.c                    |    1 +
 iptables/xtables-multi.h                    |    1 +
 14 files changed, 2210 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebtables.h
 create mode 100644 include/linux/netfilter_bridge/ethernetdb.h
 create mode 100644 iptables/getethertype.c
 create mode 100644 iptables/nft-bridge.c
 create mode 100644 iptables/xtables-eb-standalone.c
 create mode 100644 iptables/xtables-eb.c
 create mode 100644 iptables/xtables-ebtables.h

-- 
1.8.1.5

