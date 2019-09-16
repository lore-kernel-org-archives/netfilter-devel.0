Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4337C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E6A20665
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JPn+dzj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfIPMmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:42:09 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44740 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbfIPMmI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 08:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=19IMJlb1CPUT8A9KNa6qlTK8ne4IbOWpM9XVrHpqHDc=; b=JPn+dzj5QTp0ZPZH4ISpF+mWyk
        zjqqlj3eWEnI8ANuca5djs8zd1QhYPuzpyTpEW9dbZA6lBUfpUVQm8hKiDumdUgs4eutyiuCcQbtP
        y+BYiuFI5X2SvN4X3cZMh2Dn9JIKf9poyKi7raAV99pifzVC6A3HBUuu/tXnPQlEDXVgJjlWFMoSf
        E2zdeqT/fUJ88lwxq0SbINjRlzeS/SZloKrUirHr7FgAimiaTcuic/nmNOU6k09o99fAayC1RJntl
        wiQytvF5hnxtYZpbj4N3XQ0bvu91rrPnLmkW7UJmhpIQvObxSuPNgFHRKft8fI8px1wXHJRgVAk/t
        7fRuhzmg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i9qKS-0005OR-Gx; Mon, 16 Sep 2019 13:42:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH RFC nftables 2/4] cli: remove unused declaration.
Date:   Mon, 16 Sep 2019 13:42:01 +0100
Message-Id: <20190916124203.31380-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916124203.31380-1-jeremy@azazel.net>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cli.h includes a forward declaration of struct parser_state which is not
needed.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/cli.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/cli.h b/include/cli.h
index c1819d464327..023f004b8dab 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -4,7 +4,6 @@
 #include <nftables/libnftables.h>
 #include <config.h>
 
-struct parser_state;
 #ifdef HAVE_LIBREADLINE
 extern int cli_init(struct nft_ctx *nft);
 #else
-- 
2.23.0

