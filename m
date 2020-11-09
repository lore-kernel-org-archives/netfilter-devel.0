Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF49AC388F7
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8066F2068D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="D9O+iWRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgKISSD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISSD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:18:03 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE73C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:18:02 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id i19so13646539ejx.9
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2020 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zb9R1+Y42x5d8PEpk+2UZ9me3FesaiP5esGofrPJMdY=;
        b=D9O+iWRYf8HliDQzqJRV85NImIOlRlZjIn+m2RbPxSTFv3YdMDsvFH3Ay9CbZrjtOP
         IxGlmyX9xdYm7nAre0oEt40NCE2MP4rf+caGX60fs9A2T3NE4N5iFlmPr6rnFsu1q5x5
         9g8tLi3+ylp2wDhUGddVGEm8Thgf2aTB6yBxa5kAnXgqI6bhU3uS7YgiVn3WH41Bi3Bl
         +KpiI7hRnNt9i7aKNpjnOoZelzVEuNFhOjvXRr7721fjQZqPKzPOR0tKiwzw2/Aq5r9w
         VSouP6inHgTRpx3UycCxOJj9ZYSKXEjkR2gcZRkfoQ/69DMfyX5RKc0tOraaXT9fg95/
         /BWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zb9R1+Y42x5d8PEpk+2UZ9me3FesaiP5esGofrPJMdY=;
        b=RpxB+vtEmnizcH9wtUd+kjRJtgwc140h3zprEkog9R4GrV993zp03kosfkkqlKnXAy
         lE8i+cFGnUp6dM3NHj0zHxLlk/9EKrEL7JLIkeJaxjzyZgUfzy1W9a1eQ0szcnK0DtJU
         /vKQ9m072fNjTmSP/CCBnjNJfA3FEijW8PHn7+04NlFSssVIEXhW4cfCZReBQc6i4mWI
         7zbMlsZomvUxLsVvdMipzr1IdMmpNHRCCcXHiDu4h34Js3ayZB9tPCuyqkWUUqz7D5cE
         xcLL18ERt/JeD54VSPG+QpAxd/u87N1Z4LnZd7jqpFDZJcqr1FFyrAF0EbClothdPd45
         3w2g==
X-Gm-Message-State: AOAM533NjUEOTo9DLS/uIulS+pZpvIP6gENlL6ydwa1N6ejwVjCmd2vA
        W1+F3qUz5qXtu6ZfpKsLfCTEZwN13J+hmw==
X-Google-Smtp-Source: ABdhPJxtKR11TfGGwqti4HHfY50XvxdkxM9lLIv0Lbb1Yi9PrZbosFmTCYUUdfFO4anddsN+XNFuPQ==
X-Received: by 2002:a17:906:4145:: with SMTP id l5mr15785162ejk.317.1604945880766;
        Mon, 09 Nov 2020 10:18:00 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id g25sm9056273ejh.61.2020.11.09.10.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:18:00 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 3/4] tests: saving and loading ct entries, save format
Date:   Mon,  9 Nov 2020 19:17:40 +0100
Message-Id: <20201109181741.52325-4-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
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

