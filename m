From: Jan Engelhardt <jengelh@medozas.de>
Subject: xtables: connlimit rev1 addendum
Date: Thu, 20 Jan 2011 14:14:03 +0100
Message-ID: <1295529245-21127-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58178 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1ATNOJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:14:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit cc4fc022571376412986e27e08b0765e9cb2aafb:

  netfilter: xtables: connlimit revision 1 (2011-01-19 18:27:46 +0100)

are available in the git repository at:
  git://dev.medozas.de/linux connlimit

Jan Engelhardt (1):
      netfilter: xtables: remove duplicate member

 include/linux/netfilter/xt_connlimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
