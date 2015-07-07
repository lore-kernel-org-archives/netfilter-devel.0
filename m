From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct] conntrack: fix stop timestamp assignment
Date: Tue, 7 Jul 2015 13:29:04 +0900
Message-ID: <20150707042904.GA7944@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33022 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbGGE3K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jul 2015 00:29:10 -0400
Received: by pdbdz6 with SMTP id dz6so23033100pdb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jul 2015 21:29:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/parse_mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 5da9933..2582cd7 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -766,7 +766,7 @@ nfct_parse_timestamp(const struct nlattr *attr, struct nf_conntrack *ct)
 	}
 	if (tb[CTA_TIMESTAMP_STOP]) {
 		ct->timestamp.stop =
-			be64toh(mnl_attr_get_u64(tb[CTA_TIMESTAMP_START]));
+			be64toh(mnl_attr_get_u64(tb[CTA_TIMESTAMP_STOP]));
 		set_bit(ATTR_TIMESTAMP_STOP, ct->head.set);
 	}
 
-- 
2.1.4

