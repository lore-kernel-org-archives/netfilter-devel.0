Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE43C33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2752072C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbrmWZPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgAFS4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:56:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726710AbgAFS4R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=Dh8lw2DNzJRKEq0E/akxy2Xmi5d1kEPv5+7clve7zr4=;
        b=cbrmWZPfv70FDd4tb63W41/ZbXYkxwnCZyqOJOpAp3r0obizvsyutFmd4XFNdh0j7F6Kdw
        5MFm8XzDkBx/9kNIV9X+LPxVJHv5HxdgU3oc1gcZM/owiaA3luRWwj+u4XaFLHAkgXonb2
        vSyWrADdVEZImUxVeuuKcn1oX/7690I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-0BKKEI_yPe-8KUeI3AFk0A-1; Mon, 06 Jan 2020 13:56:13 -0500
X-MC-Unique: 0BKKEI_yPe-8KUeI3AFk0A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95E511087B41;
        Mon,  6 Jan 2020 18:56:11 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A555D9D6;
        Mon,  6 Jan 2020 18:55:51 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 7/9] netfilter: ebtables audit table registration
Date:   Mon,  6 Jan 2020 13:54:08 -0500
Message-Id: <9f16dee52bac9a3068939283a0122a632ee0438d.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generate audit NETFILTER_CFG records on ebtables table registration.

Previously this was only being done for all x_tables operations and
ebtables table replacement.

Call new audit_nf_cfg() to store table parameters for later use with
syscall records.

Here is a sample accompanied record:
  type=NETFILTER_CFG msg=audit(1494907217.558:5403): table=filter family=7 entries=0

See: https://github.com/linux-audit/audit-kernel/issues/43
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/bridge/netfilter/ebtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 57dc11c0f349..58126547b175 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1219,6 +1219,8 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		*res = NULL;
 	}
 
+	if (audit_enabled)
+		audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries);
 	return ret;
 free_unlock:
 	mutex_unlock(&ebt_mutex);
-- 
1.8.3.1

