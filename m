Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCC9C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 03:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1182082A
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 03:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfDIDk6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 23:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbfDIDk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 23:40:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 592CA3007C32;
        Tue,  9 Apr 2019 03:40:57 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40CE819C70;
        Tue,  9 Apr 2019 03:40:52 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V6 07/10] audit: add containerid support for user records
Date:   Mon,  8 Apr 2019 23:39:14 -0400
Message-Id: <1f814bc706534e70d4c79bb66d3c53d0e606b503.1554732921.git.rgb@redhat.com>
In-Reply-To: <cover.1554732921.git.rgb@redhat.com>
References: <cover.1554732921.git.rgb@redhat.com>
In-Reply-To: <cover.1554732921.git.rgb@redhat.com>
References: <cover.1554732921.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Apr 2019 03:40:57 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add audit container identifier auxiliary record to user event standalone
records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 kernel/audit.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 87e1d367f98c..6c742da66b32 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1143,12 +1143,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
 	audit_log_task_context(*ab);
 }
 
-static inline void audit_log_user_recv_msg(struct audit_buffer **ab,
-					   u16 msg_type)
-{
-	audit_log_common_recv_msg(NULL, ab, msg_type);
-}
-
 int is_audit_feature_set(int i)
 {
 	return af.features & AUDIT_FEATURE_TO_MASK(i);
@@ -1411,13 +1405,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */
+			struct audit_context *context;
+
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
 				err = tty_audit_push();
 				if (err)
 					break;
 			}
-			audit_log_user_recv_msg(&ab, msg_type);
+			context = audit_alloc_local(GFP_KERNEL);
+			audit_log_common_recv_msg(context, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY)
 				audit_log_format(ab, " msg='%.*s'",
 						 AUDIT_MESSAGE_TEXT_MAX,
@@ -1433,6 +1430,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_log_end(ab);
+			audit_log_contid(context, audit_get_contid(current));
+			audit_free_context(context);
 		}
 		break;
 	case AUDIT_ADD_RULE:
-- 
1.8.3.1

