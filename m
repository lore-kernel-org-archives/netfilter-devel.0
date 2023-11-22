Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5251DC61D9C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbjKVMyr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343654AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896ACD4F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MPEc8KXIrF9zNYMknvPu0unozbnYRp3XEzkHWA/zzAE=; b=hSElk2y9B7qbqASPZBbA3PUfRJ
        gl7QZ3QB4AsaxvT41Y/NmMSxrQJckR/aRRtZVA3Bf6Hhsf/Oe28qu1zzh2qJ+AwwJ2a95I7D4xTS7
        +7ejRhiIlYRjSx1y1vSwukUW2pditiy0lf0y6a2CkCslxWDOsy0umv4Z8PFRCu9VPgkxPMmU0corI
        8g6szDPJJg0gYxXDmYe6uRiYM7APvEpAZ0034WJYI0qNwxsam1dpgqJRO1g+ek5v/3dUcZMB73yiX
        F92Z/z19n3i0m62ffyLOkUhOZoOmuy3mC4fmaC06W0pWvMMnO0HRWkORod/cug3/EQpmypxej0tnE
        teB6erBQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkT-0005Rx-Eu
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/12] xshared: Drop pointless CMD_REPLACE check
Date:   Wed, 22 Nov 2023 14:02:16 +0100
Message-ID: <20231122130222.29453-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All current users set default source and destination addresses in their
post_parse callbacks, so legacy variants are safe and nft variants don't
have this restriction anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 53e72b7abb1e8..c4d7a266fed5e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1836,11 +1836,6 @@ void do_parse(int argc, char *argv[],
 	if (p->ops->post_parse)
 		p->ops->post_parse(p->command, cs, args);
 
-	if (p->command == CMD_REPLACE &&
-	    (args->s.naddrs != 1 || args->d.naddrs != 1))
-		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-			   "specify a unique address");
-
 	generic_opt_check(p->command, cs->options);
 
 	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
-- 
2.41.0

