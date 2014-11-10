From: Giorgio Dal Molin <giorgio.dal.molin@mobotix.com>
Subject: [PATCH 0/1] autotools conversion: added autotools support for the 'doc' subdir.
Date: Mon, 10 Nov 2014 15:57:03 +0100
Message-ID: <1415631425-10121-1-git-send-email-giorgio.dal.molin@mobotix.com>
Cc: Giorgio <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:35183 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaKJO5Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:57:25 -0500
Received: from mail-in-17-z2.arcor-online.net (mail-in-17-z2.arcor-online.net [151.189.8.34])
	by mx.arcor.de (Postfix) with ESMTP id 0616FAA2BB
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2014 15:57:23 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giorgio <giorgio.nicole@arcor.de>

This patch adds support to eventually build the nft docs: 'nft.8' and
'nft.pdf' in case the proper documentation tools are found on the system.
To build the man page 'nft.8' we look for one the three programs:
'docbook2x-man', 'docbook2man' and 'db2x_docbook2man'; in case one was found
it is used to build the man page with the command:

# ${DB2MAN} --xinclude $<

To build the .pdf we search for 'dblatex'.

giorgio (1):
  autotools conversion: added autotools support for the 'doc' subdir.

 Makefile.am     |  5 ++---
 configure.ac    | 45 ++++++++++++++++++++++-----------------------
 doc/Makefile.am | 19 +++++++++++++++++++
 doc/Makefile.in | 20 --------------------
 4 files changed, 43 insertions(+), 46 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in

-- 
2.1.3

