Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A11C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jun 2022 08:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiFYIoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Jun 2022 04:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiFYIoH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Jun 2022 04:44:07 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 01:44:01 PDT
Received: from outgoing12.flk.host-h.net (outgoing12.flk.host-h.net [188.40.208.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE70344CE
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jun 2022 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=risingedge.co.za; s=xneelo; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:reply-to:sender:bcc:in-reply-to:references
        :content-type; bh=ekmduD5XCN3+EMRU/l7+JH2hEKV+6MraoviUyBEow1c=; b=sC5d893bikw
        PrpplD1iP6U2U/Wv4W+Pdw665tzfC9UGoRMM9/qxzljU9h6GUCdcTlG2FR47QIpJFr0jh6sIv4mDs
        5acd4wYRqRmxO/CBcZ4bfB92vcgXWaxNLMWfl71LgoGr7sBw6Qtz5aFFf/zmRrc68+h8jSUiD9zW9
        OFvYitaTP+iUVg9O6o+Q2RgAJ37MsLbfqPI0gx3SQVk3vdaYbMz82apX2TDc7Ju+6dlKF4Vj3WdkU
        NTFAYj9Mr+HM8HlMLKwuQjYhUhlopGmvnzKh74LF/ftTAuE/bj0Eor49x05OY3Up0gLeDdSzLUfSM
        EQSkRhTyiCq3hSrR8AlfGHQ==;
Received: from www31.flk1.host-h.net ([188.40.1.173])
        by antispam3-flk1.host-h.net with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1o50wj-0005zF-Jd; Sat, 25 Jun 2022 10:15:15 +0200
Received: from 8ta-249-3-215.telkomadsl.co.za ([102.249.3.215] helo=localhost.localdomain)
        by www31.flk1.host-h.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1o50wh-00027M-TL; Sat, 25 Jun 2022 10:15:12 +0200
From:   Justin Swartz <justin.swartz@risingedge.co.za>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Kolchmeyer <rkolchmeyer@google.com>,
        Justin Swartz <justin.swartz@risingedge.co.za>
Subject: [PATCH] ebtables: extend the 'static' build target fix.
Date:   Sat, 25 Jun 2022 10:14:41 +0200
Message-Id: <20220625081441.13323-1-justin.swartz@risingedge.co.za>
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
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.0041015031603)
X-Recommended-Action: accept
X-Filter-ID: Pt3MvcO5N4iKaDQ5O6lkdGlMVN6RH8bjRMzItlySaT/MnpNzwC0Ocb1EkB4gNASoPUtbdvnXkggZ
 3YnVId/Y5jcf0yeVQAvfjHznO7+bT5zN3IqzRBDvTWZfn5sEnTpZuklamWP4cukJW+3pAn2KGu1d
 lFc2J+gRtFmyqzFFeX+3wL2Y4F0412ezGCyTUPanSFrMwbY4cRFPXLNpRfrn5Y0LEUD0Op6gC8NE
 DuTqCz76thm+7tQQmJTezbtWAoc7xuAOHwMqYKYMr/m+HJL/xXoEa1iyKMqiSwfwghR1o23RMycf
 SndZkVh5TefPRv0JixQxZZ+BetMBaOp+SYcmHEtNZwGZqSkZ0Sgdwq+rOeEi6kX2hWgnE6CIBz+E
 zEKp5U90us44ThtrkdfIq2AcVy1+Itm3Zi67f33Q0vSIt5Es9EoJF76glRJeGkLNzPOkhY6U4Nwm
 pcGPuCEf4Z43ofcLVphtCwl8mpTwF6N+yd39FigqGrU+34PbFwtmhz7kZGZwNIZ5JwD/J3XLtkTR
 3gPkCgeOrSVu604RiS52Hg4WqQcrkdncBVBujWllVdXQX7semJdl8Weuy8+tlMSTQ04uitUf42Cc
 Hl6wE8LbH+hYFX5W98JZfM4UDzp+I2t3lcZkPRq7NhoxyMwqi8Q23bNHg5ts37gbRPta2ZlNINyd
 6+6AB9mEpRX5vy67WwDjehIqUczFWeS6sE8e1b5/UkBg4yvMn5MBAdwJubari/hPuKmOY0kqJ4NN
 rcAziJOD+TkpKT6O5G+4aPgJrp5nml6/OzEKm9KAOvYMfigiXaYHmFDqewO9xyOqCYO8P1aHMhZZ
 DkZ40oG2FzTfopvz9xuIxkBDGEbduOdw0uJtHguTRS8JVsgjWBjHFLRRCbQxQQQX7NPNcMSQ97p8
 3PUvYjrZGfrvFvNuaXph7mH0nSlgI/9ncnak3Ay6ECNGst2pXPWlFdaGOH191uXjgjQN/c+0S1IB
 LIRSrCXgT7NEODZIQqRxd3tjCm2/vSodPNFZuh0a2rp7CqRZHeAHz/dis0M6Oo8fr3pIQE+Tur0x
 NxA8r547VZA0UFr/akx1EQvtuD+68QGZjMkglcEG10DVahsNbqNDT4Kf8NfG1XHwpAh+vwaYt0T2
 8J35bZnWIbDOqza8/wd0p4lmMi3WIfAF1w==
X-Report-Abuse-To: spam@antispammaster.host-h.net
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assign "-all-static" (instead of "-static") to "static_LDFLAGS" in
Makefile.am, as libtool will only produce a static binary if it is
explicitly told that all of the linked libraries should be static.

BEFORE

$ file static
static: ELF 32-bit LSB pie executable, Intel 80386, version 1 (SYSV),
        dynamically linked, interpreter /lib/ld-musl-i386.so.1,
        not stripped

AFTER

$ file static
static: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),
        statically linked, not stripped

REFERENCE

"Another common situation where static linking is desirable is in
 creating a standalone binary. Use libtool to do the linking and
 add the -all-static flag."  --  Libtool Manual, Section 3.7

Signed-off-by: Justin Swartz <justin.swartz@risingedge.co.za>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index b246064..d011919 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -51,7 +51,7 @@ ebtablesd_LDADD = libebtc.la
 ebtables_legacy_restore_SOURCES = ebtables-restore.c
 ebtables_legacy_restore_LDADD = libebtc.la
 static_SOURCES = ebtables-standalone.c $(libebtc_la_SOURCES)
-static_LDFLAGS = -static
+static_LDFLAGS = -all-static
 examples_ulog_test_ulog_SOURCES = examples/ulog/test_ulog.c getethertype.c
 
 daemon: ebtablesd ebtablesu
-- 

