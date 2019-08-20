Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A51C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7391522DD3
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsTakIhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfHTU02 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:26:28 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38531 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730824AbfHTU01 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 16:26:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so243811qts.5
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 13:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=66IbthnW/HLzHTXDCr8Cmnqi57PwwzSnp3WiimYCh6w=;
        b=lsTakIhFwFnGuq4Stk4qPJE2UTTIkl6DFJnrXBaixNZUAg67A6AnpB6I5brU3G63Cs
         v/XLOLBrbjIwXHwPH2aS+MRrv+X33zDn9BXjBdiwxXwpWCvb60GjB8/bKY7zLFWvIdwn
         gW9us1nhDN5tbrkPFakTL0v4Tqlq46MT/zVIrX8Q7R0ascvd/yAcvg1ak02oM4eAY8rt
         tXoK5HQOPBkCD+04AAk3+GygTii8Q25oTSiopsVYnTa90MXNSODhk7Go4cCZj30pn7Bo
         56PZk6QgDXnD9u8CKQQng5bBDabgHVCoGAoj9gyK+2EtR3T6kA88HXf5per5Rhxa1U4v
         wpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=66IbthnW/HLzHTXDCr8Cmnqi57PwwzSnp3WiimYCh6w=;
        b=NyfU+ziUhHe9pAltbgu70fspX0JLIrmUCvK/e9ZOqObUeUb6SCEIt0g1s02Du9++6y
         /CHS38acIrWN2mSHFYCpwIoEjYi4cZmhQ0sLwnR7+lpxIFWj1wlP9SNvDSgmmlg0gs6X
         dG4SIMlFBp+nzBjcREd/K/Wc9y5PKN31xpyu8/b02lxW6Yr3dnwKy6+kjuk9cZ5lii9T
         Z176x3tQhWRDN6YsWcGEYrGY1lT9q3MtNecc6+49H47YKMAg53QXECM28wy6uxTapNeH
         WEW3Z42sj8YzVb9x63oqw1aLCFVC7/5aX+NteSDO2Vds6/G6n1nS9q8s3YYd1UnLSrwe
         TDTA==
X-Gm-Message-State: APjAAAWBUkcTRALkjQ3VNJBq5matpuv9mNyYvQV6DLDdMSiIy7VNaOMF
        KRRUSG8c6jqC+VhyYNykd7qp4u1GePcS1/DjDsCAGQ==
X-Google-Smtp-Source: APXvYqyTGo/TaMfiPMC4eDaTqploQYlhdsKP8wJWnw+y5c9uZAeSWe4ltoebtMeg2vxGBfgOEJhit7HSj1K1WiVynnM=
X-Received: by 2002:aed:24f4:: with SMTP id u49mr28441167qtc.110.1566332785615;
 Tue, 20 Aug 2019 13:26:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:3226:0:0:0:0:0 with HTTP; Tue, 20 Aug 2019 13:26:25
 -0700 (PDT)
From:   "Joseph C. Sible" <josephcsible@gmail.com>
Date:   Tue, 20 Aug 2019 16:26:25 -0400
Message-ID: <CABpewhHgvi8TFqiBD6o_mksG0xLa5khYL2BbxaLhW6uhfOtHMA@mail.gmail.com>
Subject: [PATCH iptables] doc: Note REDIRECT case of no IP address
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If an IP packet comes in on an interface that lacks a corresponding IP
address (which happens on, e.g., the veth's that Project Calico creates),
attempting to use REDIRECT on it will cause it to be dropped. Take note
of this in REDIRECT's documentation.

Signed-off-by: Joseph C. Sible <josephcsible@gmail.com>
---
 extensions/libxt_REDIRECT.man | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_REDIRECT.man b/extensions/libxt_REDIRECT.man
index 3400a6d..28d4d10 100644
--- a/extensions/libxt_REDIRECT.man
+++ b/extensions/libxt_REDIRECT.man
@@ -8,7 +8,8 @@ chains, and user-defined chains which are only called from those
 chains.  It redirects the packet to the machine itself by changing the
 destination IP to the primary address of the incoming interface
 (locally-generated packets are mapped to the localhost address,
-127.0.0.1 for IPv4 and ::1 for IPv6).
+127.0.0.1 for IPv4 and ::1 for IPv6, and packets arriving on
+interfaces that don't have an IP address configured are dropped).
 .TP
 \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a destination port or range of ports to use: without
--
2.7.4
