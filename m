From: Jan Engelhardt <jengelh@inai.de>
Subject: libnftnl: two trivial build fixes
Date: Tue, 21 Jan 2014 00:52:00 +0100
Message-ID: <1390261922-13182-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43511 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaATXwE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:52:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 91264d8b8b746f7eee8a3e1ee9b5e57758441cfc:

  build: Ensure pkg-config file provides the right informations (2014-01-20 17:01:03 +0100)

are available in the git repository at:

  git://git.inai.de/libnftnl master

for you to fetch changes up to b5d35ad41234e92e17168ce44dafb8d653a6bfc7:

  build: resolve compile error involving XT_EXTENSION_MAXNAMELEN (2014-01-21 00:50:26 +0100)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: resolve build failure involving linux/netlink.h
      build: resolve compile error involving XT_EXTENSION_MAXNAMELEN

 include/linux/netfilter/x_tables.h | 185 +++++++++++++++++++++++++++++++++++++
 src/common.c                       |   3 +-
 2 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/netfilter/x_tables.h
