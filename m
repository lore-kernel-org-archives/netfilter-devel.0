From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 29/34]  Fix some place were oob_family was used instead of _oob_family.
Date: Sat,  2 Feb 2008 22:24:24 +0100
Message-ID: <12019874711187-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46027 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762200AbYBBWPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:46 -0500
In-Reply-To: <1201987471602-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch fixes some small typo in MySQL schema.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 a146d87... 6dc865a... M	doc/mysql-ulogd2.sql
 doc/mysql-ulogd2.sql |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index a146d87..6dc865a 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -376,7 +376,7 @@ READS SQL DATA
 BEGIN
 	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, oob_family,
+		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol);
 	RETURN LAST_INSERT_ID();
 END
@@ -410,7 +410,7 @@ BEGIN
 	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
 		 	   ip_csum, ip_id, ip_fragoff ) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, oob_family,
+		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, _oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
 		 _ip_csum, _ip_id, _ip_fragoff);
 	RETURN LAST_INSERT_ID();
-- 
1.5.2.5

