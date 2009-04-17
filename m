From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] minor netfilter fixes for 2.6.30-rc
Date: Fri, 17 Apr 2009 11:05:05 +0200
Message-ID: <20090417090010.11291.31173.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48558 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZDQJFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:05:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patches are a couple of minor fixes for 2.6.30-rc:

 * fix missing error report to user-space in ctnetlink if we fail to
 allocate the message.
 * fix misleading error in nfnetlink (-EPERM) if we fail to load
 nfnetlink. This patch replaces it with ENOMEM as it does rtnetlink.

---

Pablo Neira Ayuso (2):
      netfilter: nfnetlink: return ENOMEM if we fail to create netlink socket
      netfilter: ctnetlink: report error if event message allocation fails


 net/netfilter/nf_conntrack_netlink.c |    5 +++--
 net/netfilter/nfnetlink.c            |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

