Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DC4C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 08:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiHAINA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 04:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHAIM7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 04:12:59 -0400
Received: from outgoing12.flk.host-h.net (outgoing12.flk.host-h.net [188.40.208.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B582B270
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 01:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=risingedge.co.za; s=xneelo; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:reply-to:sender:bcc:in-reply-to:references
        :content-type; bh=DhCSylOqMK9RK62jSG42tkSHvX1U9k17Jxtsz0NJ8Ss=; b=d3u8VlRndOa
        1WgipKpvT8JSIX8ap3vy7zenK3vA+MwX2N8vKQG0eUYI9TgqAjW4KYqFRE7g8CSigg9eg1Qvb4UuM
        XRLvoalWnOLqOXoEjE+e23KyfiRuBVdCqzcPgmIxqYNbCwcldNI+bVhmBrtaH4Nrf+BJUW8G6yVwz
        sMhZKwFD6lxkLyCFFEfug27PaFW0hzqcNmG3W0IPjATyb+84SpDSUcs39Tf/ZT7OANpDjs9ttHRIV
        fQT57d8CiHCEGUU+VxPniPa/5I/QRHNKGuLHCq2KpLkLtKsECMTXAvUrPyr6cD9NjPsDMN66ha63d
        114Pwc/uHtyKHLFV5Tpy8rg==;
Received: from www31.flk1.host-h.net ([188.40.1.173])
        by antispam3-flk1.host-h.net with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1oIQXc-0007e9-2T; Mon, 01 Aug 2022 10:12:51 +0200
Received: from 8ta-249-0-202.telkomadsl.co.za ([102.249.0.202] helo=localhost.localdomain)
        by www31.flk1.host-h.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1oIQWT-0008Qi-VX; Mon, 01 Aug 2022 10:11:34 +0200
From:   Justin Swartz <justin.swartz@risingedge.co.za>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Kolchmeyer <rkolchmeyer@google.com>,
        Florian Westphal <fw@strlen.de>,
        Justin Swartz <justin.swartz@risingedge.co.za>
Subject: [PATCH] ebtables: add "allstatic" build target
Date:   Mon,  1 Aug 2022 10:10:32 +0200
Message-Id: <20220801081032.13366-1-justin.swartz@risingedge.co.za>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: justin.swartz@risingedge.co.za
X-Virus-Scanned: Clear
X-Originating-IP: 188.40.1.173
X-SpamExperts-Domain: risingedge.co.za
X-SpamExperts-Username: 
Authentication-Results: host-h.net; auth=pass (login) smtp.auth=@risingedge.co.za
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.00771144909719)
X-Recommended-Action: accept
X-Filter-ID: Pt3MvcO5N4iKaDQ5O6lkdGlMVN6RH8bjRMzItlySaT8lRd3oTOTGlAWwRIN0W98VPUtbdvnXkggZ
 3YnVId/Y5jcf0yeVQAvfjHznO7+bT5wv+E/fDc7/R1GVAcdgTNkU3+rkdHDmDkl/alK+GLnpksVV
 WRRXsM9Zt/2RWzM3RWYM3XeRrJb2hC17YoWceuut8F85JWDVq6BR5Ixa1z85PE1/gzQfM88V/+BY
 6rSZm+R3nndK8gxXHOR8xmpBSielAc0uXzxyDVCcVc2YNWS6fWb2tXPmns7zjSZElZ3mHNBnidc8
 aj4UEJ9BbvNM19Eseaby5Ye7KJZ4TnuMw0v7mkcURWqRjbaTpjZ76SnwtaKCA58glIAOJzlMb7vU
 dtXkIupF9oVoJxOgiAc/hMxCqRTC6zwh9gnyR6ZGKSRKnJ7aUnOFsLmxiteAg/Lg3QQf9KF0/TSf
 HOH+bfnK0v9ZiKHuIBQAIL3H1ZJjKsJ4pLltSMkk9WyhqTYvpQ3xeVkJAuG5f5F796+TigZXI7V3
 aGRmcDSGeScA/yd1y7ZE0d6h3DIh8+TiMeSiXYNg5CxOxBYp7Y2GZHv0xh6b+oGJmF+7HpiXZfFn
 rsvPrZTEk0OD3gWUs/hlb/LcbWXLm4j4bEI0+1qiZCID5pC0mn1iDZXGZD0auzYaMcjMKovENt2Z
 GHIMse5MIvqHTiGLpZNE/s8o8aPw1d4YK6Uv9AkSo3oSKlHMxVnkurBPHtW+f1Lk4FnztaYXJcGb
 +ggC0uY6OQ/UtmVgvi7puaKdTUCKjVqTeKuR3eGZMxAk3xxtpu3na+v1v1FeW2bZzTWI5LrTB5hQ
 6nsDvccjqgmDvD9Wh1oGFEGE+pSoTK1YsOONTD9fJA3h62VnA3NT5IypeAnHaGwuEtG+OI4l45m8
 ocw/TMoobmxVmqF3TjPZT8f3j/71l6AsHQsaknfXPk6nquQmgeO+LRk3vZWpXU1livMwYlz1pRXW
 hjh9fdbl44I0Df1h2JtGUs6HARbNwQfH/DiPEwtPTXAgD42KSFzY1Rwd+RpLRuLAdXmBOzuQPJ1I
 A4ZDOjqPH696SEBPk7q9MTcQCV0v6rQfiGmzg5fUcz3U8kGWpI9w5vt/LUkuaPnl/34bDW6jQ0+C
 n/DXxtVx8KQIkAKT5X9XrQfol8meyDvbAcawvZuxmYkRonGQLKYp5Fs=
X-Report-Abuse-To: spam@antispammaster.host-h.net
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "allstatic" target produces a statically linked (or standalone)
binary, in contrast to "static" which produces a dynamically linked
binary with libebtc baked in.

Signed-off-by: Justin Swartz <justin.swartz@risingedge.co.za>
---
 Makefile.am | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index b246064..05556d2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -25,7 +25,7 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include \
 AM_CFLAGS = ${regular_CFLAGS}
 
 sbin_PROGRAMS = ebtables-legacy ebtablesd ebtablesu ebtables-legacy-restore
-EXTRA_PROGRAMS = static examples/ulog/test_ulog
+EXTRA_PROGRAMS = allstatic static examples/ulog/test_ulog
 sysconf_DATA = ethertypes
 sbin_SCRIPTS = ebtables-legacy-save
 man8_MANS = ebtables-legacy.8
@@ -52,6 +52,8 @@ ebtables_legacy_restore_SOURCES = ebtables-restore.c
 ebtables_legacy_restore_LDADD = libebtc.la
 static_SOURCES = ebtables-standalone.c $(libebtc_la_SOURCES)
 static_LDFLAGS = -static
+allstatic_SOURCES = $(static_SOURCES)
+allstatic_LDFLAGS = -all-static
 examples_ulog_test_ulog_SOURCES = examples/ulog/test_ulog.c getethertype.c
 
 daemon: ebtablesd ebtablesu
-- 

