Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C500C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 487C8204EC
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0m5FsJR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgGPREF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPREE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 13:04:04 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBE5C061755;
        Thu, 16 Jul 2020 10:04:04 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e12so5427351qtr.9;
        Thu, 16 Jul 2020 10:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+cTYKrIZGIZVopU+BckUssD7pZ9lKGNH0yEl3jPyoXM=;
        b=X0m5FsJRJcZvg+C03g6IVxn4mV5SvH+bqDqn8BmS1O44A3Q89s7vwJt6iXTn06Mk9f
         BCCMsuyp/R1k8p+tCjgrloI0iJSwfXy+ButeOdWUsBSjjzIVlTpWydjbe+3/2JuObISJ
         aLrKGp+aag4KtfUiHdpIb3DlMSxb8Ci/SSkNGURI+nBIfEo9rbVJdEubjYjU/HvDUycl
         t2SNi6R4yPw66MxhjmgE0I7SE5PxteqDx0OkISzEI1BOZp/t+r0u+3ucy69Tz7EjN7dB
         z3OLo1qxmT2+lBxVV627iEQnBmJgk4ovlaDHrRI2pktc5lDhGEOU0Gwn0s+u6JNN/90U
         SiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+cTYKrIZGIZVopU+BckUssD7pZ9lKGNH0yEl3jPyoXM=;
        b=cUdtj9VoNdmoWI7Ysith6SRXieqt1OKgAJgEm3iSQebX9JKx5PixBDkvEw+uFty3n/
         bG6DtkbTVRXX3uf5ezudx9z/dTkYYu7nElWvbYdd3OrysXyy8W39yX1agP4lfYyDZJqz
         f6nuyrmFkhPjpTFl5jG0xGpjs2A5y/hZVkbTAkHr9+vdX4A7LfsVoyMAzmyy1i4YFDbu
         T2rS1cd9BoIv4DGTDiecyYWPuggdlxog/+CFqdYLtNeT5KsjByMqjT00WOWNADxxllvw
         sB9zz3iPLW+TgWiFF/pWPTL0nEGXJK0CqmwKQKJ4YTHRqdFStJAqN8nw/kaPj75+zNWz
         j3BQ==
X-Gm-Message-State: AOAM531Hz3/bw+A62ImHRO1uoI3akUpHzXt19uw72X539BsYaPRsYvkm
        6IvJiDPBPks1p9VvMvjzbSo=
X-Google-Smtp-Source: ABdhPJwCNUpfl9GDWZd7PBrvQE2OKVLkC57nkE9i7h2WBmRvq70Chlr1N+oIgtxu2B+FqNJXVGEdbw==
X-Received: by 2002:aed:2a4d:: with SMTP id k13mr6240989qtf.376.1594919043612;
        Thu, 16 Jul 2020 10:04:03 -0700 (PDT)
Received: from T480s.vmware.com (toroon0411w-lp130-02-64-231-189-42.dsl.bell.ca. [64.231.189.42])
        by smtp.googlemail.com with ESMTPSA id o50sm8856571qtc.64.2020.07.16.10.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 10:04:03 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Andrew Sy Kim <kim.andrewsy@gmail.com>
Subject: [PATCH net-next] ipvs: ensure RCU read unlock when connection flushing and ipvs is disabled
Date:   Thu, 16 Jul 2020 13:03:14 -0400
Message-Id: <20200716170314.9617-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When ipvs is disabled in ip_vs_expire_nodest_conn_flush,
we should break instead of return so that rcu_read_unlock()
is run.

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a5e9b2d55e57..a90b8eac16ac 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1422,7 +1422,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
 
 		/* netns clean up started, abort delayed work */
 		if (!ipvs->enable)
-			return;
+			break;
 	}
 	rcu_read_unlock();
 }
-- 
2.20.1

