Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD83C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Feb 2022 17:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiBKRMZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 12:12:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347532AbiBKRMY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 12:12:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A840ABD6
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 09:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pD+kKgAQpoDFuD5veh3qe6x8GFwbQCmVRq79RhwBjfk=; b=JNPs0QQWJdMrWh+o+3dcJdr6mK
        SVZsqY+Y+BlyieX6BL/gasrI8g+D7vXid1Y0WiDtyseRREgU58COqz3Yz5qrlWvaapW0HOllVF4B0
        0Hgjl5ORqft39DXLhL+PKbrixXcmEJMkVOFgVTATPnnQvqvz8cL4BmlJDnCy3MeKRM4nVV/TnpeNl
        cwMB1BPKd6i+bad27kPQMRTnK/0/+VblpwwrZGIQEDb+xMKl2rYHnHKDSJQgWIIV0t7UQ+3kjyMpf
        44z97Bn5nrCDv54j8EfGTEI7Y9u19l6jK+o/eUScNB+hminZBKYI0q9fPJem4wYkoPvjLaJI68aEY
        v+yAIB9g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nIZT0-0006Tx-Ud; Fri, 11 Feb 2022 18:12:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] libxtables: Register only the highest revision extension
Date:   Fri, 11 Feb 2022 18:12:10 +0100
Message-Id: <20220211171211.26484-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211171211.26484-1-phil@nwl.cc>
References: <20220211171211.26484-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When fully registering extensions, ignore all consecutive ones with same
name and family value. Since commit b3ac87038f4e4 ("libxtables: Make
sure extensions register in revision order"), one may safely assume the
list of pending extensions has highest revision numbers first. Since
iptables is only interested in the highest revision the kernel supports,
registration and compatibility checks may be skipped once the first
matching extension in pending list has validated.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 50fd6a44b0100..b34d62acf6015 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -697,6 +697,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	struct xtables_match **dptr;
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
+	bool found = false;
 
 	if (strlen(name) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
@@ -715,7 +716,9 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
-			if (xtables_fully_register_pending_match(ptr, prev)) {
+			if (!found &&
+			    xtables_fully_register_pending_match(ptr, prev)) {
+				found = true;
 				prev = ptr;
 				continue;
 			} else if (prev) {
@@ -817,6 +820,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	struct xtables_target *prev = NULL;
 	struct xtables_target **dptr;
 	struct xtables_target *ptr;
+	bool found = false;
 
 	/* Standard target? */
 	if (strcmp(name, "") == 0
@@ -831,7 +835,9 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
-			if (xtables_fully_register_pending_target(ptr, prev)) {
+			if (!found &&
+			    xtables_fully_register_pending_target(ptr, prev)) {
+				found = true;
 				prev = ptr;
 				continue;
 			} else if (prev) {
-- 
2.34.1

