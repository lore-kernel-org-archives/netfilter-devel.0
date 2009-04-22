From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] fix missing attribute in DCCP
Date: Wed, 22 Apr 2009 14:27:45 +0200
Message-ID: <20090422122306.14461.55699.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZDVM17 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:27:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

While finishing the DCCP support (I think it's the last to finish
the conntrack-tools), I notice that there's one field that is
not exported to user-space via ctnetlink.

This patch adds a couple of missing attributes that allows me to
set the role in DCCP connections, otherwise the ctnetlink support
is not of much help to be used by conntrackd.

This can be done with only one attribute, so we can have just one
CTA_PROTOINFO_DCCP_ROLE_ORIGINAL and set the reply as the opposite.
However, this may look at bit inconsistent. I don't really mind
the way this is done, just tell me I'll do it :), but I need this
to complete DCCP support.

BTW, I think that this can be qualified as bugfix for 2.6.30-rc
since the current support is not of any help to create
conntrack entries with DCCP.

---

Pablo Neira Ayuso (1):
      netfilter: conntrack: add missing role attributes for DCCP


 include/linux/netfilter/nfnetlink_conntrack.h |    2 ++
 net/netfilter/nf_conntrack_proto_dccp.c       |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

