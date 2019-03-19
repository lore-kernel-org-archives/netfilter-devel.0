Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A2DC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A4DC2075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfCST44 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:56:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfCST44 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:56:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8769631688F3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 19:56:56 +0000 (UTC)
Received: from r.bos.redhat.com (unknown [10.18.57.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 444BB7701E
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 19:56:56 +0000 (UTC)
From:   Brian Haley <bhaley@redhat.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] Allow protocol number zero
Date:   Tue, 19 Mar 2019 15:56:55 -0400
Message-Id: <20190319195655.14200-1-bhaley@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 19 Mar 2019 19:56:56 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

/etc/protocols defines protocol zero as 'ip' for IPv4, and
'hopopt' for IPv6, which can be used with conntrack as '-p ip'
or '-p hopopt'.  However it's equivalent, '-p 0' is considered
unsupported.  Change the range check in findproto() to allow
zero as well.

Signed-off-by: Brian Haley <bhaley@redhat.com>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index daa93db..97132a9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -628,7 +628,7 @@ static struct ctproto_handler *findproto(char *name, int *pnum)
 	}
 	/* using a protocol number? */
 	protonum = atoi(name);
-	if (protonum > 0 && protonum <= IPPROTO_MAX) {
+	if (protonum >= 0 && protonum <= IPPROTO_MAX) {
 		/* try lookup by number, perhaps this protocol is supported */
 		list_for_each_entry(cur, &proto_list, head) {
 			if (cur->protonum == protonum) {
-- 
2.17.1

