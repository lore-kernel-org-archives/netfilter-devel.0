From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 8/8] iptables: Coverity: RESOURCE_LEAK
Date: Fri, 10 Jun 2011 15:26:02 +0200
Message-ID: <1307712362-17727-9-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab1FJN0w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:52 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQqlc018732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:52 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xtables.c:320: alloc_fn: Calling allocation function "get_modprobe".
xtables.c:294: alloc_fn: Storage is returned from allocation function "malloc".
xtables.c:294: var_assign: Assigning: "ret" = "malloc(1024UL)".
xtables.c:304: return_alloc: Returning allocated memory "ret".
xtables.c:320: var_assign: Assigning: "buf" =  storage returned from "get_modprobe()".
xtables.c:323: var_assign: Assigning: "modprobe" = "buf".
xtables.c:348: leaked_storage: Variable "buf" going out of scope
               leaks the storage it points to.
xtables.c:348: leaked_storage: Returning without freeing "modprobe"
               leaks the storage that it points to.
---
 iptables/xtables.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 9a43612..951fca1 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -362,6 +362,7 @@ int xtables_insmod(const char *modname, const char *modprobe, bool quiet)
 		/* not usually reached */
 		exit(1);
 	case -1:
+		free(buf);
 		return -1;
 
 	default: /* parent */
-- 
1.7.5.2

