Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21C7C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 15:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DD8206B8
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 15:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfCDPxy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:53:54 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:53858 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbfCDPxy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 10:53:54 -0500
Received: from localhost ([::1]:38714 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h0pub-0002H9-4S; Mon, 04 Mar 2019 16:53:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH] extensions: connlabel: Fallback on missing connlabel.conf
Date:   Mon,  4 Mar 2019 16:53:46 +0100
Message-Id: <20190304155346.29212-1-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190304150242.e66i4zj25jj2jt2q@breakpoint.cc>
References: <20190304150242.e66i4zj25jj2jt2q@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If connlabel.conf was not found, fall back to manually parsing arguments
as plain numbers.

If nfct_labelmap_new() has failed, nfct_labelmap_get_name() segfaults.
Therefore make sure it is not called in connlabel_get_name() if that's
the case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This patch supersedes patches 3-5 of this series.
---
 extensions/libxt_connlabel.c      | 49 ++++++++++++++++++++++++-------
 extensions/libxt_connlabel.t      | 23 ++++-----------
 extensions/libxt_connlabel.txlate |  8 ++---
 3 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index d06bb27a7c2e9..5a01fe7237bd8 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -1,8 +1,10 @@
+#define _GNU_SOURCE
 #include <errno.h>
 #include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdint.h>
+#include <stdlib.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_connlabel.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -32,40 +34,59 @@ static const struct xt_option_entry connlabel_mt_opts[] = {
 /* cannot do this via _init, else static builds might spew error message
  * for every iptables invocation.
  */
-static void connlabel_open(void)
+static int connlabel_open(void)
 {
 	const char *fname;
 
 	if (map)
-		return;
+		return 0;
 
 	map = nfct_labelmap_new(NULL);
 	if (map != NULL)
-		return;
+		return 0;
 
 	fname = nfct_labels_get_path();
 	if (errno) {
-		xtables_error(RESOURCE_PROBLEM,
-			"cannot open %s: %s", fname, strerror(errno));
+		fprintf(stderr, "Warning: cannot open %s: %s\n",
+			fname, strerror(errno));
 	} else {
 		xtables_error(RESOURCE_PROBLEM,
 			"cannot parse %s: no labels found", fname);
 	}
+	return 1;
+}
+
+static int connlabel_value_parse(const char *in)
+{
+	char *end;
+	unsigned long value = strtoul(in, &end, 0);
+
+	if (in[0] == '\0' || *end != '\0')
+		return -1;
+
+	return value;
 }
 
 static void connlabel_mt_parse(struct xt_option_call *cb)
 {
 	struct xt_connlabel_mtinfo *info = cb->data;
+	bool have_labelmap = !connlabel_open();
 	int tmp;
 
-	connlabel_open();
 	xtables_option_parse(cb);
 
 	switch (cb->entry->id) {
 	case O_LABEL:
-		tmp = nfct_labelmap_get_bit(map, cb->arg);
+		if (have_labelmap)
+			tmp = nfct_labelmap_get_bit(map, cb->arg);
+		else
+			tmp = connlabel_value_parse(cb->arg);
+
 		if (tmp < 0)
-			xtables_error(PARAMETER_PROBLEM, "label '%s' not found", cb->arg);
+			xtables_error(PARAMETER_PROBLEM,
+				      "label '%s' not found or invalid value",
+				      cb->arg);
+
 		info->bit = tmp;
 		if (cb->invert)
 			info->options |= XT_CONNLABEL_OP_INVERT;
@@ -81,7 +102,8 @@ static const char *connlabel_get_name(int b)
 {
 	const char *name;
 
-	connlabel_open();
+	if (connlabel_open())
+		return NULL;
 
 	name = nfct_labelmap_get_name(map, b);
 	if (name && strcmp(name, ""))
@@ -134,9 +156,13 @@ static int connlabel_mt_xlate(struct xt_xlate *xl,
 	const struct xt_connlabel_mtinfo *info =
 		(const void *)params->match->data;
 	const char *name = connlabel_get_name(info->bit);
+	char *valbuf = NULL;
 
-	if (name == NULL)
-		return 0;
+	if (name == NULL) {
+		if (asprintf(&valbuf, "%u", info->bit) < 0)
+			return 0;
+		name = valbuf;
+	}
 
 	if (info->options & XT_CONNLABEL_OP_SET)
 		xt_xlate_add(xl, "ct label set %s ", name);
@@ -146,6 +172,7 @@ static int connlabel_mt_xlate(struct xt_xlate *xl,
 		xt_xlate_add(xl, "and %s != ", name);
 	xt_xlate_add(xl, "%s", name);
 
+	free(valbuf);
 	return 1;
 }
 
diff --git a/extensions/libxt_connlabel.t b/extensions/libxt_connlabel.t
index aad1032b5a8bb..7265bd4764865 100644
--- a/extensions/libxt_connlabel.t
+++ b/extensions/libxt_connlabel.t
@@ -1,18 +1,7 @@
 :INPUT,FORWARD,OUTPUT
-# Backup the connlabel.conf, then add some label maps for test
-@[ -f /etc/xtables/connlabel.conf ] && mv /etc/xtables/connlabel.conf /tmp/connlabel.conf.bak
-@mkdir -p /etc/xtables
-@echo "40 bit40" > /etc/xtables/connlabel.conf
-@echo "41 bit41" >> /etc/xtables/connlabel.conf
-@echo "128 bit128" >> /etc/xtables/connlabel.conf
--m connlabel --label "bit40";=;OK
--m connlabel ! --label "bit40";=;OK
--m connlabel --label "bit41" --set;=;OK
--m connlabel ! --label "bit41" --set;=;OK
--m connlabel --label "bit128";;FAIL
-@echo > /etc/xtables/connlabel.conf
--m connlabel --label "abc";;FAIL
-@rm -f /etc/xtables/connlabel.conf
--m connlabel --label "abc";;FAIL
-# Restore the original connlabel.conf
-@[ -f /tmp/connlabel.conf.bak ] && mv /tmp/connlabel.conf.bak /etc/xtables/connlabel.conf
+-m connlabel --label "40";=;OK
+-m connlabel ! --label "40";=;OK
+-m connlabel --label "41" --set;=;OK
+-m connlabel ! --label "41" --set;=;OK
+-m connlabel --label "2048";;FAIL
+-m connlabel --label "foobar_not_there";;FAIL
diff --git a/extensions/libxt_connlabel.txlate b/extensions/libxt_connlabel.txlate
index 5be422044637d..12e4ac0351103 100644
--- a/extensions/libxt_connlabel.txlate
+++ b/extensions/libxt_connlabel.txlate
@@ -1,5 +1,5 @@
-iptables-translate -A INPUT -m connlabel --label bit40
-nft add rule ip filter INPUT ct label bit40 counter
+iptables-translate -A INPUT -m connlabel --label 40
+nft add rule ip filter INPUT ct label 40 counter
 
-iptables-translate -A INPUT -m connlabel ! --label bit40 --set
-nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
+iptables-translate -A INPUT -m connlabel ! --label 40 --set
+nft add rule ip filter INPUT ct label set 40 ct label and 40 != 40 counter
-- 
2.20.1

