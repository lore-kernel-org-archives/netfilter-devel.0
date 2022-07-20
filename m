Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BEAC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 13:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiGTNHZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 09:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiGTNHY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 09:07:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A34DD3F33C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 06:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658322441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MwshKh8BZoUxMOdl98HK0W/7vwRrQT+1tUggMU8hyj4=;
        b=NmDQwhaxnSBCdCGKRfjW3fsZUbqhXGCY5XGZTZrWBnqEXpr9zYITyQQnXzsNqfFQKyT5B8
        GV0JUF7JXmqZcX1MjOgdU37nkOwCykZCE475u5uV6em6ZiVZa540I7Um37AmhmEK3OIYcP
        hNjdjCgKxSdbGXltSVq2SLcO6TLRHfw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-b9S53TmHNASQtTIiNbNUjw-1; Wed, 20 Jul 2022 09:07:11 -0400
X-MC-Unique: b9S53TmHNASQtTIiNbNUjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A193802B8F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 13:07:10 +0000 (UTC)
Received: from nautilus.redhat.com (unknown [10.40.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B6702166B26;
        Wed, 20 Jul 2022 13:07:10 +0000 (UTC)
From:   Erik Skultety <eskultet@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Erik Skultety <eskultet@redhat.com>
Subject: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field in ipv6's fake mode
Date:   Wed, 20 Jul 2022 15:06:50 +0200
Message-Id: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The fact that the 'opt' table field reports spaces instead of '--' for
IPv6 as it would have been the case with IPv4 has a bit of an
unfortunate side effect that it completely confuses the 'jc' JSON
formatter tool (which has an iptables formatter module).
Consider:
    # ip6tables -L test
    Chain test (0 references)
    target     prot opt source   destination
    ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06

Then:
    # ip6tables -L test | jc --iptables
    [{"chain":"test",
      "rules":[
          {"target":"ACCEPT",
           "prot":"all",
           "opt":"a:b:c::",
           "source":"anywhere",
           "destination":"MAC01:02:03:04:05:06"
          }]
    }]

which as you can see is wrong simply because whitespaces are considered
as a column delimiter.

Signed-off-by: Erik Skultety <eskultet@redhat.com>
---
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index bd4e1022..b1088c82 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -731,7 +731,7 @@ void print_fragment(unsigned int flags, unsigned int invflags,
 		fputs("opt ", stdout);
 
 	if (fake) {
-		fputs("  ", stdout);
+		fputs("--", stdout);
 	} else {
 		fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
 		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
-- 
2.36.1

