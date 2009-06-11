From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] iptables: close open file descriptors
Date: Thu, 11 Jun 2009 13:11:21 +0200
Message-ID: <1244718682-2497-5-git-send-email-jengelh@medozas.de>
References: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38300 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762857AbZFKLLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:23 -0400
In-Reply-To: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just for correctness, close some file descriptors that were opened.
(E.g. ip6tables-save reading from procfs files.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    2 ++
 ip6tables-save.c    |    1 +
 iptables-restore.c  |    2 ++
 iptables-save.c     |    1 +
 iptables-xml.c      |    2 ++
 5 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 1d5efea..06a82ae 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -454,5 +454,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (in != NULL)
+		fclose(in);
 	return 0;
 }
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 97205c1..c59608f 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -54,6 +54,7 @@ static int for_each_table(int (*func)(const char *tablename))
 		ret &= func(tablename);
 	}
 
+	fclose(procfile);
 	return ret;
 }
 
diff --git a/iptables-restore.c b/iptables-restore.c
index 2a797cc..5108fda 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -459,5 +459,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (in != NULL)
+		fclose(in);
 	return 0;
 }
diff --git a/iptables-save.c b/iptables-save.c
index 6000b49..f63ee6b 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -52,6 +52,7 @@ static int for_each_table(int (*func)(const char *tablename))
 		ret &= func(tablename);
 	}
 
+	fclose(procfile);
 	return ret;
 }
 
diff --git a/iptables-xml.c b/iptables-xml.c
index e5d1941..daf4208 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -870,6 +870,8 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (in != NULL)
+		fclose(in);
 	printf("</iptables-rules>\n");
 	free_argv();
 
-- 
1.6.3.1

