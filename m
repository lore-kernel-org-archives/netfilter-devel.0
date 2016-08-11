From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 6/7] Avoid returning uninitialized data
Date: Fri, 12 Aug 2016 01:33:38 +0200
Message-ID: <1470958419-32602-7-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56453 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbcHKXeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:10 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Although the 'err' pointer should be interesting for users only if the
parser returned non-zero, having it point to uninitialized data is
generally a bad thing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c | 2 +-
 src/rule.c  | 2 +-
 src/set.c   | 2 +-
 src/table.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index ff59f7f705783..dfe0cf23b0f51 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -816,7 +816,7 @@ static int nftnl_chain_do_parse(struct nftnl_chain *c, enum nftnl_parse_type typ
 			      enum nftnl_parse_input input)
 {
 	int ret;
-	struct nftnl_parse_err perr;
+	struct nftnl_parse_err perr = {};
 
 	switch (type) {
 	case NFTNL_PARSE_XML:
diff --git a/src/rule.c b/src/rule.c
index dada00e1cc99f..8aeefbe19a9ed 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -700,7 +700,7 @@ static int nftnl_rule_do_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 			     enum nftnl_parse_input input)
 {
 	int ret;
-	struct nftnl_parse_err perr;
+	struct nftnl_parse_err perr = {};
 
 	switch (type) {
 	case NFTNL_PARSE_XML:
diff --git a/src/set.c b/src/set.c
index 7a41e8caeb3c0..47b6ef46a9c34 100644
--- a/src/set.c
+++ b/src/set.c
@@ -781,7 +781,7 @@ static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 			    enum nftnl_parse_input input)
 {
 	int ret;
-	struct nftnl_parse_err perr;
+	struct nftnl_parse_err perr = {};
 
 	switch (type) {
 	case NFTNL_PARSE_XML:
diff --git a/src/table.c b/src/table.c
index bb46716950b98..845fd68168797 100644
--- a/src/table.c
+++ b/src/table.c
@@ -360,7 +360,7 @@ static int nftnl_table_do_parse(struct nftnl_table *t, enum nftnl_parse_type typ
 			      enum nftnl_parse_input input)
 {
 	int ret;
-	struct nftnl_parse_err perr;
+	struct nftnl_parse_err perr = {};
 
 	switch (type) {
 	case NFTNL_PARSE_XML:
-- 
2.8.2

