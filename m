Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6442C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343961AbhKXW2H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343984AbhKXW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8926CC061748
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZItIju5mzti6My9dIyh+yumlniUXn39Z/ny1wmTWSZk=; b=W4oGaNGg9eDkeV38ZOlpCbgu79
        I2qnEgwAs9Q3iM2mTYWn8bQpfDiuj4KPLNkoqW3wolM9d7ahSuHeGubL15nDA0X8NqrBmHVH10ju1
        9sdLktYYK8UrhQ7HUtkN6+yU9O6klxKjVezvO+K4B+OnJXtv8kWkOfrkIgJzMO3/Owfu0gfkpdVie
        /UF4XirZuykVHEeJQFzFmhi1ElFBx6MOMLp8d4CtmKbQN+ZYki8XvGRCXVQYZaYeZYkdF4ABgaYD2
        M2OU72ZJYmIYlCjbEwSuVN1Xe4DTZJMbWwzg/Lb7IhLhc3Ko3Fv4inUeWi3FAuYCmqE7FczOHFrXB
        BebyErGA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-Mw
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 05/32] filter: HWHDR: remove zero-initialization of MAC type
Date:   Wed, 24 Nov 2021 22:24:00 +0000
Message-Id: <20211124222444.2597311-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We don't need to initialize `type`, and even if we did the right value
would be `ARPHDR_VOID`, not `0`, which is a valid MAC type
(`ARPHDR_NETROM`).

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 015121511b08..bbca5e9b92f2 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -171,7 +171,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
-	uint16_t type = 0;
+	uint16_t type;
 
 	if (pp_is_valid(inp, KEY_OOB_PROTOCOL))
 		okey_set_u16(&ret[KEY_MAC_PROTOCOL],
-- 
2.33.0

