Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEFCC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84486206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W82c2gPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgFNVmL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:42:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727939AbgFNVmK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592170929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zNfzAJH+ArXJdXj+MJTvzy88hNG5o9UrCURuZqn/T0k=;
        b=W82c2gPDa6t77jQBR6hYF4daH05x+SYC3lBww97eILgYRf/iZEoaRQTcZFwWm1Xunl/AOT
        Hgqa50kMvN8eC1w9fg3ubBu3TpNrYuraUyucuFSP87lr8iBps/jP3ufhW98pm4EMHpy2lP
        HGJn11lNAfMidhkpthdKBOlccSUbt6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-pKN2ryl1M8-94JsUz4HzRQ-1; Sun, 14 Jun 2020 17:42:06 -0400
X-MC-Unique: pKN2ryl1M8-94JsUz4HzRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16EFD7BAE;
        Sun, 14 Jun 2020 21:42:05 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F02BD7FE93;
        Sun, 14 Jun 2020 21:42:03 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: Run in separate network namespace, don't break connectivity
Date:   Sun, 14 Jun 2020 23:41:57 +0200
Message-Id: <8efb5334f8b4df21b8833e576abd5721486c0182.1592170411.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It might be convenient to run tests from a development branch that
resides on another host, and if we break connectivity on the test
host as tests are executed, we can't run them this way.

If kernel implementation (CONFIG_NET_NS), unshare(1), or Python
bindings for unshare() are not available, warn and continue.

Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/py/nft-test.py     | 6 ++++++
 tests/shell/run-tests.sh | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 01ee6c980ad4..df97ed8eefb7 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1394,6 +1394,12 @@ def main():
     # Change working directory to repository root
     os.chdir(TESTS_PATH + "/../..")
 
+    try:
+        import unshare
+        unshare.unshare(unshare.CLONE_NEWNET)
+    except:
+        print_warning("cannot run in own namespace, connectivity might break")
+
     check_lib_path = True
     if args.library is None:
         if args.host:
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index fcc87a8957c8..328c412e66f9 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -22,6 +22,15 @@ if [ "$(id -u)" != "0" ] ; then
 	msg_error "this requires root!"
 fi
 
+if [ "${1}" != "run" ]; then
+	if unshare -f -n true; then
+		unshare -n "${0}" run $@
+		exit $?
+	fi
+	msg_warn "cannot run in own namespace, connectivity might break"
+fi
+shift
+
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
 ret=$?
-- 
2.27.0

