Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BBFC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7F864E0B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhA2V0q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhA2V0j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:26:39 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E4FC061788
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id l9so15029687ejx.3
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zb9R1+Y42x5d8PEpk+2UZ9me3FesaiP5esGofrPJMdY=;
        b=OY+e4bGFC3QBKGxgFygYv0ruWsf/XlIV1Ni+GhdEqGJPqwB7UfN2FzaIToGrc4uBOR
         GNFTuGAc9jdaQTSUsp9gKhd6HqxmaqFhCUgFGdq2qnT31W0h2J9WN+dqAzsP2MSiNocJ
         DtasUPpLICi53KC/jSyPool77O4DmyZG8oo57n9Pp8JdUykJHlMNjkvwBMMGCWp140ZN
         qKVwh3TABWCyWly1F0HDR0SRINglrnrdkrSBXR40GAitoS+7MmGKvS28Iu8YYqQ17R2b
         S9hDSN+nOtXF+h7hhSn5n3rehttF7IHnCZxfX2zmQhOZJwHjwJPs11hMACz2vEoXvOqp
         KkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zb9R1+Y42x5d8PEpk+2UZ9me3FesaiP5esGofrPJMdY=;
        b=diiZrTKu1EyRWFR1LQ3bcDmFHMMF15zwzXt50tuZ43+fAfgCuQQ1CAinx/J/lINKH4
         eZ45DDo/SUl7J4pVzKYRKRrswrx1oOrZLFYNovoZnRZEPyPnqixNI2OseCCXNIU7IS2R
         agzn2Qjb5w8td7EfFejZtQlukEr7kP+PCtaXFy6hfoRTtnXxV8Hvqa8LdFFqM8wgwTIl
         zV51J8mIBfzlnzAbDJt2O+ID7npbU9OI9DEbiRvGFOhoWHbE/e+9wR5hKh8g6A9vjkuS
         VdpVguYKFfHa7oj6yVJQzfF4LvaBeyQtofPqcXZHUVcUa6s9mg4l55hDNeG+YPLBUC5P
         DM/Q==
X-Gm-Message-State: AOAM530WPa+46y0nen8FR8tRjTJdusZg1lU8v6Zq1Yfx0bRHNh+l77Rd
        1NprGA15R/wXzKId7dJfJ4odRms12sFt8w==
X-Google-Smtp-Source: ABdhPJw4Jk2NCaORwi7ay02AoeQULkPo1bxLyU92bIhq+KACqxD0nPsml6E9ThbCtJ0HB4EGFjSiBg==
X-Received: by 2002:a17:906:8611:: with SMTP id o17mr6421003ejx.145.1611955520310;
        Fri, 29 Jan 2021 13:25:20 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:19 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 7/8] tests: saving and loading ct entries, save format
Date:   Fri, 29 Jan 2021 22:24:51 +0100
Message-Id: <20210129212452.45352-8-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/test-conntrack.c    | 84 ++++++++++++++++++++++++-----
 tests/conntrack/testsuite/08stdin   | 80 +++++++++++++++++++++++++++
 tests/conntrack/testsuite/09dumpopt | 77 ++++++++++++++++++++++++++
 3 files changed, 229 insertions(+), 12 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin
 create mode 100644 tests/conntrack/testsuite/09dumpopt

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-conntrack.c
index 76ab051..372e025 100644
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
@@ -63,27 +78,72 @@ int main()
 				exit(EXIT_FAILURE);
 			}
 			*res = '\0';
-			res+=2;
+			res++;
+			for (; *res == ' ' || *res == '\t'; res++);
+			cmd = res[0];
+			cmd_opt = &res[1];
+			for (; *cmd_opt == ' ' || *cmd_opt == '\t'; cmd_opt++);
+			res = strchr(cmd_opt, '\n');
+			if (res)
+				*res = '\0';
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
+				if (cmd == '|') {
+					cmd_strappend(" | ");
+					if (cmd_opt[0]) {
+						cmd_strappend("sed \"");
+						cmd_strappend(cmd_opt);
+						cmd_strappend("\" | ");
+					}
+					continue;
+				}
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
index 0000000..38f3b8b
--- /dev/null
+++ b/tests/conntrack/testsuite/08stdin
@@ -0,0 +1,80 @@
+# create
+# create a conntrack
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# create again
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# make sure create again with stdio mode fails as well
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+-R - ; BAD
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+-R - ; BAD
+# empty lines are ignored
+;
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+-R - ; BAD
+# spaces or tabs are ignored as well
+  ;
+		;
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; BAD
+# delete
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# empty lines should be just ignored
+;
+;
+# delete reverse
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ;
+# empty lines with spaces or tabs should be ignored as well
+ ;
+	;
+		;
+  ;
+	    ;
+	    	    	;
+# delete v6 conntrack
+-D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# delete icmp ping request entry
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+;
+;
+-R - ; OK
+# create again - should succeed now
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete again (for cleanup)
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ;
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ;
+-D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ;
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+;
+-R - ; OK
+# delete no entries - should return err
+-D -w 123 ; BAD
+# delete no entries via stdin - should return err as well
+-D -w 123 ;
+-R - ; BAD
+# delete no entries in parallel with adding entries via stdin - should succeed
+# -D and -I should work in parallel
+-D -w 123 ;
+-I -w 123 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+-R - ; OK
+# now deleting entries should return success
+-D -w 123 ;
+-R - ; OK
+# should fail again
+-D -w 123 ;
+-R - ; BAD
+# validate it via standard command line way
+-D -w 123 ; BAD
\ No newline at end of file
diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
new file mode 100644
index 0000000..0d5d9d4
--- /dev/null
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -0,0 +1,77 @@
+# test opts output for -L
+# create
+# create a conntrack
+-I -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-I -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-I -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-I -w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# copy ipv4 bits to zone 11
+-L -w 10 -o save -f ipv4 ; |s/-w 10/-w 11/g
+-R - ; OK
+# copy ipv6 bits to zone 11
+-L -w 10 -o save -f ipv6 ; |s/-w 10/-w 11/g
+-R - ; OK
+# create again in zone 11
+-I -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# delete new entries
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete reverse
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
+# delete v6 conntrack
+-D -w 11-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete icmp ping request entry
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete old entries
+-D -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete reverse
+-D -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
+# delete v6 conntrack
+-D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete icmp ping request entry
+-D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+#
+# now test opts output for -D
+# create entries again
+# create a conntrack
+-I -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-I -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-I -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-I -w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# move ipv4 bits to zone 11
+-D -w 10 -o save -f ipv4 ; |s/-w 10/-w 11/g; s/-D /-I /g
+-R - ; OK
+# move ipv6 bits to zone 11
+-D -w 10 -o save -f ipv6 ; |s/-w 10/-w 11/g; s/-D /-I /g
+-R - ; OK
+# create again in zone 11
+-I -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -w 11 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# delete new entries
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete reverse
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
+# delete v6 conntrack
+-D -w 11-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete icmp ping request entry
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete old entries
+-D -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
+# delete reverse
+-D -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; BAD
+# delete v6 conntrack
+-D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
+# delete icmp ping request entry
+-D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
\ No newline at end of file
-- 
2.25.1

