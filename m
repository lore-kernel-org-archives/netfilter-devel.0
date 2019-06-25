Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F965C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7FF204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfFYG55 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:57:57 -0400
Received: from a3.inai.de ([88.198.85.195]:40120 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfFYG55 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 02:57:57 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id A2AD225C9695; Tue, 25 Jun 2019 08:57:54 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 6E67E3BAC08A;
        Tue, 25 Jun 2019 08:57:53 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/3] libserver: fix incorrect warning message on resolveUserStore
Date:   Tue, 25 Jun 2019 08:57:52 +0200
Message-Id: <20190625065753.31059-2-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625065753.31059-1-jengelh@inai.de>
References: <20190625065753.31059-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Marten van de Sanden <m.vandesanden@kopano.com>

When calling (soap) resolveUserStore on a company name in hosted mode
a warning message was incorrectly logged. This removes that warning
message.
---
 provider/libserver/ECUserManagement.cpp | 14 +++++++++-----
 provider/libserver/ECUserManagement.h   |  5 +++--
 provider/libserver/cmd.cpp              |  5 +++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/provider/libserver/ECUserManagement.cpp b/provider/libserver/ECUserManagement.cpp
index 85ba58bae..cf80d3f34 100644
--- a/provider/libserver/ECUserManagement.cpp
+++ b/provider/libserver/ECUserManagement.cpp
@@ -873,7 +873,9 @@ ECRESULT ECUserManagement::ResolveObject(objectclass_t objclass,
  * Resolve an object name to an object id, with on-the-fly creation of the
  * specified object class.
  */
-ECRESULT ECUserManagement::ResolveObjectAndSync(objectclass_t objclass, const char* szName, unsigned int* lpulObjectId) {
+ECRESULT ECUserManagement::ResolveObjectAndSync(objectclass_t objclass,
+	const char* szName, unsigned int* lpulObjectId, bool tryResolve)
+{
 	objectsignature_t objectsignature;
 	std::string username, companyname;
 	UserPlugin *lpPlugin = NULL;
@@ -949,12 +951,14 @@ ECRESULT ECUserManagement::ResolveObjectAndSync(objectclass_t objclass, const ch
 	} catch (const notsupported &) {
 		return KCERR_NO_SUPPORT;
 	} catch (const objectnotfound &e) {
-		ec_log_warn("K-1515: Object not found %s \"%s\": %s",
-			ObjectClassToName(objclass), szName, e.what());
+		if (!tryResolve)
+			ec_log_warn("K-1515: Object not found %s \"%s\": %s",
+				    ObjectClassToName(objclass), szName, e.what());
 		return KCERR_NOT_FOUND;
 	} catch (const std::exception &e) {
-		ec_log_warn("K-1516: Unable to resolve %s \"%s\": %s",
-			ObjectClassToName(objclass), szName, e.what());
+		if (!tryResolve)
+			ec_log_warn("K-1516: Unable to resolve %s \"%s\": %s",
+				    ObjectClassToName(objclass), szName, e.what());
 		return KCERR_NOT_FOUND;
 	}
 	return GetLocalObjectIdOrCreate(objectsignature, lpulObjectId);
diff --git a/provider/libserver/ECUserManagement.h b/provider/libserver/ECUserManagement.h
index e53572a7a..2535d3be2 100644
--- a/provider/libserver/ECUserManagement.h
+++ b/provider/libserver/ECUserManagement.h
@@ -67,8 +67,9 @@ public:
 	/* Add a member to a group, with on-the-fly deletion of the specified group id. */
 	_kc_hidden virtual ECRESULT AddSubObjectToObjectAndSync(userobject_relation_t, unsigned int parent_id, unsigned int child_id);
 	_kc_hidden virtual ECRESULT DeleteSubObjectFromObjectAndSync(userobject_relation_t, unsigned int parent_id, unsigned int child_id);
-	/* Resolve a user name to a user id, with on-the-fly creation of the specified user. */
-	_kc_hidden virtual ECRESULT ResolveObjectAndSync(objectclass_t, const char *name, unsigned int *obj_id);
+	/* Resolve a user name to a user id, with on-the-fly creation of the
+	   specified user. When 'tryResolve' is set surpress logging warnings */
+	_kc_hidden virtual ECRESULT ResolveObjectAndSync(objectclass_t, const char *name, unsigned int *obj_id, bool tryResolve = false);
 
 	// Get a local object ID for a part of a name
 	virtual ECRESULT SearchObjectAndSync(const char *search_string, unsigned int flags, unsigned int *id);
diff --git a/provider/libserver/cmd.cpp b/provider/libserver/cmd.cpp
index 3c366efcc..0193030d6 100644
--- a/provider/libserver/cmd.cpp
+++ b/provider/libserver/cmd.cpp
@@ -5919,8 +5919,9 @@ SOAP_ENTRY_START(resolveUserStore, lpsResponse->er, const char *szUserName,
 		ulStoreTypeMask = ECSTORE_TYPE_MASK_PRIVATE | ECSTORE_TYPE_MASK_PUBLIC;
 
 	auto usrmgt = lpecSession->GetUserManagement();
-	er = usrmgt->ResolveObjectAndSync(OBJECTCLASS_USER, szUserName, &ulObjectId);
-	if ((er == KCERR_NOT_FOUND || er == KCERR_INVALID_PARAMETER) && lpecSession->GetSessionManager()->IsHostedSupported())
+	bool hosted = lpecSession->GetSessionManager()->IsHostedSupported();
+	er = usrmgt->ResolveObjectAndSync(OBJECTCLASS_USER, szUserName, &ulObjectId, hosted);
+	if ((er == KCERR_NOT_FOUND || er == KCERR_INVALID_PARAMETER) && hosted)
 		// FIXME: this function is being misused, szUserName can also be a company name
 		er = usrmgt->ResolveObjectAndSync(CONTAINER_COMPANY, szUserName, &ulObjectId);
 	if (er != erSuccess)
-- 
2.21.0

