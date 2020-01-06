Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52917C33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AFE2070E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S17+KfWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgAFSz6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:55:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726769AbgAFSz6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=MlTPBzneVtYNNjunC5VrHTisOJyPpDHhYjuAHEQxRGs=;
        b=S17+KfWJ+RkM5EwGXLMm3g1yYyqxtzI/NliDfIlaWBFpX6Zmil+5rNWlmCTdSKAJEidzNG
        qVBb6SQlJmBEJQ/DxBH9ktUD+fWi6B0ESS1+u1KrjupPNH/yiXfggKJIDO1FT4dmh46izw
        BkwGnKS7Os08kiLDs7EwO2qrgv/onbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-IhwVYfG6M6e3qWwIeHVFBw-1; Mon, 06 Jan 2020 13:55:53 -0500
X-MC-Unique: IhwVYfG6M6e3qWwIeHVFBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D68041013DA4;
        Mon,  6 Jan 2020 18:55:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 230685DE54;
        Mon,  6 Jan 2020 18:55:42 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 6/9] netfilter: ebtables audit only on syscall rule
Date:   Mon,  6 Jan 2020 13:54:07 -0500
Message-Id: <a1de082129f5db330c0a16b3d8b279a99c5529f2.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call new audit_nf_cfg() to store table parameters for later use with
syscall records.

See: https://github.com/linux-audit/audit-kernel/issues/25
See: https://github.com/linux-audit/audit-kernel/issues/35
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/bridge/netfilter/ebtables.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b3c784ae33a0..57dc11c0f349 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1048,14 +1048,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	vfree(table);
 	vfree(counterstmp);
 
-#ifdef CONFIG_AUDIT
-	if (audit_enabled) {
-		audit_log(audit_context(), GFP_KERNEL,
-			  AUDIT_NETFILTER_CFG,
-			  "table=%s family=%u entries=%u",
-			  repl->name, AF_BRIDGE, repl->nentries);
-	}
-#endif
+	if (audit_enabled)
+		audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries);
 	return ret;
 
 free_unlock:
-- 
1.8.3.1

