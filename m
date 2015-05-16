From: Felix Janda <felix.janda@posteo.de>
Subject: [libnfnetlink PATCH 2/3] Convert kernel to userspace types
Date: Sat, 16 May 2015 14:54:45 +0200
Message-ID: <20150516124938.GY14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:39926 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbbEPMzI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:55:08 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 077A425AF531
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:55:06 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpmmB58G8z5vN5
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:55:06 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnfnetlink/linux_nfnetlink.h        | 4 ++--
 include/libnfnetlink/linux_nfnetlink_compat.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libnfnetlink/linux_nfnetlink.h b/include/libnfnetlink/linux_nfnetlink.h
index f7af94f..c5c15ba 100644
--- a/include/libnfnetlink/linux_nfnetlink.h
+++ b/include/libnfnetlink/linux_nfnetlink.h
@@ -29,8 +29,8 @@ enum nfnetlink_groups {
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
-	__u8  nfgen_family;		/* AF_xxx */
-	__u8  version;		/* nfnetlink version */
+	uint8_t  nfgen_family;		/* AF_xxx */
+	uint8_t  version;		/* nfnetlink version */
 	u_int16_t    res_id;		/* resource id */
 };
 
diff --git a/include/libnfnetlink/linux_nfnetlink_compat.h b/include/libnfnetlink/linux_nfnetlink_compat.h
index 74b9e55..c981044 100644
--- a/include/libnfnetlink/linux_nfnetlink_compat.h
+++ b/include/libnfnetlink/linux_nfnetlink_compat.h
@@ -21,8 +21,8 @@
  */
 
 struct nfattr {
-	__u16 nfa_len;
-	__u16 nfa_type;	/* we use 15 bits for the type, and the highest
+	uint16_t nfa_len;
+	uint16_t nfa_type;	/* we use 15 bits for the type, and the highest
 				 * bit to indicate whether the payload is nested */
 };
 
-- 
2.3.6
