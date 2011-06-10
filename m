From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 3/8] iptables: Coverity: NEGATIVE_RETURNS
Date: Fri, 10 Jun 2011 15:25:57 +0200
Message-ID: <1307712362-17727-4-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1FJN0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:43 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQhYv006009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:43 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libipq/libipq.c:232: var_tested_neg: Variable "h->fd" tests negative.
libipq/libipq.c:234: negative_returns: "h->fd" is passed to a parameter that cannot be negative.
---
 libipq/libipq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/libipq/libipq.c b/libipq/libipq.c
index e330487..fb65971 100644
--- a/libipq/libipq.c
+++ b/libipq/libipq.c
@@ -231,7 +231,6 @@ struct ipq_handle *ipq_create_handle(uint32_t flags, uint32_t protocol)
         
 	if (h->fd == -1) {
 		ipq_errno = IPQ_ERR_SOCKET;
-		close(h->fd);
 		free(h);
 		return NULL;
 	}
-- 
1.7.5.2

