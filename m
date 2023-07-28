Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C4EC0015E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 12:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbjG1McP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbjG1McP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 08:32:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886C3187
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 05:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vAMmkCR7a53rn4nsvServ8hd9o8i0isuVTB84quE5a8=; b=SM090ZlQlAsqjk1P0IGQKFVM4O
        GY6v/p0O8ErSrWKiu9VbeozTNfWgXpTB3VWZqEiz2+VSsAH5svO1wDi+WccbTx2L0EIzl/rUE/ER9
        Km4A09GZwpQOHroA/B/b+9ghHnEZS6hbHQ4tE6HUVGj41f18MDcQ1h+VVRavLEjheS3lwqf9PGTZI
        lBOEb10YXv0U/VVg7PR1ktaOcUlWpCJPtS2ICoMMhnhYM6kfubCpee++Ws9jmHVdS7BgPfx46b49f
        Iofl+ry2zlt69AOsfj8VZRPBGxXT7z4ESZJ0h4GRo3TB0BNsrtmotO411KUHWi/VL+6H5tRxwLnhX
        vp5ZuF/g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qPMdg-0006CF-LJ
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 14:32:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] *tables: Reject invalid chain names when renaming
Date:   Fri, 28 Jul 2023 14:31:45 +0200
Message-Id: <20230728123147.15750-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230728123147.15750-1-phil@nwl.cc>
References: <20230728123147.15750-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While given chain name was sanity checked with --new-chain command,
--rename-chain command allowed to choose an invalid name. Keep things
consistent by adding the missing check.

Fixes: e6869a8f59d77 ("reorganized tree after kernel merge")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 28c65faed7b25..5f75a0a57a023 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1511,6 +1511,7 @@ void do_parse(int argc, char *argv[],
 					   "-%c requires old-chain-name and "
 					   "new-chain-name",
 					    cmd2char(CMD_RENAME_CHAIN));
+			assert_valid_chain_name(p->newname);
 			break;
 
 		case 'P':
-- 
2.40.0

