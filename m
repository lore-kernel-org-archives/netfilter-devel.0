Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5DACDB484
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 08:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjJQIwk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbjJQIwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 04:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2A4FC
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 01:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697532708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMUAV9soztNnC3XA+QFgpSl/liCfrpysk6E27v4lHLg=;
        b=Nzec84gEeMPI7rd6e8wLcw3MNABjxYXJPhE0sKtmQC+InlvDPsASTtc9hsXs9jv9O5BCwZ
        C1X/MexI7U3fv9fNks6FkbnAGPG17bkNsm2yH8XiRhy1iFVekNTOWMOVAD7yb9m9O7OxM7
        dxsHAENk3vP2IJLFAlJDbSwaNs0c8gQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-k1VolVd0N32P6FBD-MxoZw-1; Tue, 17 Oct 2023 04:51:46 -0400
X-MC-Unique: k1VolVd0N32P6FBD-MxoZw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 893C73827983
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 08:51:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09AB3492BEE;
        Tue, 17 Oct 2023 08:51:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 3/3] tests/shell: skip "vlan_8021ad_tag" test on older kernels
Date:   Tue, 17 Oct 2023 10:49:08 +0200
Message-ID: <20231017085133.1203402-4-thaller@redhat.com>
In-Reply-To: <20231017085133.1203402-1-thaller@redhat.com>
References: <20231017085133.1203402-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "vlan_8021ad_tag" test can only pass with certain (recent) kernels.
Conditionally exit with status 77, if "eval-exit-code" determines that
we don't have a suitable kernel version.

In this case, we can find the fixes in:

 v6.6      : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af84f9e447a65b4b9f79e7e5d69e19039b431c56
 v6.5.7    : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3f6a5636a96687381b329649950f21258bae380d

Fixes: 74cf3d16d8e9 ('tests: shell: add vlan match test case')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/packetpath/vlan_8021ad_tag | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/vlan_8021ad_tag b/tests/shell/testcases/packetpath/vlan_8021ad_tag
index 379a5710c1cb..6d908fe330df 100755
--- a/tests/shell/testcases/packetpath/vlan_8021ad_tag
+++ b/tests/shell/testcases/packetpath/vlan_8021ad_tag
@@ -47,4 +47,10 @@ EOF
 ip netns exec "$ns1" ping -c 1 10.1.1.2
 
 ip netns exec "$ns2" $NFT list ruleset
-ip netns exec "$ns2" $NFT list chain netdev t c | grep 'counter packets 1 bytes 84'
+OUT="$(ip netns exec "$ns2" $NFT list chain netdev t c)"
+
+if ! printf "%s" "$OUT" | grep -q 'counter packets 1 bytes 84' ; then
+	echo "Filter did not match. Missing https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af84f9e447a65b4b9f79e7e5d69e19039b431c56 ?"
+	"$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel  6.6  6.5.7
+	exit $?
+fi
-- 
2.41.0

