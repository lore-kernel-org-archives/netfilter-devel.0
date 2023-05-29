Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6317CC77B7E
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 May 2023 17:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjE2RTF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 May 2023 13:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjE2RTE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2023 13:19:04 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B40EAB
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2023 10:19:03 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f60804faf4so22628315e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2023 10:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685380742; x=1687972742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G4mGkzEHCYiyMW/6EVqtuYnSCqFKvi1mBw3EtRrjrTE=;
        b=nhHJswp3WvGdhzs69WluIXBbPYfu5UkXjbF/PZTi8DH/0RibRUi8qwHW9timGP728B
         SeCTY0n1pLZKozFDa2/kNmKXxH0pq6X2vW8vWa/Hqi/aem+OgDKtejR6vIaP4UXZuOOL
         hjPxavaC/i4i7u5td5uGnlbqoA9U2YmoZvxLJVevi1Oyz7Ig9zRKQtDwKYAdS5SX7QjR
         9k5g627P3msSsPaPH/Kd0sseoXP2AKPf4ny1SdjhDQvj68goAW+vXo3j1/1nJiJtAWlv
         D1oSvaV2nKn2COukYt7dajtTIKZfvqdLxNSB6a5tOa7C7nwDcxtrtiihFKPqFYv+qMFP
         hpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685380742; x=1687972742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4mGkzEHCYiyMW/6EVqtuYnSCqFKvi1mBw3EtRrjrTE=;
        b=OWbDOzeoVjcqPBETrV0/L+Z0TrfbSJqXvcHDVvS1iQC0UdSXtps5OurfTU8tcenPkS
         H5dSRFmyGxC1F/h2kooApYvQ7VY8lEuCd85fsQ/UI6eQYMyKvIOPncHU1EFh8oyUxqQq
         eX806lrmTwol8D1wWpPtBP04V1UGtaE/OpFNsJh8Y3GvL5w/0jcMWl1c4P3p+iiuBKs9
         b/CDIM5bsvCF+CPJsZ8uXsibzm+UpxbqpLQ8oI5+pbyJ2iRcBABcRXckGiaZ/sPWx5SQ
         lmufQ4mq1niIOLGOE3YkSHqu7QzywahOmwfsJmSLPUz5EjLrfc297/udf7fdybWqgOQW
         nCUQ==
X-Gm-Message-State: AC+VfDybCa/0TKlqlmInvkqojmqjX/M2ThIzvmsvDBTQy8UMUUSCMvwO
        mIAzByCfGDmFsQdY0G3VOZm4OKNKawY=
X-Google-Smtp-Source: ACHHUZ4HqGeEQnKXL4/2gVJ2AV+rrCXIH5wABtOC+aTMHDw03m4kabZ4sc2IBmeDMpQg7iQ2v87IEg==
X-Received: by 2002:a05:600c:2158:b0:3f5:ffe7:bf11 with SMTP id v24-20020a05600c215800b003f5ffe7bf11mr11805537wml.36.1685380741628;
        Mon, 29 May 2023 10:19:01 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q25-20020a7bce99000000b003f4268f51f5sm14952759wmj.0.2023.05.29.10.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 10:19:01 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [iptables PATCH] xshared: fix memory leak in should_load_proto
Date:   Mon, 29 May 2023 19:18:46 +0200
Message-Id: <20230529171846.10616-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With the help of a Coverity Scan, it was pointed out that it's present a
memory leak in the corner case where find_proto is not NULL in the
function should_load_proto. find_proto return a struct xtables_match
pointer from xtables_find_match that is allocated but never freed.

Correctly free the found proto in the corner case where find_proto
succeed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 iptables/xshared.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 17aed04e..0beacfdc 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -113,11 +113,16 @@ find_proto(const char *pname, enum xtables_tryload tryload,
  */
 static bool should_load_proto(struct iptables_command_state *cs)
 {
+	struct xtables_match *proto;
+
 	if (cs->protocol == NULL)
 		return false;
-	if (find_proto(cs->protocol, XTF_DONT_LOAD,
-	    cs->options & OPT_NUMERIC, NULL) == NULL)
+	proto = find_proto(cs->protocol, XTF_DONT_LOAD,
+			   cs->options & OPT_NUMERIC, NULL);
+	if (proto == NULL)
 		return true;
+
+	free(proto);
 	return !cs->proto_used;
 }
 
-- 
2.39.2

