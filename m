Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E8BC4363A
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9389724182
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TLca35oM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369206AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368010AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D6C0613D2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a6iDeEpz4uHi0cBGe88N79CiX2NM6O94Y9A/6095EH0=; b=TLca35oMxyN5F62JlcSB6nEbq7
        7SsqoZ7Sd3EEE9IgD0bSH69PuOBSj35ereLkojN3/cOtAMAMIs9ohnmDVaGyggbDgd7LPvYwDUFik
        0AjJ8IMQSP2toq+JVP6xkUj9Y4yxByiDStbI8CuKmnjqJXDkCVmae4hq82etBgslClwQ4KCHxb7L/
        tokJGo8BibTEVUzfeN/jJCYAjWYyAkYQ1+OBTZXfXu7uSWGj2qA0DkyxCc3U2yECkHnZVxE7FW8pO
        EN3WbMzAPuMWvB/E5WKTpdUPWNvMFO/NUNPzgANJmLBH6Nece/9TJiHfYf0VW6GIszejsBlEpi2R9
        NAzWDTNg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kVePl-0003s0-9c; Thu, 22 Oct 2020 18:30:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/3] pknock: pknlusr: fix formatting.
Date:   Thu, 22 Oct 2020 18:30:03 +0100
Message-Id: <20201022173006.635720-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022173006.635720-1-jeremy@azazel.net>
References: <20201022173006.635720-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 6153bf6de099..161a9610a018 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -76,7 +76,7 @@ int main(void)
 			return 1;
 		}
 
-	nlmsg = (struct xt_pknock_nl_msg *) (buf + sizeof(struct cn_msg) + sizeof(struct nlmsghdr));
+		nlmsg = (struct xt_pknock_nl_msg *) (buf + sizeof(struct cn_msg) + sizeof(struct nlmsghdr));
 
 		ip = inet_ntop(AF_INET, &nlmsg->peer_ip, ipbuf, sizeof(ipbuf));
 		printf("rule_name: %s - ip %s\n", nlmsg->rule_name, ip);
-- 
2.28.0

