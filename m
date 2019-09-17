Return-Path: <SRS0=KcvN=XM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AA5C4CECD
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Sep 2019 18:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA762054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Sep 2019 18:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfIQSot (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 14:44:49 -0400
Received: from smtp-out-2.tiscali.co.uk ([62.24.135.130]:51935 "EHLO
        smtp-out-2.tiscali.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfIQSot (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 14:44:49 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 14:44:49 EDT
Received: from nabal.armitage.org.uk ([92.27.6.192])
        by smtp.talktalk.net with SMTP
        id AILAiDjj5UgmGAILAiwQsB; Tue, 17 Sep 2019 19:36:40 +0100
X-Originating-IP: [92.27.6.192]
Received: from localhost (localhost.localdomain [127.0.0.1])
        by nabal.armitage.org.uk (Postfix) with ESMTP id 05D9EE0509;
        Tue, 17 Sep 2019 19:36:38 +0100 (BST)
X-Virus-Scanned: amavisd-new at armitage.org.uk
Received: from nabal.armitage.org.uk ([127.0.0.1])
        by localhost (nabal.armitage.org.uk [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id MweI300X0lcv; Tue, 17 Sep 2019 19:36:34 +0100 (BST)
Received: from samson.armitage.org.uk (samson.armitage.org.uk [IPv6:2001:470:69dd:35::210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by nabal.armitage.org.uk (Postfix) with ESMTPSA id 6A4E7E02D2;
        Tue, 17 Sep 2019 19:36:34 +0100 (BST)
Message-ID: <1568745392.3595.107.camel@armitage.org.uk>
Subject: [PATCH] extensions: fix iptables-{nft,translate} with conntrack
 EXPECTED
From:   Quentin Armitage <quentin@armitage.org.uk>
Reply-To: quentin@armitage.org.uk
To:     netfilter-devel@vger.kernel.org
Cc:     Quentin Armitage <quentin@armitage.org.uk>
Date:   Tue, 17 Sep 2019 19:36:32 +0100
Organization: The Armitage family
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDuoU3I1WN8uNX6JQ0nze6Bu6R2Nnxxk18PcicHfbqbgpFuMYZ4tSm5UIirA4KTnnrEVVzTyQn5b7c9f/bQJVmFs5zIe2qLX/t5QZ/2yZUrdWPAjILcz
 VwI7Rv8AKs2eiKIwif8XEvfc6uOHxOUale6fBTpeD8b9j/RR5rVFv7XBVQ40rKd7RV3YFwKPvxVQ+14CJFdNlazjugssw3XjcqY=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables-translate -A INPUT -m conntrack --ctstatus EXPECTED,ASSURED
  outputs:
nft add rule ip filter INPUT ct status expected,assured counter
  and
iptables-nft -A INPUT -m conntrack --ctstatus EXPECTED,ASSURED
  produces nft list output:
chain INPUT {
	ct status expected,assured counter packets 0 bytes 0 accept
}
which are correct.

However,
iptables-translate -A INPUT -m conntrack --ctstatus EXPECTED
  outputs:
nft # -A INPUT -m conntrack --ctstatus EXPECTED
  and
iptables-nft -A INPUT -m conntrack --ctstatus EXPECTED
  produces nft list output:
chain INPUT {
          counter packets 0 bytes 0 accept
}
neither of which is what is desired.

Commit 6223ead0d - "extensions: libxt_conntrack: Add translation to nft"
included the following code in _conntrack3_mt_xlate():
	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
		if (sinfo->status_mask == 1)
			return 0;
		...

If the intention had been not to produce output when status_mask == 1,
it would have been written as:
                if (sinfo->status_mask == IPS_EXPECTED)
                        return 0;
so it looks as though this is debugging code accidently left in the
original patch.

Removing the lines:
                if (sinfo->status_mask == 1)
                        return 0;
resolves the problems, and
iptables-translate -A INPUT -m conntrack --ctstatus EXPECTED
  outputs:
nft add rule ip filter INPUT ct status expected counter
  and
iptables-nft -A INPUT -m conntrack --ctstatus EXPECTED
  produces nft list output:
chain INPUT {
        ct status expected counter packets 0 bytes 0 accept
}

This commit also includes an additional txlate test to check when
only the status EXPECTED is specified.

Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
---
 extensions/libxt_conntrack.c      | 2 --
 extensions/libxt_conntrack.txlate | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 1817d335..6f350393 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1257,8 +1257,6 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
-		if (sinfo->status_mask == 1)
-			return 0;
 		xt_xlate_add(xl, "%sct status %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_STATUS ?
 			     "!= " : "");
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index e35d5ce8..8a3d0181 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -28,6 +28,9 @@ nft add rule ip filter INPUT ct reply daddr 10.100.2.131 counter accept
 iptables-translate -t filter -A INPUT -m conntrack --ctproto tcp --ctorigsrcport 443:444 -j ACCEPT
 nft add rule ip filter INPUT ct original protocol 6 ct original proto-src 443-444 counter accept
 
+iptables-translate -t filter -A INPUT -m conntrack --ctstatus EXPECTED -j ACCEPT
+nft add rule ip filter INPUT ct status expected counter accept
+
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
 nft add rule ip filter INPUT ct status != confirmed counter accept
 
-- 
2.23.0

