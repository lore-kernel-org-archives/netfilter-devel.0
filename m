Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866EAC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFA364E0B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhA2V0r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhA2V0j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:26:39 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFE8C06178A
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id n6so12175129edt.10
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3X2wXxBUihvqIB1oIHiX25oeZflLxd7tMXgNghpOdEA=;
        b=OqFc8z8pTIL/1IpVVDRFI6+/EcbwQQTtdhy35hSIyWCIuRzbqvQp1kc8wPwiJkpcsz
         GB5/d8N5k86IxIAGC9nnCehGy1nLio4+MHL+Zr+H2Ncg2U0dOkZBg7TZvUxjREHKZAWz
         CACPhAitLUuvmfka4iNJeAeawklWOz9AZvCaevpsYya6sutX5EYtUmpL7I5KhIiH75LS
         N9agPCfy9C3FxwqQEx4rRP+LiPK2wvF0feTgWDU5cxYVGLCrgSUjuOtEgoKHTdJV7r5B
         teq0JaRbAFU7BOagOhQuOvaHZgrfsiaftgq5V1Py27Cp+JMr1vGYIGOOJSwCsktDferO
         MxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3X2wXxBUihvqIB1oIHiX25oeZflLxd7tMXgNghpOdEA=;
        b=hyZKWFtrfo+qhSNz3ojPk2vkpsWF08cxfng4HdD+i/VQJlF0UcnNg6Ma0mtEwIR9wo
         Mcl8fxoUMjKA/Qb1ROxslAjRbV3SittmvwfYGbEHQQ/iSGi5z78TLHKZmAUrPLoFFHot
         7/l9etDpY8O0VGx9F0YK9bSgeHAMxqIwfGos9ZHirU88IgpFujoicgYHOnY7ure2CnTz
         7c+HJmqcM5XSsQan/FjBWWQEYmkL6+WNlfHvcVBAwht8UyX+eQ1oJ6raGx1fpKjpelAa
         zUiOZHnXMnEZn2kTWVUTgYqSApDkeSQccjvFX2u9EcRCfuMya/Lt0bgTz4mBE2ShZ2D7
         le0A==
X-Gm-Message-State: AOAM533JLRlI88MgHuQzizaPNkrymKTqiIwxrCtAYRJNLnvCdX+kdPjg
        Fd12afMkDI3jYfrd4W2U/JDbOmArInnQMA==
X-Google-Smtp-Source: ABdhPJy0hm7hYqyicRV0Yg49xIymWapxlNsW5imDGfBGrahgzffMxWw0UUSmjwe3U5DFEVFlIlEXbQ==
X-Received: by 2002:a50:cf02:: with SMTP id c2mr7364814edk.333.1611955521078;
        Fri, 29 Jan 2021 13:25:21 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:20 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 8/8] tests: conntrack -L/-D ip family filtering
Date:   Fri, 29 Jan 2021 22:24:52 +0100
Message-Id: <20210129212452.45352-9-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tests to cover conntrack -L and conntrack -D with and w/o
family (-f) specfied.

conntrack -L and contnrack -D shold list/delete
both IPv4 and IPv6 entries if no family is specified,
and should ony display the corresponding entries if
the family is given.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/testsuite/09dumpopt | 72 ++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
index 0d5d9d4..447590b 100644
--- a/tests/conntrack/testsuite/09dumpopt
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -74,4 +74,74 @@
 # delete v6 conntrack
 -D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
 # delete icmp ping request entry
--D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
\ No newline at end of file
+-D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+#
+# Additional tests to check that family attribute is treated properly
+# for -L and -D commands
+# namely:
+# - if family (-f) is given - only entries of the given family are dumped/deleted
+# - if no family is given - entries of both ipv4 and ipv6 families are dumped/deleted
+# First create some ipv4 and ipv6 entries
+-I -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump all entries to zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that both ipv4 and ipv6 entries get copied (delete for each of them should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv4 entries to zone 11
+-L -w 10 -o save -f ipv4; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that only ipv4 entries get copied (delete only for ipv4 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv6 entries to zone 11
+-L -w 10 -o save -f ipv6; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that only ipv6 entries get copied (delete only for ipv6 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# now test deleting w/ and /o family specified
+# for simplicity do it by re-creating entries in zone 11
+# by copying ezisting entries from zone 10 into it
+# re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete all entries in zone 11
+-D -w 11 ; OK
+# both ipv4 and ipv6 should be deleted
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete only ipv4 entries in zone 11
+-D -w 11 -f ipv4 ; OK
+# ipv6 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+ # re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete only ipv6 entries in zone 11
+-D -w 11 -f ipv6 ; OK
+# ipv4 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# clean up after yourself
+-D -w 10 ; OK
-- 
2.25.1

