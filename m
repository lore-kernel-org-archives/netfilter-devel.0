From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] xtables: trivial spelling fix
Date: Sun, 4 Aug 2013 15:08:26 -0700
Message-ID: <20130804150826.226f33ed@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53536 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3HDWIa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Aug 2013 18:08:30 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so2544588pad.23
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Aug 2013 15:08:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

---
 include/xtables.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index c35a6e6..0217267 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -230,7 +230,7 @@ struct xtables_match
 	/* Size of match data. */
 	size_t size;
 
-	/* Size of match data relevent for userspace comparison purposes */
+	/* Size of match data relevant for userspace comparison purposes */
 	size_t userspacesize;
 
 	/* Function which prints out usage message. */
@@ -308,7 +308,7 @@ struct xtables_target
 	/* Size of target data. */
 	size_t size;
 
-	/* Size of target data relevent for userspace comparison purposes */
+	/* Size of target data relevant for userspace comparison purposes */
 	size_t userspacesize;
 
 	/* Function which prints out usage message. */
-- 
1.7.10.4

