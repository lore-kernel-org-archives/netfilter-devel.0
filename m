Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205CBCDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJPNNG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPNNG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:13:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DACAB
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697461945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPbL7CLbF4+myvjVEiH0ztdpRmqSoihSooDfuw2zU0A=;
        b=dc5bTj9KrMyjrvahibhft/Aenwc8zGncJ3ztyqNIsMcy1Fk9leURO3KpI3UlLYyapvTAUy
        r0SMVEDNvnAKaKni48hiJc6SCDI0hTDmRKx2TriHBlgjZiGXTs0x9aU4611uDEbbn0WdiN
        VjL7D5F9l37uwOQlRPRANxVMKa2apDo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-ft6iWH1APKyHiwQ8nUAOnQ-1; Mon, 16 Oct 2023 09:12:23 -0400
X-MC-Unique: ft6iWH1APKyHiwQ8nUAOnQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B078380391A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 13:12:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C51F3492BEE;
        Mon, 16 Oct 2023 13:12:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] tests/shell: add missing "vlan_8021ad_tag.nodump" file
Date:   Mon, 16 Oct 2023 15:12:09 +0200
Message-ID: <20231016131209.1127298-3-thaller@redhat.com>
In-Reply-To: <20231016131209.1127298-1-thaller@redhat.com>
References: <20231016131209.1127298-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an inconsistency. The test should have either a .nft or a
.nodump file. "./tools/check-tree.sh" enforces that and will in the
future run by `make check`.

Fixes: 74cf3d16d8e9 ('tests: shell: add vlan match test case')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/packetpath/dumps/vlan_8021ad_tag.nodump | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/vlan_8021ad_tag.nodump

diff --git a/tests/shell/testcases/packetpath/dumps/vlan_8021ad_tag.nodump b/tests/shell/testcases/packetpath/dumps/vlan_8021ad_tag.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.41.0

