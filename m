From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_log: Remove NULL check
Date: Sun, 12 Jun 2016 00:26:10 +0530
Message-ID: <20160611185610.GA3374@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34247 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbcFKS4x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 14:56:53 -0400
Received: by mail-pa0-f67.google.com with SMTP id ug1so7390954pab.1
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 11:56:53 -0700 (PDT)
Received: from shivani ([116.202.36.139])
        by smtp.gmail.com with ESMTPSA id l67sm26413516pfi.10.2016.06.11.11.56.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 11 Jun 2016 11:56:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If 'logger' was NULL, there would be a direct jump to the label 'out',
since it has already been checked for NULL, remove this unnecessary
check.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 net/netfilter/nf_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index a5d41df..93236ab 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -167,7 +167,7 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 	if (logger == NULL)
 		goto out;
 
-	if (logger && try_module_get(logger->me))
+	if (try_module_get(logger->me))
 		ret = 0;
 out:
 	rcu_read_unlock();
-- 
1.9.1

