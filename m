Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1352C83F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 22:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjH1WO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 18:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjH1WNy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 18:13:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879CA10A
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 15:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693260786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UxpDpPAMPR581hkKTSpjHx5QGnh304423RA3WXpTtQw=;
        b=jCKad89lN9pXX4bM1xApEO1qtdUofs4uL2CGRNQjSncopEcu5HEkSaVTkalIElzPbXreZu
        ubtkjB5GEh9Tkc6DcBZd/2Cf1+bx0XK4X1bOgWkPdKdXiD+xMdA9iYSHE27ZtoMCci5tP9
        uR+tULcUgRAbXCgBM+MgLeqH8KC1lJo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446--bkHvolmNvWFZKT8dRxZ0Q-1; Mon, 28 Aug 2023 18:13:03 -0400
X-MC-Unique: -bkHvolmNvWFZKT8dRxZ0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97018101A52E;
        Mon, 28 Aug 2023 22:13:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.16.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14AD86B2B6;
        Mon, 28 Aug 2023 22:12:58 +0000 (UTC)
From:   Wander Lairson Costa <wander@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Cc:     Wander Lairson Costa <wander@redhat.com>,
        Lucas Leong <wmliang@infosec.exchange>, stable@kernel.org
Subject: [PATCH nf] netfilter/xt_sctp: validate the flag_info count
Date:   Mon, 28 Aug 2023 19:12:55 -0300
Message-ID: <20230828221255.124812-1-wander@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sctp_mt_check doesn't validate the flag_count field. An attacker can
take advantage of that to trigger a OOB read and leak memory
information.

Add the field validation in the checkentry function.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
Reported-by: Lucas Leong <wmliang@infosec.exchange>
Cc: stable@kernel.org
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
---
 net/netfilter/xt_sctp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index e8961094a282..b46a6a512058 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -149,6 +149,8 @@ static int sctp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 
+	if (info->flag_count > ARRAY_SIZE(info->flag_info))
+		return -EINVAL;
 	if (info->flags & ~XT_SCTP_VALID_FLAGS)
 		return -EINVAL;
 	if (info->invflags & ~XT_SCTP_VALID_FLAGS)
-- 
2.41.0

