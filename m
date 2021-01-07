Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E12BC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Jan 2021 09:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F05423142
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Jan 2021 09:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbhAGJGO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 04:06:14 -0500
Received: from smtprelay02.isp.plutex.de ([91.202.40.194]:48083 "EHLO
        smtprelay02.isp.plutex.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbhAGJGO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 04:06:14 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2021 04:06:13 EST
Received: from mail01.plutex.de (mail01.plutex.de [91.202.40.205])
        by smtprelay02.isp.plutex.de (Postfix) with ESMTP id EBE9E80095;
        Thu,  7 Jan 2021 09:56:42 +0100 (CET)
Received: from [IPv6:2a02:16d0:0:6::6aff:a53] (unknown [IPv6:2a02:16d0:0:6::6aff:a53])
        by mail01.plutex.de (Postfix) with ESMTPSA id D0776CC001F;
        Thu,  7 Jan 2021 09:56:42 +0100 (CET)
From:   Jan-Philipp Litza <jpl@plutex.de>
Subject: [PATCH] netfilter: Reverse nft_set_lookup_byid list traversal
To:     netfilter-devel@vger.kernel.org
Reply-To: jpl+netfilter-devel@plutex.de
Message-ID: <21ed8188-a202-f578-6f8b-303dec37a266@plutex.de>
Date:   Thu, 7 Jan 2021 09:56:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When loading a large ruleset with many anonymous sets,
nft_set_lookup_global is called once for each added set element, which
in turn calls nft_set_lookup_byid if the set was only added in this
transaction.

The longer this transaction's queue of unapplied netlink messages gets,
the longer it takes to traverse it in search for the set referenced by
ID that was probably added near the end if it is an anonymous set. This
patch hence searches the list of unapplied netlink messages in reverse
order, finding the just-added anonymous set faster.

On some reallife ruleset of ~6000 statements and ~1000 anonymous sets,
this patch roughly halves the system time on loading:

Before: 0,06s user 0,39s system 97% cpu 0,459 total
After:  0,06s user 0,20s system 97% cpu 0,268 total

The downside might be that newly added non-anonymous named sets are
probably added at the beginning of a transaction, and looking for them
when adding elements later on takes longer. However, I reckon that named
sets too are more often filled right after their creation. Furthermore,
for named sets, users can optimize their rule structure to add elements
right after set creation, whereas it's impossible to first create all
anonymous sets at the beginning of the transaction to optimize for the
current approach.

Signed-off-by: Jan-Philipp Litza <jpl@plutex.de>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8d5aa0ac4..c488b6b95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3639,7 +3639,7 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
 	struct nft_trans *trans;
 	u32 id = ntohl(nla_get_be32(nla));
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET) {
 			struct nft_set *set = nft_trans_set(trans);
 
--
2.27.0

