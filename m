Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FA8CDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjJPNNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPNNS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDB29B
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697461954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1y3lAEXq7Igxwx9He2QGbOzFagcl4qGCk6Baxl0Vhec=;
        b=bwKnV+Mc07eKYVIzZtoPgd33s9bpIjC0HOYuw5oZ5uKGhZ/g/5vZ6decwKFA47MGXAWcVt
        IzEyTWv0dVmLmwu1btDBmDG4v+L230lKYAkknfj+Po9vxEUYob0kegJQ1PYtDRsxW/wpP0
        cfhSrTabFmOvfJ8p2Jeio3MGGSXk190=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-g4hbPAbjOqSAOtoOeLwOSQ-1; Mon, 16 Oct 2023 09:12:22 -0400
X-MC-Unique: g4hbPAbjOqSAOtoOeLwOSQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7308185A5A8
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 13:12:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF3DB492BEE;
        Mon, 16 Oct 2023 13:12:21 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: skip "vlan_8021ad_tag" test instead of failing
Date:   Mon, 16 Oct 2023 15:12:08 +0200
Message-ID: <20231016131209.1127298-2-thaller@redhat.com>
In-Reply-To: <20231016131209.1127298-1-thaller@redhat.com>
References: <20231016131209.1127298-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test "vlan_8021ad_tag" requires recent kernel patches to pass. This
makes the test suite unusable to contributors, who don't also run the
required kernel.

Instead of failing, just skip the test.

If you run with a kernel that is supposed to pass all tests, consider
setting NFT_TEST_FAIL_ON_SKIP=y.

Fixes: 74cf3d16d8e9 ('tests: shell: add vlan match test case')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/packetpath/vlan_8021ad_tag | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/vlan_8021ad_tag b/tests/shell/testcases/packetpath/vlan_8021ad_tag
index 379a5710c1cb..246427062323 100755
--- a/tests/shell/testcases/packetpath/vlan_8021ad_tag
+++ b/tests/shell/testcases/packetpath/vlan_8021ad_tag
@@ -47,4 +47,9 @@ EOF
 ip netns exec "$ns1" ping -c 1 10.1.1.2
 
 ip netns exec "$ns2" $NFT list ruleset
-ip netns exec "$ns2" $NFT list chain netdev t c | grep 'counter packets 1 bytes 84'
+OUT="$(ip netns exec "$ns2" $NFT list chain netdev t c)"
+
+if ! printf "%s" "$OUT" | grep -q 'counter packets 1 bytes 84' ; then
+	echo "Filter did not match. Assume kernel lacks fix https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af84f9e447a65b4b9f79e7e5d69e19039b431c56"
+	exit 77
+fi
-- 
2.41.0

