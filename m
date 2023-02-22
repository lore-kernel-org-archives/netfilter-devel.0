Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA94C636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjBVRC6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjBVRCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 12:02:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3974217
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 09:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u0Fq0CuabpnS1Ml60dMeqbKfr0SdoEPKyFS9xdsYkSA=; b=CoKt//dXGC62XQpMYhMxpXEE5I
        o8dHajv8rsVtlrvmjPYsXdduzrsOV+XP80y/QwkG7t51ql/XhazGDextDnn2PIihUgv/VFF9B1UCb
        F5oqGOVtiWwpJjAP5pZh1dQ5ywVPdiz5k2pbJQSgu4RatEYZShZvBAkDmInAdHcNWZUB16JdONKPX
        XfgZUlDte0tON7OVMHFltCBYPKfaTmofOXj5J2b0SpH28LmsAxjQhoVedSA0uQAIaOOP31z6o7oyN
        9rmtyXV94bI+zHnXT934CDwlLCYYFzqAt7cDhjWQkC4Fhi5GSsXH6TIKveq0/Ng9ccZDH654OeQji
        Z6BmwUZA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pUsW1-0005Yk-Qp; Wed, 22 Feb 2023 18:02:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 2/2] xlate: Drop dead code
Date:   Wed, 22 Feb 2023 18:02:41 +0100
Message-Id: <20230222170241.26208-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230222170241.26208-1-phil@nwl.cc>
References: <20230222170241.26208-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set type is not needed when manipulating elements, the assigned
variable was unused in that case.

Fixes: 325af556cd3a6 ("add ipset to nftables translation infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 lib/ipset.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index 2e098e435d954..8e63af56d2a51 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -1876,9 +1876,6 @@ static int ipset_xlate(struct ipset *ipset, enum ipset_cmd cmd,
 				cmd == IPSET_CMD_DEL ? "delete" : "get",
 		       ipset_xlate_family(family), table, set);
 
-		typename = ipset_data_get(data, IPSET_OPT_TYPENAME);
-		type = ipset_xlate_set_type(typename);
-
 		xlate_set = (struct ipset_xlate_set *)
 				ipset_xlate_set_get(ipset, set);
 		if (xlate_set && xlate_set->interval)
-- 
2.38.0

