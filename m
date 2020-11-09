Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A57C61DD8
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2BBB2068D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="G2PKjLBq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgKISSE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgKISSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:18:04 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA69FC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:18:03 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f23so7011098ejk.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2020 10:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3X2wXxBUihvqIB1oIHiX25oeZflLxd7tMXgNghpOdEA=;
        b=G2PKjLBqZYJOcZcCv8bp6YLMTiTVna9JAfFSfUJBLOgnNh7Je7/SHH7OlCEiG7343I
         Wqx5cBUuuRA2f51yExzkSgkkXCyED/biqDwcvSECRQlR5rbn1jYYMDDzRXFMl22D4ZCA
         DhcI79XQ+AQMr02sV8iVDOFthyWKK4UqG9Xad6bG6TRjDjMfwwRmMWNRcftOCgDgEqaw
         WQPFtOh/5Kf9LshEmOhTBoT9NDih3h6LVgMNbZi02n9BpejhxGlkzjIPQc6VfNtmRaad
         xzmevlWDA9fXdsVOJ546ugxjQbZjmpzNunjOAalZc+LuZvLtMNWghh35Q9NHMgNzUqMt
         dcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3X2wXxBUihvqIB1oIHiX25oeZflLxd7tMXgNghpOdEA=;
        b=dRjpyHtkE51jXZodS51POtB7XSLL5WylzdjjvaFW4fNGCRiQtJRUD/gv1+UrRLuyEW
         VlIsPEmMJ89pExAN3w9Nxu3KPmO5XFLR1+TBTPTyvUQF2vU5UPTqaTWg6ubxx+h/ARbw
         i2h+ZwPR8Eoqi3Ym2C7fZf914Z57J9QLpT4f7xVJJ/EZSejr2nIAG7xlWUrZSyeOiNl7
         hZqBQYEyDemAp/khaHQoKo2bPl65ll4XKQ4FAWmtKzMU2+QzagnyG59vpqIq9pGBPkTd
         hCOaUSHvZipONvvgz5ER7zpN9B12381msEgvpCUcXYLQ7II8JQz4JCSku7lKiEYFI6cf
         lmyQ==
X-Gm-Message-State: AOAM530wZQ36PXWCIKUnBMGL+ISNRg/raYqcPrc4qugEIhtB7JSe6ylT
        LZc/0jeHSiLl8i6Y/ErX//a9coYDsae/1g==
X-Google-Smtp-Source: ABdhPJzbwaaq95951hFwmY3HdDd11b5AR67XMqhiooXuI9Q3Hxz2plfYYydZwEWhPyFqpYdM4MV/Hg==
X-Received: by 2002:a17:906:1f13:: with SMTP id w19mr15900438ejj.39.1604945881945;
        Mon, 09 Nov 2020 10:18:01 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id g25sm9056273ejh.61.2020.11.09.10.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:18:01 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 4/4] tests: conntrack -L/-D ip family filtering
Date:   Mon,  9 Nov 2020 19:17:41 +0100
Message-Id: <20201109181741.52325-5-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
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

