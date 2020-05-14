Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43DEC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F71206A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 12:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgENMTX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 08:19:23 -0400
Received: from correo.us.es ([193.147.175.20]:54276 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgENMTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 08:19:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4704615AEB2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33B95DA701
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:19:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B4A3DA713; Thu, 14 May 2020 14:19:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 224CFDA701;
        Thu, 14 May 2020 14:19:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F1D5642EF42A;
        Thu, 14 May 2020 14:19:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/6] netfilter: conntrack: fix infinite loop on rmmod
Date:   Thu, 14 May 2020 14:19:11 +0200
Message-Id: <20200514121913.24519-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

'rmmod nf_conntrack' can hang forever, because the netns exit
gets stuck in nf_conntrack_cleanup_net_list():

i_see_dead_people:
 busy = 0;
 list_for_each_entry(net, net_exit_list, exit_list) {
  nf_ct_iterate_cleanup(kill_all, net, 0, 0);
  if (atomic_read(&net->ct.count) != 0)
   busy = 1;
 }
 if (busy) {
  schedule();
  goto i_see_dead_people;
 }

When nf_ct_iterate_cleanup iterates the conntrack table, all nf_conn
structures can be found twice:
once for the original tuple and once for the conntracks reply tuple.

get_next_corpse() only calls the iterator when the entry is
in original direction -- the idea was to avoid unneeded invocations
of the iterator callback.

When support for clashing entries was added, the assumption that
all nf_conn objects are added twice, once in original, once for reply
tuple no longer holds -- NF_CLASH_BIT entries are only added in
the non-clashing reply direction.

Thus, if at least one NF_CLASH entry is in the list then
nf_conntrack_cleanup_net_list() always skips it completely.

During normal netns destruction, this causes a hang of several
seconds, until the gc worker removes the entry (NF_CLASH entries
always have a 1 second timeout).

But in the rmmod case, the gc worker has already been stopped, so
ct.count never becomes 0.

We can fix this in two ways:

1. Add a second test for CLASH_BIT and call iterator for those
   entries as well, or:
2. Skip the original tuple direction and use the reply tuple.

2) is simpler, so do that.

Fixes: 6a757c07e51f80ac ("netfilter: conntrack: allow insertion of clashing entries")
Reported-by: Chen Yi <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0173398f4ced..1d57b95d3481 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2139,8 +2139,19 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		nf_conntrack_lock(lockp);
 		if (*bucket < nf_conntrack_htable_size) {
 			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
 					continue;
+				/* All nf_conn objects are added to hash table twice, one
+				 * for original direction tuple, once for the reply tuple.
+				 *
+				 * Exception: In the IPS_NAT_CLASH case, only the reply
+				 * tuple is added (the original tuple already existed for
+				 * a different object).
+				 *
+				 * We only need to call the iterator once for each
+				 * conntrack, so we just use the 'reply' direction
+				 * tuple while iterating.
+				 */
 				ct = nf_ct_tuplehash_to_ctrack(h);
 				if (iter(ct, data))
 					goto found;
-- 
2.20.1

