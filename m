From: Christian Engelmayer <christian.engelmayer@frequentis.com>
Subject: [PATCH] iptables: missing free() in function cache_add_entry()
Date: Thu, 8 Mar 2012 15:20:37 +0100
Message-ID: <20120308152037.639adf51@frequentis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <christian.engelmayer@frequentis.com>,
	<franz.flasch@frequentis.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.frequentis.com ([212.186.194.131]:12941 "EHLO
	mail1.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab2CHOa0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Mar 2012 09:30:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Franz Flasch <franz.flasch@frequentis.com>

Fixed a memory leak in the error path of function cache_add_entry().

Signed-off-by: Franz Flasch <franz.flasch@frequentis.com>
Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
---

--- iptables-1.4.12.2/libiptc/libiptc.c	2012-01-02 18:19:09.000000000 +0100
+++ iptables-1.4.12.2-modified/libiptc/libiptc.c	2012-03-08 14:24:24.000000000 +0100
@@ -1012,6 +1012,7 @@ new_rule:
 			if (t->target.u.target_size
 			    != ALIGN(sizeof(STRUCT_STANDARD_TARGET))) {
 				errno = EINVAL;
+				free(r);
 				return -1;
 			}
 
