From: Christian Engelmayer <christian.engelmayer@frequentis.com>
Subject: [PATCH] iptables: missing free() in function delete_entry()
Date: Thu, 8 Mar 2012 15:20:41 +0100
Message-ID: <20120308152041.7a789c4f@frequentis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <christian.engelmayer@frequentis.com>,
	<franz.flasch@frequentis.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.frequentis.com ([212.186.194.131]:26179 "EHLO
	mail1.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2CHOaL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Mar 2012 09:30:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Franz Flasch <franz.flasch@frequentis.com>

Fixed a memory leak in the dry run path of function delete_entry().

Signed-off-by: Franz Flasch <franz.flasch@frequentis.com>
Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
---

--- iptables-1.4.12.2/libiptc/libiptc.c	2012-01-02 18:19:09.000000000 +0100
+++ iptables-1.4.12.2-modified/libiptc/libiptc.c	2012-03-08 14:27:24.000000000 +0100
@@ -2001,8 +2001,10 @@ static int delete_entry(const IPT_CHAINL
 			continue;
 
 		/* if we are just doing a dry run, we simply skip the rest */
-		if (dry_run)
+		if (dry_run){
+			free(r);
 			return 1;
+		}
 
 		/* If we are about to delete the rule that is the
 		 * current iterator, move rule iterator back.  next
