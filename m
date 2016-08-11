From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 2/7] ruleset: Prevent memleak in nftnl_ruleset_snprintf_*() functions
Date: Fri, 12 Aug 2016 01:33:34 +0200
Message-ID: <1470958419-32602-3-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <psutter@redhat.com>,
	Arturo Borrero <arturo.borrero.glez@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60455 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbcHKXdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:33:53 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Sutter <psutter@redhat.com>

This is an ugly aspect of the SNPRINTF_BUFFER_SIZE() macro: it contains
a return statement and if that triggers, the function returns without
freeing the iterator object. Therefore duplicate the 'ret < 0' check
before calling it, freeing the iterator knowing that we will bail out
immediately afterwards anyway.

Cc: Arturo Borrero <arturo.borrero.glez@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ruleset.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/ruleset.c b/src/ruleset.c
index 666bcc7a246b6..93cf95ab61e15 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -888,12 +888,16 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
 	t = nftnl_table_list_iter_next(ti);
 	while (t != NULL) {
 		ret = nftnl_table_snprintf(buf+offset, len, t, type, flags);
+		if (ret < 0)
+			nftnl_table_list_iter_destroy(ti);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		t = nftnl_table_list_iter_next(ti);
 
 		ret = snprintf(buf+offset, len, "%s",
 			       nftnl_ruleset_o_separator(t, type));
+		if (ret < 0)
+			nftnl_table_list_iter_destroy(ti);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nftnl_table_list_iter_destroy(ti);
@@ -917,12 +921,16 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t size,
 	c = nftnl_chain_list_iter_next(ci);
 	while (c != NULL) {
 		ret = nftnl_chain_snprintf(buf+offset, len, c, type, flags);
+		if (ret < 0)
+			nftnl_chain_list_iter_destroy(ci);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		c = nftnl_chain_list_iter_next(ci);
 
 		ret = snprintf(buf+offset, len, "%s",
 			       nftnl_ruleset_o_separator(c, type));
+		if (ret < 0)
+			nftnl_chain_list_iter_destroy(ci);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nftnl_chain_list_iter_destroy(ci);
@@ -946,12 +954,16 @@ nftnl_ruleset_snprintf_set(char *buf, size_t size,
 	s = nftnl_set_list_iter_next(si);
 	while (s != NULL) {
 		ret = nftnl_set_snprintf(buf+offset, len, s, type, flags);
+		if (ret < 0)
+			nftnl_set_list_iter_destroy(si);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		s = nftnl_set_list_iter_next(si);
 
 		ret = snprintf(buf+offset, len, "%s",
 			       nftnl_ruleset_o_separator(s, type));
+		if (ret < 0)
+			nftnl_set_list_iter_destroy(si);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nftnl_set_list_iter_destroy(si);
@@ -975,12 +987,16 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t size,
 	r = nftnl_rule_list_iter_next(ri);
 	while (r != NULL) {
 		ret = nftnl_rule_snprintf(buf+offset, len, r, type, flags);
+		if (ret < 0)
+			nftnl_rule_list_iter_destroy(ri);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		r = nftnl_rule_list_iter_next(ri);
 
 		ret = snprintf(buf+offset, len, "%s",
 			       nftnl_ruleset_o_separator(r, type));
+		if (ret < 0)
+			nftnl_rule_list_iter_destroy(ri);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nftnl_rule_list_iter_destroy(ri);
-- 
2.8.2

