Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F711C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbiCYKwK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiCYKwG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:52:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC16CC527
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lj2KuUWs4yIuO2crQSuAyKIc0FaJGXfh2iHjkd2r0K0=; b=XqZCdz5TNbhfkU7WtbdE0A5JAp
        nV1yjn9/NImSsloWO3RKnNhN07zCwMzLrWttVLyzePmJxwD0jJJZ6y3VeGkkG2MuhK+CjislE1D5j
        +cZtEv6GZBdGinibKdjMHmA+s/w8eLJC/YJ0zViJXGhH4TgwCXinOuEnFat7T11gYXRgOU3i1Tq0R
        85wOWVZKSU+NxGhglGaBOE75FxL93Mm3/8z7k8i2Y2P1cN0ttLGXUSf0X0BRMv6A18TZnaq8+V1xV
        Hvg04lJdLA8uV9wG1nqN2N65FC+XeZEgchdUsmLtMUQQVHcnNHC9GUZfoTVkLPERAk2eyCFVcC7FJ
        VhU4bYzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWY-0007zh-T3; Fri, 25 Mar 2022 11:50:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 7/8] Drop pointless assignments
Date:   Fri, 25 Mar 2022 11:50:02 +0100
Message-Id: <20220325105003.26621-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These variables are not referred to after assigning within their scope
(or until they're overwritten).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/helpers/ssdp.c | 1 -
 src/main.c         | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
index 0c6f563c592aa..527892cdabf8a 100644
--- a/src/helpers/ssdp.c
+++ b/src/helpers/ssdp.c
@@ -256,7 +256,6 @@ static int find_hdr(const char *name, const uint8_t *data, int data_len,
 		data += i+2;
 	}
 
-	data_len -= name_len;
 	data += name_len;
 	if (pos)
 		*pos = data;
diff --git a/src/main.c b/src/main.c
index 31e0eed950b48..de4773df8a204 100644
--- a/src/main.c
+++ b/src/main.c
@@ -319,7 +319,7 @@ int main(int argc, char *argv[])
 
 	umask(0177);
 
-	if ((ret = init_config(config_file)) == -1) {
+	if (init_config(config_file) == -1) {
 		dlog(LOG_ERR, "can't open config file `%s'", config_file);
 		exit(EXIT_FAILURE);
 	}
-- 
2.34.1

