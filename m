Return-Path: <SRS0=FFQ3=2V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5216DC2D0DE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 19:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B155206E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 19:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrootKd/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLaTuz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Dec 2019 14:50:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727152AbfLaTuz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Dec 2019 14:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=dDerRFQiDMB4JH+dQ0LnfWipbmAqwEpCtX2srRa0o7I=;
        b=FrootKd/HpovOn2e/xymJ2Ou4z3PEe+9jSf1pjUo8mu93LrHoHfUJupZ5nLizqjwAplnWV
        eM6ehUqavoKIrabkpoiAV+yVY7rqL9DDbYj/Zhb1YA09hzdu08/U5wWU7O/M2+t55HDqVS
        Irne0vOzPQfzpeLunJ2ovEZ7bQRHfeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-3B_Idir1PqyCTeeOu7Cqhg-1; Tue, 31 Dec 2019 14:50:52 -0500
X-MC-Unique: 3B_Idir1PqyCTeeOu7Cqhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55D9800D50;
        Tue, 31 Dec 2019 19:50:50 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EBFF67673;
        Tue, 31 Dec 2019 19:50:46 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V8 09/16] audit: add containerid support for user records
Date:   Tue, 31 Dec 2019 14:48:22 -0500
Message-Id: <b15ffa6907fe03debdace27408f889dac731bea5.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 51159c94041c..d4e6eafe5644 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1176,12 +1176,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
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
@@ -1444,13 +1438,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
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
@@ -1466,6 +1463,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_log_end(ab);
+			audit_log_container_id(context, audit_get_contid(current));
+			audit_free_context(context);
 		}
 		break;
 	case AUDIT_ADD_RULE:
-- 
1.8.3.1

