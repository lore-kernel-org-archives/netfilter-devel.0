Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADB1C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 22:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353526AbiFUW5E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiFUW5C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 18:57:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845822E6BD
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:57:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id es26so19692889edb.4
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1i3j+Af/AE+5g2ZVPWN0z/6ECtSWzAGHsfOQHvKBUdM=;
        b=MwgKtPT2LHvCfqBaMWsaNmA/QPPGbFplHKpehshypg3MmTwICK4eGS7jphn0CioiSk
         13fRlfEOiJnNrULgahuF1YeGi0l9aXz8MN9czeetMU+rY5lSUcKJhywHAFTiSiu5Qg1V
         ZNjx1TpueBhEIhleO1hY1hSB6RDaAFSWArzQb2NHTKABOZJj7f1iwh6n3sPi51VsnKVi
         vvUmbXwjUn3T+6a5V4tAoaUvegG9JjixjlZSdvLES9VgqET+0LgnJEtOeATGNC+5MRAI
         DAT4QR/N6YRCoko58811UNLPFMQneQ1mAlIrgwhUz6qkDXfikFdQG0pzMD4mlH9UWttc
         wF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1i3j+Af/AE+5g2ZVPWN0z/6ECtSWzAGHsfOQHvKBUdM=;
        b=Wdc3GfCQWYWqz9+px2not5F+h1Et+k6/KeH3FS6zK7rPVs8wKcRT4f0KtGEHMXQvYn
         DbmBwyLdWbNCcpmIi1iBlac11lAjV41wsS8GOgUGhcU2xe/fBx4+WY2UMMtuP0fWfoQJ
         DCgpNRWuPelP1sBscsCQlMEkNSqrfIS2BJZeWQ9yWifEQBQGBjUOa4X5K454U94zevUH
         r0h7xEpajaZA0ejw5G4sOE6880Uzz1yCN4UQwIeEAfHZ7j5LTPXzHX8gLgu9LyfvtD3G
         QRHkG7o1sGKdSLt7K5IpmhOl0qO31djuyGZp0V8eHq901HPoqyqnvx0l1NqFxWvH+6ed
         AQCg==
X-Gm-Message-State: AJIora9WPkxRbJNV5cMZtIFSZNfUZoT/JfdE/C7bencOb66YVi2x9ix+
        U7P2Sdgw6rH811d9/4Mwemvfeid81DzYOQ==
X-Google-Smtp-Source: AGRyM1uDwwPKEI99HF4vGTtbQEGNndXaDyCKyNmagB4XhnB7zB7YkaP2HDliW1Or2pDyRNrpPguNCw==
X-Received: by 2002:a05:6402:c44:b0:431:52cc:f933 with SMTP id cs4-20020a0564020c4400b0043152ccf933mr521606edb.41.1655852219533;
        Tue, 21 Jun 2022 15:56:59 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id z12-20020a50e68c000000b004358c3bfb4csm4540118edm.31.2022.06.21.15.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:56:58 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 3/3] tests/conntrack: -A command support
Date:   Wed, 22 Jun 2022 00:55:47 +0200
Message-Id: <20220621225547.69349-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 tests/conntrack/testsuite/08stdin | 47 ++++++++++++++++++++++++++++++-
 tests/conntrack/testsuite/10add   | 42 +++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 tests/conntrack/testsuite/10add

diff --git a/tests/conntrack/testsuite/08stdin b/tests/conntrack/testsuite/08stdin
index 1d31176..158c4c3 100644
--- a/tests/conntrack/testsuite/08stdin
+++ b/tests/conntrack/testsuite/08stdin
@@ -77,4 +77,49 @@
 -D -w 123 ;
 -R - ; OK
 # validate it via standard command line way
--D -w 123 ; BAD
\ No newline at end of file
+-D -w 123 ; BAD
+# create with -A
+# create a conntrack
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# create again
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# repeat, it should succeed
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
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
diff --git a/tests/conntrack/testsuite/10add b/tests/conntrack/testsuite/10add
new file mode 100644
index 0000000..4f9f3b9
--- /dev/null
+++ b/tests/conntrack/testsuite/10add
@@ -0,0 +1,42 @@
+#missing destination
+-A -s 1.1.1.1 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing source
+-A -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing protocol
+-A -s 1.1.1.1 -d 2.2.2.2 --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing source port
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing destination port
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing timeout
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY ; BAD
+# create a conntrack
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete again
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete reverse
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
+# delete reverse again
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; BAD
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete v6 conntrack
+-D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# mismatched address family
+-A -s 2001:DB8::1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# creae again icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete icmp ping request entry
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
-- 
2.25.1

