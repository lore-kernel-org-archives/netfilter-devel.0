From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH nf-next] netfilter: fix type in parsing in nf_tables_set_alloc_name
Date: Tue, 31 Dec 2013 12:40:05 +0100
Message-ID: <1388490005-6771-1-git-send-email-dborkman@redhat.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab3LaLkN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:40:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In nf_tables_set_alloc_name(), we are trying to find a new, unused
name for our new set and interate through the list of present sets.
As far as I can see, we're using format string %d to parse already
present names in order to mark their presence in a bitmap, so that
we can later on find the first 0 in that map to assign the new set
name to. We should rather use a temporary variable of type int to
store the result of sscanf() to, and for making sanity checks on.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 I think this is not really critical, and can go through nf-next.
 Pablo, if you think otherwise, feel free to apply it to nf-net.

 net/netfilter/nf_tables_api.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f93b7d0..937c34c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1973,11 +1973,14 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 			return -ENOMEM;
 
 		list_for_each_entry(i, &ctx->table->sets, list) {
-			if (!sscanf(i->name, name, &n))
+			int tmp;
+
+			if (!sscanf(i->name, name, &tmp))
 				continue;
-			if (n < 0 || n > BITS_PER_LONG * PAGE_SIZE)
+			if (tmp < 0 || tmp > BITS_PER_LONG * PAGE_SIZE)
 				continue;
-			set_bit(n, inuse);
+
+			set_bit(tmp, inuse);
 		}
 
 		n = find_first_zero_bit(inuse, BITS_PER_LONG * PAGE_SIZE);
-- 
1.7.11.7

