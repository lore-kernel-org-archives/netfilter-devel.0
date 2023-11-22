Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98329C61DB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbjKVMyu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90BBD58
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3RyDtfJEZq6McpdY/zw/fcQtxh0gfeSyIdBYUC7huac=; b=B+j1tMIwxOziN+KEOO3KbWOKik
        XOzhLuScirAJ5qFZ4CbGY+qH021EKLmSilLbvVhLw7/2CDo9zpr2PvuarZ6G/joqZxYqhsbBDyP8b
        pxSJpZiShp1cUHuHc8l+k+09eJmT52cswkcfclSGODaiMxD7F7cEvif4Uq5X5x4FSLaKPlikPSbnh
        F21hEO9OATeiA010q2yWrjivWvmAHgTfyNAR03zSqfsBdGhDgGjaet54ZWvOHSyWMrxc636q1EntK
        8wlVCy595s02Cjomav8F3P65jU7FsLoyrxPZufZ0/CImVbdRzwFqTYz192p5zJQm1epl0lNqUvid1
        XJR+5qhw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkU-0005SH-VE
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/12] xshared: Drop needless assignment in --help case
Date:   Wed, 22 Nov 2023 14:02:15 +0100
Message-ID: <20231122130222.29453-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Help text printing code does not refer to optarg, so there is no need to
assign to it if unset.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 5f75a0a57a023..53e72b7abb1e8 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1527,9 +1527,6 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'h':
-			if (!optarg)
-				optarg = argv[optind];
-
 			/* iptables -p icmp -h */
 			if (!cs->matches && cs->protocol)
 				xtables_find_match(cs->protocol,
-- 
2.41.0

