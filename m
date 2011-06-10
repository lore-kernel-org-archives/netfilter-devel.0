From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 6/8] iptables: Coverity: VARARGS
Date: Fri, 10 Jun 2011 15:26:00 +0200
Message-ID: <1307712362-17727-7-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1FJN0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:48 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQm9x009064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:48 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xtables.c:931: va_init: Initializing va_list "args".
xtables.c:938: missing_va_end: va_end was not called for "args".
xtables.c:947: missing_va_end: va_end was not called for "args".
xtables.c:961: missing_va_end: va_end was not called for "args".
---
 iptables/xtables.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index ee38421..9a43612 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1042,8 +1042,10 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 	case XTF_ONLY_ONCE:
 		p2 = va_arg(args, const char *);
 		b  = va_arg(args, unsigned int);
-		if (!b)
+		if (!b) {
+			va_end(args);
 			return;
+		}
 		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option may only be specified once",
 		           p1, p2);
@@ -1051,8 +1053,10 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 	case XTF_NO_INVERT:
 		p2 = va_arg(args, const char *);
 		b  = va_arg(args, unsigned int);
-		if (!b)
+		if (!b) {
+			va_end(args);
 			return;
+		}
 		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option cannot be inverted", p1, p2);
 		break;
@@ -1065,8 +1069,10 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		break;
 	case XTF_ONE_ACTION:
 		b = va_arg(args, unsigned int);
-		if (!b)
+		if (!b) {
+			va_end(args);
 			return;
+		}
 		xt_params->exit_err(PARAMETER_PROBLEM,
 		           "%s: At most one action is possible", p1);
 		break;
-- 
1.7.5.2

