Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48791C4727C
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E617721D91
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ZbKUuQX7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgIYMtw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbgIYMtu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180DEC0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:50 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w1so2373494edr.3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wbmo206wtWTsOQrwwYS0sv3SqIE/iPdanIZPGn0XkAs=;
        b=ZbKUuQX7ZE1V0GSmbnWIy0t5qHSSVMDDNprD0rX/xWnOWzjqWXXIouoiNnK391FDMv
         5A5bKGNj9mesouquK4CD5O9MfuiKZqQXINrHFIpgAS6ltH2gc8XcFdwwDUS/piASj9R+
         Ze/85m6ijh8KvbV3CawHLlqVWV8ghH1J4NwNZW9eNVLgPgNeLb5FKpCmTSDZvdtBTPRj
         FIluH3wtPHZZ8SOipV34Ge5Tsr9ZBEHBiIMqS3OwPh+he92nXgysvmaZjJYtRo5aPbbK
         Q7FzDUiWhp424A2XEpGCg/gPx7O+F4VNBoiJaHH0jkmM6ZLkesTFj5RC+FkuBqj3oRTG
         Zwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wbmo206wtWTsOQrwwYS0sv3SqIE/iPdanIZPGn0XkAs=;
        b=SfptopI5JR5vTi2FMUTEcYChUhJTqde9kfK7+2LR2PdWsIXcIi/HN94t1Ph/kyMbA4
         FVYEU/NziOLkEm1QYoxtduBR/zhYFpSNh08kVo4pc0tHcuASzL1zUqfu39iFlTCiAIOT
         6WbWqP+0owtG2MkIwaBC4Fbs8za573N0WJxNXCfuELcQSaKW+ZrgngJ1FCu7PR78SarL
         MwLYHVAZf380fLjxloe0n7MJ0FjAKY1RCZDz2Prisx1SVoPYm/Lu4TFLF57iSvPBiWHb
         Qus4hQe0X3K3dBfTEL5dRHoY1DwM1qcVK3TVSpQFAjGXTpTl+HflhaLy+1y4ydHDGQyX
         8awg==
X-Gm-Message-State: AOAM533QouFcXQgQaTxZhTT8fVP+eAJRHSjYWQySjZIqPHRGi2Vyj3Cj
        kAEy/o4WQTXrIMKsHmWrWp9ypQfogvjBIg==
X-Google-Smtp-Source: ABdhPJxyESPQGk2Bw114+IfJ9H/cu+9+GAZWsvg5Pd1ZM1mB2fYHz/OtXLwtW5FPLkk+1cF3123ICA==
X-Received: by 2002:aa7:d144:: with SMTP id r4mr1097441edo.303.1601038188445;
        Fri, 25 Sep 2020 05:49:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:48 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 8/8] tests: dumping ct entries in opts format
Date:   Fri, 25 Sep 2020 14:49:19 +0200
Message-Id: <20200925124919.9389-9-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add tests to cover dumping ct entries in "opts" format by conntrack

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/test-conntrack.c    | 14 ++++++
 tests/conntrack/testsuite/09dumpopt | 77 +++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 tests/conntrack/testsuite/09dumpopt

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-conntrack.c
index 90bdc5b..372e025 100644
--- a/tests/conntrack/test-conntrack.c
+++ b/tests/conntrack/test-conntrack.c
@@ -81,6 +81,11 @@ int main()
 			res++;
 			for (; *res == ' ' || *res == '\t'; res++);
 			cmd = res[0];
+			cmd_opt = &res[1];
+			for (; *cmd_opt == ' ' || *cmd_opt == '\t'; cmd_opt++);
+			res = strchr(cmd_opt, '\n');
+			if (res)
+				*res = '\0';
 
 			if (cur_cmd && cmd != cur_cmd) {
 				/* complete current multi-line command */
@@ -111,6 +116,15 @@ int main()
 				cmd_strappend(CT_PROG);
 				cmd_strappend(" ");
 				cmd_strappend(buf);
+				if (cmd == '|') {
+					cmd_strappend(" | ");
+					if (cmd_opt[0]) {
+						cmd_strappend("sed \"");
+						cmd_strappend(cmd_opt);
+						cmd_strappend("\" | ");
+					}
+					continue;
+				}
 				cmd_reset();
 				break;
 			}
diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
new file mode 100644
index 0000000..0e3c649
--- /dev/null
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -0,0 +1,77 @@
+# test opts output for -L
+# create
+# create a conntrack
+-w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-I - ; OK
+# copy ipv4 bits to zone 11
+-L -w 10 -o opt -f ipv4 ; |s/-w 10/-w 11/g
+-I - ; OK
+# copy ipv6 bits to zone 11
+-L -w 10 -o opt -f ipv6 ; |s/-w 10/-w 11/g
+-I - ; OK
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
+-w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-I - ; OK
+# move ipv4 bits to zone 11
+-D -w 10 -o opt -f ipv4 ; |s/-w 10/-w 11/g
+-I - ; OK
+# move ipv6 bits to zone 11
+-D -w 10 -o opt -f ipv6 ; |s/-w 10/-w 11/g
+-I - ; OK
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

