Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5F7C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 20:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A22420830
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 20:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLloo1sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfCDUKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:10:12 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39409 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDUKM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 15:10:12 -0500
Received: by mail-pg1-f194.google.com with SMTP id h8so3843854pgp.6
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Mar 2019 12:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:from:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PrSwq+CGZSMe8eOaYRL/53U3ivqlhy7r4fnhJhz8Xic=;
        b=KLloo1svcZZR+MQg20/NUgfhp8SpeYTu+jbUw45Pw5LKBQa1L4uTyZ0MPLziIH3C52
         7st4xQXv8l0UEoLxNTBAxEZtr7mIwCYw1i8hmTif2jDZdZMku2hLL9n7+hQ570OKExRD
         dK4WaYeYFdm5d7/edMMNGkMl45VdpaTRNw5muwyzTKqkrD5Ss6zOJtq4Y9YT1FEUXI6A
         +eULlh5AKtkZVWmPk3gq7jlwro7JZoHA2NfXu6IaTpxMkrQIyyAoMJcV832aN2D0Q3gW
         sXJpOorgqSBLyRDFlJqW6IV13CotgLgq3ZwKJqk/CP95atq/3Bzw/Jq2UOJYc422Jk5z
         eyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PrSwq+CGZSMe8eOaYRL/53U3ivqlhy7r4fnhJhz8Xic=;
        b=c1dzJ92k63/8w13xeUWcqVHb6WUD/SdAtco9PA8xQw8Ejd1jZwxUQu/iEWApObiP+S
         6QwxHn9psHUkVX1+w1ieBV2Rab5MuzBD0O6Vw5ZsEATcTsAF3H/2LaXpTK9debURfM4H
         FgXyEh6lK7iJ8AXFRO9I1KngdwCNFhXYYL3cx3RXhlQ6HRfBJpiw/JU5xvF2TAqMg6z8
         uFetS/nvxvSr/igJOQ9JToqAL4Dh0f2SkL5WJC2g6Cj4owfjjO48VZMwb06FWDpVvpJE
         hUP+LVviMn9OZHU3rReJlG+MInQONVzczA4q0Iovla240mOxJ3N3oiJVG7xWa+TFJtEG
         QlpQ==
X-Gm-Message-State: APjAAAX+h1HDk26f+83DphOLSjRh5bhunItc5uFgT8xyRvqcNdARhp5w
        HTYe45aYUJFYnzOWvJXLeXBn1bJc
X-Google-Smtp-Source: APXvYqwfoIyHrPBlYR6+qTSQE+wkYg7fKCiCyrRVKrKY/mTuSiEQuZrqMcfWCqb8VobSp7ux8xathA==
X-Received: by 2002:a63:5720:: with SMTP id l32mr20152813pgb.268.1551730210769;
        Mon, 04 Mar 2019 12:10:10 -0800 (PST)
Received: from mua.localhost (99-7-172-215.lightspeed.snmtca.sbcglobal.net. [99.7.172.215])
        by smtp.gmail.com with ESMTPSA id w17sm10285265pfn.63.2019.03.04.12.10.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 12:10:10 -0800 (PST)
Reply-To: pgnet.dev@gmail.com
Subject: Re: xtables-addons build fail with linux 5.0: "error: implicit
 declaration of function 'do_gettimeofday'; did you mean 'do_settimeofday64'?"
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     netfilter-devel@vger.kernel.org
References: <c4382224-6bfa-3604-28c4-4ab1ea61e943@gmail.com>
 <7604c2e7-e477-028f-d0cd-2b57a56c08b1@gmail.com>
Message-ID: <24a74393-c0ef-72ae-88df-81734c27f699@gmail.com>
Date:   Mon, 4 Mar 2019 12:10:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <7604c2e7-e477-028f-d0cd-2b57a56c08b1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

this patch,

  https://bugzilla.opensuse.org/show_bug.cgi?id=1127790#c3

--------
diff -ur xtables-addons-3.2.ORIG/extensions/xt_SYSRQ.c xtables-addons-3.2/extensions/xt_SYSRQ.c
--- xtables-addons-3.2.ORIG/extensions/xt_SYSRQ.c	2018-09-07 06:04:28.000000000 -0700
+++ xtables-addons-3.2/extensions/xt_SYSRQ.c	2019-03-04 12:01:16.426428277 -0800
@@ -314,7 +314,7 @@
 static int __init sysrq_crypto_init(void)
 {
 #if defined(WITH_CRYPTO)
-	struct timeval now;
+	struct timespec64 now;
 	int ret;
 
 	sysrq_tfm = crypto_alloc_shash(sysrq_hash, 0, 0);
@@ -339,7 +339,10 @@
 		    sizeof(sysrq_password), GFP_KERNEL);
 	if (sysrq_digest_password == NULL)
 		goto fail;
-	do_gettimeofday(&now);
+/* https://github.com/torvalds/linux/blob/master/Documentation/core-api/timekeeping.rst
+ * https://gitlab.com/snippets/1799795
+ */
+	ktime_get_real_ts64(&now);
 	sysrq_seqno = now.tv_sec;
 	return 0;
--------

appears to enable an ok build.
