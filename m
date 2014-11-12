From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 0/3] autotools conversion: forgotten Makefile.am, 'doc' and 'files'
Date: Wed, 12 Nov 2014 17:41:03 +0100
Message-ID: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:50698 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbaKLQlS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:41:18 -0500
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id 3BFE2E3E5C
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2014 17:41:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here the reworked version of the autotools conversion patches:

 - added a forgotten Makefile.am under 'include/linux/netfilter';
 - autotools support for the 'doc' subdir;
 - autotools support for the 'files' subdir;

Giorgio Dal Molin (3):
  autotools conversion: added a missing 'Makefile.am' under
    'include/linux/netfilter/'.
  autotools conversion: added autotools support for the 'doc' subdir.
  autotools conversion: added autotools support for the 'files' subdir.

 Makefile.am                         |  4 +++-
 configure.ac                        | 40 ++++++++++++++++++-------------------
 doc/Makefile.am                     | 19 ++++++++++++++++++
 doc/Makefile.in                     | 20 -------------------
 files/Makefile.am                   |  1 +
 files/Makefile.in                   |  5 -----
 files/nftables/Makefile.am          | 13 ++++++++++++
 files/nftables/bridge-filter        |  2 +-
 files/nftables/inet-filter          |  2 +-
 files/nftables/ipv4-filter          |  2 +-
 files/nftables/ipv4-mangle          |  2 +-
 files/nftables/ipv4-nat             |  2 +-
 files/nftables/ipv6-filter          |  2 +-
 files/nftables/ipv6-mangle          |  2 +-
 files/nftables/ipv6-nat             |  2 +-
 include/linux/netfilter/Makefile.am |  5 +++++
 16 files changed, 68 insertions(+), 55 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in
 create mode 100644 files/Makefile.am
 delete mode 100644 files/Makefile.in
 create mode 100644 files/nftables/Makefile.am
 create mode 100644 include/linux/netfilter/Makefile.am

-- 
2.1.3

