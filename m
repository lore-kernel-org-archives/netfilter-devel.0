Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12848C43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 21:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2596D20656
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 21:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfDYVwY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 17:52:24 -0400
Received: from kich.slackware.pl ([193.218.152.244]:36244 "EHLO
        kich.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDYVwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 17:52:24 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2019 17:52:23 EDT
Received: from dirac.lan.toxcorp.com (dirac.vpn [172.22.22.8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by kich.slackware.pl (Postfix) with ESMTPSA id 4B17215CC;
        Thu, 25 Apr 2019 23:47:07 +0200 (CEST)
From:   Jakub Jankowski <shasta@toxcorp.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jakub Jankowski <shasta@toxcorp.com>
Subject: [PATCH net] netfilter: nf_ct_h323: restore boundary check correctness
Date:   Thu, 25 Apr 2019 23:46:50 +0200
Message-Id: <20190425214650.518-1-shasta@toxcorp.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit bc7d811ace4a ("netfilter: nf_ct_h323: Convert
CHECK_BOUND macro to function"), NAT traversal for H.323
doesn't work, failing to parse H323-UserInformation.
nf_h323_error_boundary() compares contents of the bitstring,
not the addresses, preventing valid H.323 packets from being
conntrack'd.

This looks like an oversight from when CHECK_BOUND macro was
converted to a function.

To fix it, stop dereferencing bs->cur and bs->end.

Fixes: bc7d811ace4a ("netfilter: nf_ct_h323: Convert CHECK_BOUND macro to function")
Signed-off-by: Jakub Jankowski <shasta@toxcorp.com>

---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 1601275efe2d..4c2ef42e189c 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -172,7 +172,7 @@ static int nf_h323_error_boundary(struct bitstr *bs, size_t bytes, size_t bits)
 	if (bits % BITS_PER_BYTE > 0)
 		bytes++;
 
-	if (*bs->cur + bytes > *bs->end)
+	if (bs->cur + bytes > bs->end)
 		return 1;
 
 	return 0;
-- 
2.21.0

