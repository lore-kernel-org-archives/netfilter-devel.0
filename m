Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jun 2022 16:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiF3QaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jun 2022 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiF3QaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jun 2022 12:30:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAAE3527E
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2022 09:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9cbKQyu3sVSz5lTQfsLfeo0EWuHnscqJ42AmNutbGr8=; b=M4dgNk6b6/w4dkSQnPWPdBcCEQ
        wi2cMRHcJkwBCt8A5YnhauxLH9LP1AF74oisxNCigHJVroMjVylyONCZHX114LDuMdr1lomQJ99Ty
        /8z2EFYIlBCQy1fueK2j1flscnmJNkqDjLsCrwqd0tNlZtGOLufrcydzoQOORMJTMjRXd81tVzmzQ
        yz4Fm+B809YjAwIaMuiNSYxrUA2OyrmfaiAMZDyXr0i9a0LHSpp2IVSrGPGpkSczVHn1RAopA+WnX
        v6tN70Vw4FKjyhDu34UXyCHfHQTIjBLzL/7l/36WvQLCESYibpqdYg9OtqtwQUUUIp7pp+3n9IcEp
        FiCx0qfg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o6x3O-0004EV-0L
        for netfilter-devel@vger.kernel.org; Thu, 30 Jun 2022 18:30:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] libxtables: Fix unsupported extension warning corner case
Date:   Thu, 30 Jun 2022 18:29:57 +0200
Message-Id: <20220630162957.29464-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some extensions are not supported in revision 0 by user space anymore,
for those the warning in xtables_compatible_revision() does not print as
no revision 0 is tried.

To fix this, one has to track if none of the user space supported
revisions were accepted by the kernel. Therefore add respective logic to
xtables_find_{target,match}().

Note that this does not lead to duplicated warnings for unsupported
extensions that have a revision 0 because xtables_compatible_revision()
returns true for them to allow for extension's help output.

For the record, these ip6tables extensions are affected: set/SET,
socket, tos/TOS, TPROXY and SNAT. In addition to that, TEE is affected
for both families.

Fixes: 17534cb18ed0a ("Improve error messages for unsupported extensions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index dc645162973f0..479dbae078156 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -776,6 +776,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
 	bool found = false;
+	bool seen = false;
 
 	if (strlen(name) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
@@ -794,6 +795,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
+			seen = true;
 			if (!found &&
 			    xtables_fully_register_pending_match(ptr, prev)) {
 				found = true;
@@ -807,6 +809,11 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		dptr = &((*dptr)->next);
 	}
 
+	if (seen && !found)
+		fprintf(stderr,
+			"Warning: Extension %s is not supported, missing kernel module?\n",
+			name);
+
 	for (ptr = xtables_matches; ptr; ptr = ptr->next) {
 		if (extension_cmp(name, ptr->name, ptr->family)) {
 			struct xtables_match *clone;
@@ -899,6 +906,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	struct xtables_target **dptr;
 	struct xtables_target *ptr;
 	bool found = false;
+	bool seen = false;
 
 	/* Standard target? */
 	if (strcmp(name, "") == 0
@@ -917,6 +925,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
+			seen = true;
 			if (!found &&
 			    xtables_fully_register_pending_target(ptr, prev)) {
 				found = true;
@@ -930,6 +939,11 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		dptr = &((*dptr)->next);
 	}
 
+	if (seen && !found)
+		fprintf(stderr,
+			"Warning: Extension %s is not supported, missing kernel module?\n",
+			name);
+
 	for (ptr = xtables_targets; ptr; ptr = ptr->next) {
 		if (extension_cmp(name, ptr->name, ptr->family)) {
 			struct xtables_target *clone;
-- 
2.34.1

