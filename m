Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC25EC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19C861157
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhEEWY3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 18:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234161AbhEEWY3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 18:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620253411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqNLu+jo2XqXQFp+JYMjAaFVk0sl3VX7A0+vltL/YWw=;
        b=HNBlhJlMqc1iS4vVNgz6qqYDAxOiBFXLm/rmeGdVbmcnH1Gmah/KMEgDexz/n3f56FwMee
        JzAKWp4yP/Uy4rWAtuoFS1Z2Nw2DBRlJjYDqIe85oDaHHJRaZ7gd/Fqt+JP9HHmGt6yTLF
        q7KKbM9Hmh+eXN4aaGnzhD8/f6YAu+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-hnwAdSFsN2q9BGtD-4K71w-1; Wed, 05 May 2021 18:23:26 -0400
X-MC-Unique: hnwAdSFsN2q9BGtD-4K71w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B62E8835DE1;
        Wed,  5 May 2021 22:23:25 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAB6859460;
        Wed,  5 May 2021 22:23:24 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: Introduce 0043_concatenated_ranges_1 for subnets of different sizes
Date:   Thu,  6 May 2021 00:23:14 +0200
Message-Id: <def76b5915ae21136ef76dad8fb3590893c4bc6a.1620252768.git.sbrivio@redhat.com>
In-Reply-To: <cover.1620252768.git.sbrivio@redhat.com>
References: <cover.1620252768.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The report from https://bugzilla.netfilter.org/show_bug.cgi?id=1520
showed a display issue with particular IPv6 mask lengths in elements
of sets with concatenations. Make sure we cover insertion and listing
of different mask lengths in concatenated set elements for IPv4 and
IPv6.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0043concatenated_ranges_1  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0043concatenated_ranges_1

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_1 b/tests/shell/testcases/sets/0043concatenated_ranges_1
new file mode 100755
index 000000000000..bab189c56d8c
--- /dev/null
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_1
@@ -0,0 +1,23 @@
+#!/bin/sh -e
+#
+# 0043concatenated_ranges_1 - Insert and list subnets of different sizes
+
+check() {
+	$NFT add element "${1}" t s "{ ${2} . ${3} }"
+	[ "$( $NFT list set "${1}" t s | grep -c "${2} . ${3}" )" = 1 ]
+}
+
+$NFT add table ip6 t
+$NFT add table ip  t
+
+$NFT add set ip6 t s '{ type ipv6_addr . ipv6_addr ; flags interval ; }'
+$NFT add set ip  t s '{ type ipv4_addr . ipv4_addr ; flags interval ; }'
+
+for n in $(seq 32 127); do
+	h="$(printf %x "${n}")"
+	check ip6 "2001:db8::/${n}" "2001:db8:${h}::-2001:db8:${h}::${h}:1"
+done
+
+for n in $(seq 24 31); do
+	check ip  "192.0.2.0/${n}"  "192.0.2.$((n * 3))-192.0.2.$((n * 3 + 2))"
+done
-- 
2.30.2

