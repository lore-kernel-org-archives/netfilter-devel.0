From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 0/3] xtables-events segfault
Date: Thu,  6 Feb 2014 14:31:08 +0100
Message-ID: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56971 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBFNaj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:30:39 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so892190eek.3
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2014 05:30:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
this patchset fixes the segfault obtained if you try
to add a rule for arp family.

I added a new function into nft-shared that will be
used to print matches and target for ip/ip6/family
and reworked a bit the code.

The function nft_arp_save_firewall isn't implemented yet,
I'll send another patch later.

Currently is not possible to print ebtables rules,
when xtables-eb is ready, I'll do it.

BR,

Giuseppe Longo (3):
  nft-shared: adds save_matches_and_target
  nft-arp: adds nft_arp_save_firewall
  xtables-events: prints arp rules

 iptables/nft-arp.c        |  9 +++++++++
 iptables/nft-ipv4.c       |  7 +++++--
 iptables/nft-ipv6.c       |  7 +++++--
 iptables/nft-shared.c     | 35 +++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h     |  6 +++++-
 iptables/nft.c            | 33 ++-------------------------------
 iptables/nft.h            |  2 +-
 iptables/xtables-events.c | 20 +++++++++++++-------
 8 files changed, 75 insertions(+), 44 deletions(-)

-- 
1.8.1.5

