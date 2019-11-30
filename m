Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471CC43215
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88292082E
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KhTwWekZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfK3R6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:58:49 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54248 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfK3R6s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7f0ELXwjzHTS/0m5kCDxt1lzGsPXizWkpXYvIa9PfS8=; b=KhTwWekZeyE8I72TigSqP0rzTd
        xUbFNlbsVc1IIfz7HRMs4eVb5YodA0LlLcFRig3b7pA3l7qPxOFKTwVC/5b29EwRJT/3uD1P2hfJd
        ciKw5olbad4Q0dR0XHVPEFzXOf7Idu8KXfbxwurwyL9VmWn5N3tyVPdcU4ikJfwbPVOpw25IrjChs
        BFtlR/OD3uHuZIW/88ASd1YQEkRlt3si2rDYtBHEW9FTs6EitK/8mdaI3BCDozdVSO/KIAAeOF4Qj
        NZwicw6VDyu89Q2MoFqUshxgxKaYM3noMvgL7QFYP/H+sgK+6Q6soPtrxvZuJhjx53i+gJxqAm/tu
        rh6R7zrA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib714-0002eP-57; Sat, 30 Nov 2019 17:58:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: [PATCH xtables-addons v2 1/3] configure: update max. supported kernel version.
Date:   Sat, 30 Nov 2019 17:58:43 +0000
Message-Id: <20191130175845.369240-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191130175845.369240-1-jeremy@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130175845.369240-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The maximum supported version is reported as 5.3.  Bump to 5.4.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index eccb09bf44b4..103cf07d6f9a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,7 +57,7 @@ if test -n "$kbuilddir"; then
 		echo "WARNING: Version detection did not succeed. Continue at own luck.";
 	else
 		echo "$kmajor.$kminor.$kmicro.$kstable in $kbuilddir";
-		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 3; then
+		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 4; then
 			echo "WARNING: That kernel version is not officially supported yet. Continue at own luck.";
 		elif test "$kmajor" -eq 5 -a "$kminor" -ge 0; then
 			:
-- 
2.24.0

