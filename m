From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4 -nftables v2] nf_tables atomic rule-set update
Date: Tue, 17 Sep 2013 12:43:09 +0200
Message-ID: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52618 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3IQKn0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset introduces improvements for the atomic rule update
infrastructure, main changes are:

* Get rid of the extra struct list_head per rule as discussed.
  With this patch, a temporary object is allocated to store the
  rule update information.

* The commit and abort loops have been also simplified. Basically,
  there is a single list per net namespace that contains pending
  rule updates.

* A new begin message to explicitly enter the transaction mode,
  The end message indicates that commit need to happen. If not
  specified, the pending updates are aborted.

* Remove the commit flag per rule, thus, all rule updates are
  transactional.

These changes requires userspace updates, they will be posted soon.

Pablo Neira Ayuso (4):
  netfilter: nf_tables: get rid of per rule list_head for commits
  netfilter: nf_tables: use per netns commit list
  netfilter: nfnetlink: add batch support and use it from nf_tables
  netfilter: nf_tables: all rule updates are transactional

 include/linux/netfilter/nfnetlink.h      |    2 +
 include/net/netfilter/nf_tables.h        |   23 +++-
 include/net/netns/nftables.h             |    1 +
 include/uapi/linux/netfilter/nf_tables.h |    7 -
 include/uapi/linux/netfilter/nfnetlink.h |    4 +
 net/netfilter/nf_tables_api.c            |  213 +++++++++++-------------------
 net/netfilter/nfnetlink.c                |  171 +++++++++++++++++++++++-
 7 files changed, 272 insertions(+), 149 deletions(-)

-- 
1.7.10.4

