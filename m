Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FB4C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Feb 2021 14:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947F064EAF
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Feb 2021 14:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhB1Ozt convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Feb 2021 09:55:49 -0500
Received: from p3plsmtp05-06-02.prod.phx3.secureserver.net ([97.74.135.51]:55755
        "EHLO p3plwbeout05-06.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhB1Ozt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Feb 2021 09:55:49 -0500
Received: from p3plgemwbe05-06.prod.phx3.secureserver.net ([97.74.135.6])
        by :WBEOUT: with SMTP
        id GNTFl7QaLOIbeGNTFltnHH; Sun, 28 Feb 2021 07:54:57 -0700
X-CMAE-Analysis: v=2.4 cv=W7f96Tak c=1 sm=1 tr=0 ts=603baec1
 a=4PocnuTK4F0hwI5R9ZIbCA==:117 a=Tb-8IF_VHAgA:10 a=gOoLzYk5U4MA:10
 a=IkcTkHD0fZMA:10 a=qa6Q16uM49sA:10 a=inyria9KPeIrDzR3zkwA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: andy@asjohnson.com
X-SID:  GNTFl7QaLOIbe
Received: (qmail 12034 invoked by uid 99); 28 Feb 2021 14:54:57 -0000
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: 66.72.221.161
User-Agent: Workspace Webmail 6.12.1
Message-Id: <20210228075456.fcdaf64278890662106b299d41e0899d.6d7dc7cab7.wbe@email05.godaddy.com>
From:   <andy@asjohnson.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH] xtables-addons 3.15 doesn't compile on 32-bit x86
Date:   Sun, 28 Feb 2021 07:54:56 -0700
Mime-Version: 1.0
X-CMAE-Envelope: MS4xfBB7eQ754cntJwGSGzDmUXl7JXugPMlSii7wC/3Ohh7o7ZHTOWFlN16FE8fZ4s0GCUKxm5sekpaqo6nSxlNp/Rb6HSTmGhgUo5XGJqKTD2B9X2VgChsx
 3YTjjtGLcafcCsmtPbQg0OChU0IpQKT7F+zfARe2EuHkHfgPeMiAlh5/QIYtoqxdlXzha2gSqtE7x3UlQpSwp8dEaM2xWoFzZchEeEu1V4NxkQz2TmANNWX/
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The original patch for long division on x86 didn't take into account
the use of short circuit logic for checking if peer is NULL before
testing it. Here is a revised patch to v3.16:

--- xtables-addons-3.16-orig/extensions/pknock/xt_pknock.c
+++ xtables-addons-3.16-patched/extensions/pknock/xt_pknock.c
@@ -311,9 +311,13 @@
 static inline bool
 autoclose_time_passed(const struct peer *peer, unsigned int
autoclose_time)
 {
-	unsigned long x = ktime_get_seconds();
-	unsigned long y = peer->login_sec + autoclose_time * 60;
-	return peer != NULL && autoclose_time != 0 && time_after(x, y);
+	if (peer != NULL) {
+		unsigned long x = ktime_get_seconds();
+		unsigned long y = peer->login_sec + autoclose_time * 60;
+		return autoclose_time != 0 && time_after(x, y);
+	} else {
+		return 0;
+	}
 }
 
 /**
@@ -335,8 +339,12 @@
 static inline bool
 has_logged_during_this_minute(const struct peer *peer)
 {
-	unsigned long x = ktime_get_seconds(), y = peer->login_sec;
-	return peer != NULL && do_div(y, 60) == do_div(x, 60);
+	if (peer != NULL) {
+		unsigned long x = ktime_get_seconds(), y = peer->login_sec;
+		return do_div(y, 60) == do_div(x, 60);
+	} else {
+		return 0;
+	}
 }
 
 /**

