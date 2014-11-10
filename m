From: Giorgio Dal Molin <giorgio.dal.molin@mobotix.com>
Subject: [PATCH 0/1] autotools conversion: added autotools support for the 'files' subdir.
Date: Mon, 10 Nov 2014 16:51:07 +0100
Message-ID: <1415634668-11296-1-git-send-email-giorgio.dal.molin@mobotix.com>
Cc: Giorgio <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:37261 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbaKJPvV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:51:21 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id 771CF3AE80B
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2014 16:51:19 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giorgio <giorgio.nicole@arcor.de>

This patch adds the autotools support to install the nft scripts in 'files/nftables'
under the configured $pkgsysconfdir/nftables (typically /etc/nftables).
After copying the files to their destination dir. a call to 'sed' replaces
the marker @sbindir@' with the actually configured sbin directory (typically
'/sbin' or '/usr/sbin').

Giorgio (1):
  autotools conversion: added autotools support for the 'files' subdir.

 Makefile.am                  |  3 ++-
 configure.ac                 |  2 ++
 files/Makefile.am            |  1 +
 files/nftables/Makefile.am   | 13 +++++++++++++
 files/nftables/bridge-filter |  2 +-
 files/nftables/inet-filter   |  2 +-
 files/nftables/ipv4-filter   |  2 +-
 files/nftables/ipv4-mangle   |  2 +-
 files/nftables/ipv4-nat      |  2 +-
 files/nftables/ipv6-filter   |  2 +-
 files/nftables/ipv6-mangle   |  2 +-
 files/nftables/ipv6-nat      |  2 +-
 12 files changed, 26 insertions(+), 9 deletions(-)
 create mode 100644 files/Makefile.am
 create mode 100644 files/nftables/Makefile.am

-- 
2.1.3

