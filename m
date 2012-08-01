From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/5] pgsql schema: fix timestamp default value
Date: Wed,  1 Aug 2012 23:27:14 +0200
Message-ID: <1343856436-11129-4-git-send-email-eric@regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49518 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2HAV2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:35 -0400
In-Reply-To: <1343856436-11129-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set timestamp default value to now() not now which is the time at
table creation.

Reported-by: Mr Dash Four
---
 doc/pgsql-ulogd2.sql |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 0fc2b45..dc954ed 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -62,7 +62,7 @@ CREATE TABLE ulog2 (
   ip_fragoff smallint default NULL,
   label smallint default NULL,
   mac_id bigint default NULL,
-  timestamp timestamp NOT NULL default 'now'
+  timestamp timestamp NOT NULL default now()
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX ulog2_oob_family ON ulog2(oob_family);
-- 
1.7.10.4

