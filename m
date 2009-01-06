From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 3/6] PostgreSQL schema: drop useless constraints
Date: Tue,  6 Jan 2009 23:31:15 +0100
Message-ID: <1231281078-31060-4-git-send-email-chifflier@inl.fr>
References: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52884 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbZAFWaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:30:04 -0500
In-Reply-To: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Constraints on TCP/UDP port number validity are useless and only slow
down insertions.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/pgsql-ulogd2.sql |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 73e038d..da66c85 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -278,11 +278,6 @@ CREATE INDEX ulog2_ct_reply_l4_sport ON ulog2_ct(reply_l4_sport);
 CREATE INDEX ulog2_ct_reply_l4_dport ON ulog2_ct(reply_l4_dport);
 CREATE INDEX ulog2_ct_event ON ulog2_ct(ct_event);
 
-ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_sport CHECK(orig_l4_sport >= 0 AND orig_l4_sport <= 65536);
-ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_dport CHECK(orig_l4_dport >= 0 AND orig_l4_dport <= 65536);
-ALTER TABLE ulog2_ct ADD CONSTRAINT reply_l4_sport CHECK(reply_l4_sport >= 0 AND reply_l4_sport <= 65536);
-ALTER TABLE ulog2_ct ADD CONSTRAINT reply_l4_dport CHECK(reply_l4_dport >= 0 AND reply_l4_dport <= 65536);
-
 -- 
 -- Helper table
 -- 
-- 
1.5.6.5

