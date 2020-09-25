Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD2EC4741F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B382075E
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="YOI+Ms8B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgIYM6G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgIYMtr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:47 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441A3C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w1so2373337edr.3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYSZlWPccmhB/zYCiVJbunvrem0oE06lPNleWa7CLtE=;
        b=YOI+Ms8BWoVDWMojBX6ORusPHLgt1sfGzk29GaWOb2vlkxx0MjNM48CyG3xoz8C8pr
         or5gI9W88jpRy5bZ3bpAwHbIk+y2datxVm9gkZWAg7DmxD/Yg28/xZzBQZb5wQs7BE7V
         OCmD5pRNtw0Dmkbsz4MHgQg7o9zh/QshoC6Z+ChmlJHlh8R0dc7fmtjCxGrkcdUYCvGC
         ihpPUWNUZxmV//xWjXGZvwkG1kQ/VijUmg1eLmxBx5PjRxuwh2AyViT+7QYcrTM7+NbI
         sQn4UB0ujAF0xX3fKyi7lOi4oUEM5P+V2cGwwk+C/rcqhY2kfDHZSM+VNXmdJvL6y8AF
         husA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYSZlWPccmhB/zYCiVJbunvrem0oE06lPNleWa7CLtE=;
        b=p4Gepo9zsHeO1+yHHIETwNSkX7rOydtQciXOTcz1B2Z3nmzuCm3jUqPrriquWIbaXt
         U55EBYnP8+3SaC3qdrkKfNQlG2wZBBaURA5Kxqg2S1ooQie8jxNOwr6IVBtT70hWHNdP
         xeRHT+BLuROAE/aCLss5hNLO0GX/1U9OYXMn9875r1QgXWPPkAXbPN3kRQNkgzWopnUl
         pjV8WXyOLQ35w3BNwOfKoBMp7jhPFzArFkzaBy/yPkKOJQv+GO+cHhHA+FWbiD5uIWdy
         99KGTDuLqAO+vImVwjV+BzBgGvnUHQABk4H4rG6xJ8DDu3DTjAmDHt3J6ZQ0NFVUJ+Ah
         mxzw==
X-Gm-Message-State: AOAM533AbztGhCa/PWZjawNlQwC7khoEW3tU7AYa1awpjA3emtV/b8lD
        Tle1oAf67fBnqTFgFj1UcNh/dHhkuPJtEw==
X-Google-Smtp-Source: ABdhPJyWPj945QwFsm2vnSk+jxf3XUBN6AGKYuqBU2Y/Jh99nihmH7ROrjbG15GP/Y1a5Psz8mAqGQ==
X-Received: by 2002:aa7:c419:: with SMTP id j25mr1116828edq.109.1601038185633;
        Fri, 25 Sep 2020 05:49:45 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:45 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 5/8] tests: conntrack parameters from stdin
Date:   Fri, 25 Sep 2020 14:49:16 +0200
Message-Id: <20200925124919.9389-6-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add tests to cover handling parameters from stdin by conntrack

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/test-conntrack.c  | 70 +++++++++++++++++++++++++------
 tests/conntrack/testsuite/08stdin | 62 +++++++++++++++++++++++++++
 2 files changed, 120 insertions(+), 12 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-conntrack.c
index 76ab051..90bdc5b 100644
--- a/tests/conntrack/test-conntrack.c
+++ b/tests/conntrack/test-conntrack.c
@@ -28,6 +28,23 @@ int main()
 	struct dirent *dent;
 	char file[1024];
 	int i,n;
+	char cmd_buf[1024 * 8];
+	int i_cmd_buf = 0;
+	char cmd, cur_cmd = 0;
+	char *cmd_opt;
+
+#define cmd_strappend(_s) do { \
+	char * pos = stpncpy(cmd_buf + i_cmd_buf, _s, sizeof(cmd_buf) - i_cmd_buf); \
+	i_cmd_buf = pos - cmd_buf; \
+	if (i_cmd_buf == sizeof(cmd_buf)) { \
+		printf("buffer full!\n"); \
+		exit(EXIT_FAILURE); \
+	} \
+} while (0)
+
+#define cmd_reset() do { \
+		i_cmd_buf = 0; \
+} while (0)
 
 	n = scandir("testsuite", &dents, NULL, alphasort);
 
@@ -48,9 +65,7 @@ int main()
 		}
 
 		while (fgets(buf, sizeof(buf), fp)) {
-			char tmp[1024] = CT_PROG, *res;
-			tmp[strlen(CT_PROG)] = ' ';
-
+			char *res;
 			line++;
 
 			if (buf[0] == '#' || buf[0] == ' ')
@@ -63,27 +78,58 @@ int main()
 				exit(EXIT_FAILURE);
 			}
 			*res = '\0';
-			res+=2;
+			res++;
+			for (; *res == ' ' || *res == '\t'; res++);
+			cmd = res[0];
+
+			if (cur_cmd && cmd != cur_cmd) {
+				/* complete current multi-line command */
+				switch (cur_cmd) {
+				case '\n':
+					cmd_strappend("\" | ");
+					break;
+				default:
+					printf("Internal Error: unexpected multiline command %c",
+							cur_cmd);
+					exit(EXIT_FAILURE);
+					break;
+				}
+
+				cur_cmd = 0;
+			}
+
+			switch (cmd) {
+			case '\n':
+				if (!cur_cmd) {
+					cmd_strappend("echo \"");
+					cur_cmd = cmd;
+				} else
+					cmd_strappend("\n");
+				cmd_strappend(buf);
+				continue;
+			default:
+				cmd_strappend(CT_PROG);
+				cmd_strappend(" ");
+				cmd_strappend(buf);
+				cmd_reset();
+				break;
+			}
 
-			strcpy(tmp + strlen(CT_PROG) + 1, buf);
-			printf("(%d) Executing: %s\n", line, tmp);
+			printf("(%d) Executing: %s\n", line, cmd_buf);
 
 			fflush(stdout);
-			ret = system(tmp);
+			ret = system(cmd_buf);
 
 			if (WIFEXITED(ret) &&
 			    WEXITSTATUS(ret) == EXIT_SUCCESS) {
-			    	if (res[0] == 'O' &&
-				    res[1] == 'K')
+				if (cmd == 'O')
 					ok++;
 				else {
 					bad++;
 					printf("^----- BAD\n");
 				}
 			} else {
-				if (res[0] == 'B' &&
-				    res[1] == 'A' &&
-				    res[2] == 'D')
+				if (cmd == 'B')
 					ok++;
 				else {
 					bad++;
diff --git a/tests/conntrack/testsuite/08stdin b/tests/conntrack/testsuite/08stdin
new file mode 100644
index 0000000..cf3eadd
--- /dev/null
+++ b/tests/conntrack/testsuite/08stdin
@@ -0,0 +1,62 @@
+# create
+# create a conntrack
+-s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-I - ; OK
+# create again
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# make sure create again with stdio mode fails as well
+-s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+-I - ; BAD
+-r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+-I - ; BAD
+# empty lines are ignored
+;
+-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+-I - ; BAD
+# spaces or tabs are ignored as well
+  ;
+		;
+-t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-I - ; BAD
+# delete
+-s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# empty lines should be just ignored
+;
+;
+# delete reverse
+-r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ;
+# empty lines with spaces or tabs should be ignored as well
+ ;
+	;
+		;
+  ;
+	    ;
+	    	    	;
+# delete v6 conntrack
+-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# delete icmp ping request entry
+-u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+;
+;
+-D - ; OK
+# create again - should succeed now
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete again (for cleanup)
+-s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ;
+-r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ;
+-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ;
+-u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+;
+-D - ; OK
-- 
2.25.1

