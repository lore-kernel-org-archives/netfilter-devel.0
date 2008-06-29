From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset: Updates for iptreemap (patch-o-matic-ng)
Date: Sun, 29 Jun 2008 19:44:57 +0200
Message-ID: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44945 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYF2RpP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

here are the long promised updates for iptreemap. Nothing critical, just simple
cleanups here and there.

Sven Wegener (6):
      ipset/iptreemap: Remove needless casts of void pointers
      ipset/iptreemap: Use min/max from kernel.h
      ipset/iptreemap: Use non-atomic bit operations
      ipset/iptreemap: Update description of set type
      ipset/iptreemap: Whitespace cleanup
      ipset: Add iptreemap to the list of supported set types

 help                                            |    4 
 linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c |  100 +++++++++++-------------
 2 files changed, 51 insertions(+), 53 deletions(-)
