From: pablo@netfilter.org
Subject: [PATCH 0/2] nf_tables: atomic transactional updates (v2)
Date: Thu, 28 Mar 2013 21:22:23 +0100
Message-ID: <1364502145-3701-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3C1UWh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:22:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

This patchset comes after this patch:

http://patchwork.ozlabs.org/patch/224196/

and results from discussion with Tomasz and Patrick, the summary
of changes for the first patch are:

* Get rid of the extra struct list_head per rule as discussed with
  Patrick McHardy. With this patch, a temporary object is allocated
  to store the rule update information.

* A new begin operation to explicitly enter the transaction mode,
  and remove the COMMIT flag per rule, as suggested by Tomasz.

* The commit and abort loops have been also simplified from ideas
  extracted after discusion with Tomasz Bursztyka. Basically,
  there is a single list per net namespace that contains pending
  rule updates.

* The transaction list is now owned by the netlink socket portid that
  adds the first rule that waits to be committed. If another process
  wants to perform some rule-set update, it hits -EBUSY.

* Pending updates, if not committed, are destroyed when the process
  explicit aborts or finishes its execution.

The second patch uses NLM_F_DUMP_INTR if the dump in interrupted by
an update.

Comments welcome.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: rework atomic transaction updates
  netfilter: nf_tables: set NLM_F_DUMP_INTR if dump is invalid

 include/net/netfilter/nf_tables.h        |   21 ++-
 include/net/netns/nftables.h             |    4 +-
 include/uapi/linux/netfilter/nf_tables.h |    7 +-
 net/netfilter/nf_tables_api.c            |  242 +++++++++++++++++++-----------
 4 files changed, 179 insertions(+), 95 deletions(-)

-- 
1.7.10.4

