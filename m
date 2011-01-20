From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: connlimit rev1 addendum
Date: Thu, 20 Jan 2011 14:17:00 +0100
Message-ID: <1295529422-25624-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37130 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab1ATNRG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:17:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit c8f28cc8b84133f20421470e9a61a5a0c78b9c4a:

  extensions: libxt_conntrack: add support for specifying port ranges (2011-01-20 11:45:12 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      libxt_connlimit: remove duplicate member that caused size change

 include/linux/netfilter/xt_connlimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
