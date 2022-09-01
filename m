Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2801ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiIAQLT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 12:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiIAQLS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 12:11:18 -0400
Received: from mail-pf1-x464.google.com (mail-pf1-x464.google.com [IPv6:2607:f8b0:4864:20::464])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E4D642F5
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 09:11:16 -0700 (PDT)
Received: by mail-pf1-x464.google.com with SMTP id c66so7636754pfc.10
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2022 09:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=inthat-cloud.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=CP4jEgIFWrjdWhgS3zkcOlo8wxbrIoLr4R8OYg/mfyE=;
        b=aDDobJyYw/isSco970kRuKgB5w5ixM+dKscAVwzQ5Uea+yByhplJ7iGFC4oqMyJUEN
         KmvuIUMKtPFEeC9BbpqRxynDJqQ7p7vQNjamtpeQA2e46KVnQ+45PibHfJnpe1OT1naO
         qHJ4szcdgbBuadxoJGzSoYUhkqpiuT/+FKEESFUQNzuT1v7nUfSxojX7sG0bg6CXrx3H
         cR544LCnKPkXECIcSgXvJ3EVSr0WpCf0eF0GNRDhywj49yz94enrilRqWvR5vAC5gH5s
         SsCzrAgxRfjnqHMY/g67nC46daKrYJ05EmMSMAdV0arXL1S54k/h3FITqPkJF5DNxoaF
         n+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=CP4jEgIFWrjdWhgS3zkcOlo8wxbrIoLr4R8OYg/mfyE=;
        b=ak1U9Qlzf7OWFxNJOiGgQ4FdHCX2yVjSlFONH7pqOp1lrM3yVdYrQLHre40LEYrYyZ
         YGF0j8zIEjkLwRKZCb7lXykTXaK7wywkB594aT+WGvbk5ZOC0YVflOM3k4kVphy00GG7
         ZjJdnikK3aq4ZpK7IHRj7iuQ1brTJnmbPyW8Y6q49EKt0P6o4kfHs3dpHfUKOgxZVY03
         LAjEOSvTep/3w33TNGG2oDYD7b0ig2UHhCZPU240Bxb6W26xKS4A3QZVdgmgrzHdeHJY
         hBYzpVYrN63JkXTApIcI0i4PH8TDMWbcCu1lJYR2kYpwgJMLyHA3kfc+ekbj2/TKQ8NV
         eR5Q==
X-Gm-Message-State: ACgBeo2Hco6lACxpN+3XozbOAt60jDWAebpFWJfbdXeCDGn3gAKKKNDL
        Bfo1owCFdS7PI3UvC3P4jPwSZsGHBCOifEmCBpAzVuWL0Y16aQ==
X-Google-Smtp-Source: AA6agR7k7UITXQS4Tx6oECXDbIIAkqbNMiqewL+fTbWpxyWH3GoeVbaIqTyrtauJrZwQDifOyVHDMgfvHmWr
X-Received: by 2002:a63:3:0:b0:42e:16f4:145f with SMTP id 3-20020a630003000000b0042e16f4145fmr11449081pga.141.1662048675590;
        Thu, 01 Sep 2022 09:11:15 -0700 (PDT)
Received: from inthat.cloud (ec2-34-193-47-23.compute-1.amazonaws.com. [34.193.47.23])
        by smtp-relay.gmail.com with ESMTPS id n16-20020a170902e55000b00172b4ef0951sm108449plf.56.2022.09.01.09.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 09:11:15 -0700 (PDT)
X-Relaying-Domain: inthat.cloud
From:   Derek Hageman <hageman@inthat.cloud>
To:     netfilter-devel@vger.kernel.org
Cc:     Derek Hageman <hageman@inthat.cloud>
Subject: [PATCH nftables] rule: check address family in set collapse
Date:   Thu,  1 Sep 2022 10:10:41 -0600
Message-Id: <20220901161041.14814-1-hageman@inthat.cloud>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

498a5f0c added collapsing of set operations in different commands.
However, the logic is currently too relaxed.  It is valid to have a
table and set with identical names on different address families.
For example:

  table ip a {
    set x {
      type inet_service;
    }
  }
  table ip6 a {
      set x {
        type inet_service;
      }
  }
  add element ip a x { 1 }
  add element ip a x { 2 }
  add element ip6 a x { 2 }

The above currently results in nothing being added to the ip6 family
table due to being collapsed into the ip table add.  Prior to 498a5f0c
the set add would work.  The fix is simply to check the family in
addition to the table and set names before allowing a collapse.

Fixes: 498a5f0c ("rule: collapse set element commands")
Signed-off-by: Derek Hageman <hageman@inthat.cloud>
---
 src/rule.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 9c9eaec0..1caee58f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1414,7 +1414,8 @@ bool nft_cmd_collapse(struct list_head *cmds)
 			continue;
 		}
 
-		if (strcmp(elems->handle.table.name, cmd->handle.table.name) ||
+		if (elems->handle.family != cmd->handle.family ||
+		    strcmp(elems->handle.table.name, cmd->handle.table.name) ||
 		    strcmp(elems->handle.set.name, cmd->handle.set.name)) {
 			elems = cmd;
 			continue;
-- 
2.37.2

