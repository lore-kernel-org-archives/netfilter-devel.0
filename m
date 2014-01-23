From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libnetfilter_conntrack] conntrack: fix parsing payload len
Date: Thu, 23 Jan 2014 20:40:52 +0900
Message-ID: <20140123114051.GB1076@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47865 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaAWLlA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:41:00 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so1725923pbb.17
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2014 03:40:59 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>

---
 src/conntrack/parse_mnl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 1557ff0..98b680b 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -968,5 +968,6 @@ int nfct_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_conntrack *ct)
        struct nfgenmsg *nfhdr = mnl_nlmsg_get_payload(nlh);

        return nfct_payload_parse((uint8_t *)nfhdr + sizeof(struct nfgenmsg),
-                                 nlh->nlmsg_len, nfhdr->nfgen_family, ct);
+                                 mnl_nlmsg_get_payload_len(nlh) - sizeof(struct nfgenmsg),
+                                 nfhdr->nfgen_family, ct);
 }
--
1.8.5.2
