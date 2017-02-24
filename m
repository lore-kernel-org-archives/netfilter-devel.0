From: Dan Williams <dcbw@redhat.com>
Subject: [PATCH v2] libiptc: don't set_changed() when checking rules with
 module jumps
Date: Fri, 24 Feb 2017 12:25:55 -0600
Message-ID: <1487960755.27698.15.camel@redhat.com>
References: <1487960119.27698.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbdBXSZ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2017 13:25:58 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 806E23A76B9
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2017 18:25:58 +0000 (UTC)
Received: from ovpn-112-32.phx2.redhat.com (ovpn-112-32.phx2.redhat.com [10.3.112.32])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v1OIPv1W014121
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2017 13:25:57 -0500
In-Reply-To: <1487960119.27698.11.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
** this time with a signed-off-by, no other changes.

 libiptc/libiptc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 2c66d04..a6e7057 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1686,7 +1686,8 @@ iptcc_standard_map(struct rule_head *r, int verdict)
 
 static int
 iptcc_map_target(struct xtc_handle *const handle,
-	   struct rule_head *r)
+	   struct rule_head *r,
+	   bool dry_run)
 {
 	STRUCT_ENTRY *e = r->entry;
 	STRUCT_ENTRY_TARGET *t = GET_TARGET(e);
@@ -1731,7 +1732,8 @@ iptcc_map_target(struct xtc_handle *const handle,
 	       0,
 	       FUNCTION_MAXNAMELEN - 1 - strlen(t->u.user.name));
 	r->type = IPTCC_R_MODULE;
-	set_changed(handle);
+	if (!dry_run)
+		set_changed(handle);
 	return 1;
 }
 
@@ -1781,7 +1783,7 @@ TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(handle, r)) {
+	if (!iptcc_map_target(handle, r, false)) {
 		free(r);
 		return 0;
 	}
@@ -1831,7 +1833,7 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(handle, r)) {
+	if (!iptcc_map_target(handle, r, false)) {
 		free(r);
 		return 0;
 	}
@@ -1870,7 +1872,7 @@ TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(handle, r)) {
+	if (!iptcc_map_target(handle, r, false)) {
 		DEBUGP("unable to map target of rule for chain `%s'\n", chain);
 		free(r);
 		return 0;
@@ -1976,7 +1978,7 @@ static int delete_entry(const IPT_CHAINLABEL chain, const STRUCT_ENTRY *origfw,
 
 	memcpy(r->entry, origfw, origfw->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_NOMAP;
-	if (!iptcc_map_target(handle, r)) {
+	if (!iptcc_map_target(handle, r, dry_run)) {
 		DEBUGP("unable to map target of rule for chain `%s'\n", chain);
 		free(r);
 		return 0;
-- 
2.9.3
