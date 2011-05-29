From: Jan Engelhardt <jengelh@medozas.de>
Subject: Additional GOP fix
Date: Sun, 29 May 2011 17:12:14 +0200
Message-ID: <1306681936-30866-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:52074 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab1E2PMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 11:12:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 172e9b15271c276aa1485b4a2fb63928a65b13ae:

  Bump version to 1.4.11 (2011-05-26 18:12:12 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      libxt_owner: restore inversion support

 extensions/libxt_owner.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
