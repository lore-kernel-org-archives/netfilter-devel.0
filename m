Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C100BC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906CE214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QPZghzXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgCCKO1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 05:14:27 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41926 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgCCKO1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CfIj8SjzYfP4YiB2+5RctARo6IJjv/WXWUaoUxy/BUc=; b=QPZghzXIxeCGKNLS1rSHZ6csUy
        CnbmqJS22QUGmNnNwpXFhLE6TS3lBfV85Ez9b1RV5Prg5tBQ1LkC/FIKHgigo2k0QZFvzmhfL4y+m
        aIN2Zlww5mOqYyyx+5ywH0xyBgjDStOefKeNxJK9X3n8aZ6FIysfkyBgm4M9Zbv4ToKrIv0V85hHr
        qw9betW2QNBgw94TR7Yr9sa8fBGc5pt0OMAn1FgLpoG+meAmCxTD3/TQNfQEMqPM2WAdf0jNDxqEq
        8DGedSbYi62GczpV+cCmih2Kio4wTc2TfLEDU0VTDofD5mur0oSIlw76AUJAUfFUq7VqaOl+83EKW
        oWqlNG8g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AR-00081M-Ca; Tue, 03 Mar 2020 09:48:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 16/18] tests: shell: remove stray debug flag.
Date:   Tue,  3 Mar 2020 09:48:42 +0000
Message-Id: <20200303094844.26694-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

0040mark_shift_0 was passing --debug=eval to nft.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_shift_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_shift_0
index 55447f0b9737..ef3dccfa049a 100755
--- a/tests/shell/testcases/chains/0040mark_shift_0
+++ b/tests/shell/testcases/chains/0040mark_shift_0
@@ -8,4 +8,4 @@ RULESET="
   add rule t c oif lo ct mark set (meta mark | 0x10) << 8
 "
 
-$NFT --debug=eval -f - <<< "$RULESET"
+$NFT -f - <<< "$RULESET"
-- 
2.25.1

