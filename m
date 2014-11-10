From: Giorgio Dal Molin <giorgio.dal.molin@mobotix.com>
Subject: [PATCH 0/1] autotools conversion: added autotools support for the 'doc' subdir.
Date: Mon, 10 Nov 2014 15:57:04 +0100
Message-ID: <1415631425-10121-2-git-send-email-giorgio.dal.molin@mobotix.com>
References: <1415631425-10121-1-git-send-email-giorgio.dal.molin@mobotix.com>
Cc: Giorgio <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35072 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbaKJO5Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:57:25 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id 4CDD0E3E21
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2014 15:57:23 +0100 (CET)
In-Reply-To: <1415631425-10121-1-git-send-email-giorgio.dal.molin@mobotix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giorgio <giorgio.nicole@arcor.de>

To build the man page 'nft.8' we look for the three programs:
'docbook2x-man', 'docbook2man' and 'db2x_docbook2man'; in case one was found
it is used to build the man page with the command:

# ${DB2MAN} --xinclude $<

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

