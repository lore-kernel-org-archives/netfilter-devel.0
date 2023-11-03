Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B39C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 18:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjKCSaP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 14:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbjKCSaN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 14:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133FD4D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699036162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kzU3ECYBb8X7Bsk8TK99RpXB/RO04Ked1wo8mW/gOI=;
        b=V7zAQhkFul5um+zowsYGhn9wc1Fe6xwA4H8zsCvpkenM7NWcHyu+89ujyK7V06AngIG2HS
        zILA0BJ/ME2p4XUW7UaTg10Vm03yrOb7ubxnztqjPA5eEyId/f2U9MwmS7OIvxxDKVC4vx
        bmwfqp3P1DZLvhNKyVjvY1ZCWYfIxRE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-G-TyPsnQOju6u_4UPATZcw-1; Fri, 03 Nov 2023 14:29:18 -0400
X-MC-Unique: G-TyPsnQOju6u_4UPATZcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1CFD185A783
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 18:29:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32F832166B27;
        Fri,  3 Nov 2023 18:29:18 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 6/6] tools: check for consistency of .json-nft dumps in "check-tree.sh"
Date:   Fri,  3 Nov 2023 19:26:03 +0100
Message-ID: <20231103182901.3795263-7-thaller@redhat.com>
In-Reply-To: <20231103182901.3795263-1-thaller@redhat.com>
References: <20231103182901.3795263-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add checks for the newly introduced .json-nft dump files.

Optimally, every test that has a .nft dump should also have a .json-nft
dump, and vice versa.

However, currently some JSON tests fail to validate, and are missing.
Only flag those missing files as warning, without failing the script.
The reason to warn about this, is that we really should fix those tests,
and having a annoying warning increases the pressure and makes it
discoverable.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tools/check-tree.sh | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/check-tree.sh b/tools/check-tree.sh
index 4be874fcd85e..e358c957857e 100755
--- a/tools/check-tree.sh
+++ b/tools/check-tree.sh
@@ -41,6 +41,7 @@ check_shell_dumps() {
 	local base="$(basename "$TEST")"
 	local dir="$(dirname "$TEST")"
 	local has_nft=0
+	local has_jnft=0
 	local has_nodump=0
 	local nft_name
 	local nodump_name
@@ -51,9 +52,11 @@ check_shell_dumps() {
 	fi
 
 	nft_name="$dir/dumps/$base.nft"
+	jnft_name="$dir/dumps/$base.json-nft"
 	nodump_name="$dir/dumps/$base.nodump"
 
 	[ -f "$nft_name" ] && has_nft=1
+	[ -f "$jnft_name" ] && has_jnft=1
 	[ -f "$nodump_name" ] && has_nodump=1
 
 	if [ "$has_nft" != 1 -a "$has_nodump" != 1 ] ; then
@@ -63,6 +66,22 @@ check_shell_dumps() {
 	elif [ "$has_nodump" == 1 -a -s "$nodump_name" ] ; then
 		msg_err "\"$TEST\" has a non-empty \"$dir/dumps/$base.nodump\" file"
 	fi
+	if [ "$has_jnft" = 1 -a "$has_nft" != 1 ] ; then
+		msg_err "\"$TEST\" has a JSON dump file \"$jnft_name\" but lacks a dump \"$nft_name\""
+	fi
+	if [ "$has_nft" = 1 -a "$has_jnft" != 1 ] ; then
+		# it's currently known that `nft -j --check` cannot parse all dumped rulesets.
+		# Accept having no JSON dump file.
+		#
+		# This should be fixed. Currently this is only a warning.
+		msg_warn "\"$TEST\" has a dump file \"$nft_name\" but lacks a JSON dump \"$jnft_name\""
+	fi
+
+	if [ "$has_jnft" = 1 ] && command -v jq &>/dev/null ; then
+		if ! jq empty < "$jnft_name" &>/dev/null ; then
+			msg_err "\"$TEST\" has a JSON dump file \"$jnft_name\" that does not validate with \`jq empty < \"$jnft_name\"\`"
+		fi
+	fi
 }
 
 SHELL_TESTS=( $(find "tests/shell/testcases/" -type f -executable | sort) )
@@ -91,7 +110,7 @@ fi
 
 ##############################################################################
 #
-F=( $(find tests/shell/testcases/ -type f | grep '^tests/shell/testcases/[^/]\+/dumps/[^/]\+\.\(nft\|nodump\)$' -v | sort) )
+F=( $(find tests/shell/testcases/ -type f | grep '^tests/shell/testcases/[^/]\+/dumps/[^/]\+\.\(json-nft\|nft\|nodump\)$' -v | sort) )
 IGNORED_FILES=( tests/shell/testcases/bogons/nft-f/* )
 for f in "${F[@]}" ; do
 	if ! array_contains "$f" "${SHELL_TESTS[@]}" "${IGNORED_FILES[@]}" ; then
-- 
2.41.0

