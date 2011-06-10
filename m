From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 4/8] iptables: Coverity: REVERSE_INULL
Date: Fri, 10 Jun 2011 15:25:58 +0200
Message-ID: <1307712362-17727-5-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1FJN0o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:44 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQiPZ006013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:44 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6tables-restore.c:186: deref_ptr_in_call: Dereferencing pointer "in".
ip6tables-restore.c:463: check_after_deref: Dereferencing "in" before a null check.

iptables-restore.c:192: deref_ptr_in_call: Dereferencing pointer "in".
iptables-restore.c:468: check_after_deref: Dereferencing "in" before a null check.

iptables-xml.c:671: deref_ptr_in_call: Dereferencing pointer "in".
iptables-xml.c:873: check_after_deref: Dereferencing "in" before a null check.
---
 iptables/ip6tables-restore.c |    3 +--
 iptables/iptables-restore.c  |    3 +--
 iptables/iptables-xml.c      |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 420bc52..ae147d5 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -460,7 +460,6 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (in != NULL)
-		fclose(in);
+	fclose(in);
 	return 0;
 }
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 2624599..1cb833c 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -465,7 +465,6 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (in != NULL)
-		fclose(in);
+	fclose(in);
 	return 0;
 }
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index e2cb809..f340889 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -866,8 +866,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (in != NULL)
-		fclose(in);
+	fclose(in);
 	printf("</iptables-rules>\n");
 	free_argv();
 
-- 
1.7.5.2

