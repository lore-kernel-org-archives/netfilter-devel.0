From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 1/3 v2] Fix all set output from list/save when set with counters in use.
Date: Tue, 12 Nov 2013 12:30:56 +0200
Message-ID: <2840394.lsSE8FCu3c@tuxracer>
References: <2029158.eclrSoCAaG@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from theta.smtp.skif.com.ua ([91.90.18.2]:47809 "EHLO
	theta.smtp.skif.com.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3KLLJY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:09:24 -0500
Received: from tuxracer.localnet (tuxracer.skif.com.ua [195.234.68.4])
	(Authenticated sender: sergey_kv_ua@skif.net.ua)
	by smtp.skif.com.ua (Postfix) with ESMTPSA id D691E892E1
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2013 12:34:52 +0200 (EET)
In-Reply-To: <2029158.eclrSoCAaG@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using upstream version with counters support we have following
output when listing all sets currently configured:
--------------------------------------------------

 # ipset create test-1 hash:ip
 # ipset create test-2 hash:ip counters
 # ipset add test-2 192.0.2.1/32
 # ipset create test-3 hash:ip
 # ipset add test-3 192.0.2.1/32
 # ipset list
 Name: test-1
 Type: hash:ip
 Revision: 2
 Header: family inet hashsize 1024 maxelem 65536
 Size in memory: 16504
 References: 0
 Members:

 Name: test-2
 Type: hash:ip
 Revision: 2
 Header: family inet hashsize 1024 maxelem 65536 counters
 Size in memory: 16616
 References: 0
 Members:
 192.0.2.1 packets 0 bytes 0

 Name: test-3
 Type: hash:ip
 Revision: 2
 Header: family inet hashsize 1024 maxelem 65536 counters
 Size in memory: 16520
 References: 0
 Members:
 192.0.2.1 packets 0 bytes 0

Set test-3 created without counters, but displayed as with counters
present.

Restricting output to list only test-3 set we have:
---------------------------------------------------
  # ipset list test-3
  Name: test-3
  Type: hash:ip
  Revision: 2
  Header: family inet hashsize 1024 maxelem 65536
  Size in memory: 16520
  References: 0
  Members:
  192.0.2.1

So test-3 set created correctly without counters support, but in
all sets listing it displayed as such one with counters.

It seems with commit 5a6021823aa0da24b83f8d03f46ad4202f149fa3
(Support counters in the ipset library) we fogot to add counter
options flags to IPSET_CREATE_FLAGS and IPSET_ADT_FLAGS defines to
clear these flags when preparing output in callback_list() from
lib/session.c.

v2: Remove IPSET_OPT_BYTES, IPSET_PAKETS from CREATE and
    IPSET_OPT_COUNTERS from ADT.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 include/libipset/data.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/libipset/data.h b/include/libipset/data.h
index b6e75e8..cbf30cc 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -90,6 +90,7 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_PROBES)	\
 	| IPSET_FLAG(IPSET_OPT_RESIZE)	\
 	| IPSET_FLAG(IPSET_OPT_SIZE)	\
+	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
 	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT))
 
 #define IPSET_ADT_FLAGS			\
@@ -110,6 +111,8 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_BEFORE) \
 	| IPSET_FLAG(IPSET_OPT_PHYSDEV) \
 	| IPSET_FLAG(IPSET_OPT_NOMATCH) \
+	| IPSET_FLAG(IPSET_OPT_PACKETS)	\
+	| IPSET_FLAG(IPSET_OPT_BYTES)	\
 	| IPSET_FLAG(IPSET_OPT_ADT_COMMENT))
 
 struct ipset_data;
-- 
1.7.10.4

