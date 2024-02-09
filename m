Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105D4689
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707480727; cv=none; b=kn9PXhOjBgYBPCptEeihEOxMEZxsfCzPvC2ttutt6/RUekNrXoJ6YSCOf9Wod4h7UCxaIaiYjxs5aH/oaTUnhTldh45IgYoNtRQwRO4RzAmsDRId6Gy7VDJSATofcf5YXZoKe7P2cpesa/TEulRGKgl8j+0usYa0l/TDJmT++8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707480727; c=relaxed/simple;
	bh=hbVYQkhlgWIJD1BvJRqU45Xk+4CpJwUNrclGNQte/GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rl+Vm1YpB17YAdaKPjmlt5hwbz+1KBntV2pqz2Cc9YRwUXdfe2IrDFHKj1Rw1g61L85PkrfK2GoW5OoTQYbRbqa+f3ass5FQiQqzESNw3mCMGL2H9JDoOvj6Eg2OF8pza3FQLdE+vi7ArRphPcl9k1votZgS/DLbAP18pCzajmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AEYewaJC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEYewaJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707480720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x9PT3Y0vMnAWZW3M66DZzZveLiboYRAcPjbWcE9zhTk=;
	b=AEYewaJCvoK/iNAsQqyBSl/tChzj0dCrIH26UrQebm2U/yfZ9kJApgNe/u4bJg99sleM+w
	yJ+lArqtoj7RxMyE8YBsytDdtxvwwwjqFIC4yLR/8jSipefvXaK9pyOfhrg78Q4hqpx5rU
	1dNhuyjDMycjCxrJKEPI1jY1E9urmHc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-2XRiCE0dN76j5yNcl7XcfA-1; Fri,
 09 Feb 2024 07:11:58 -0500
X-MC-Unique: 2XRiCE0dN76j5yNcl7XcfA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 969911C05129
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:11:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.59])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17F4A492BC6;
	Fri,  9 Feb 2024 12:11:57 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH 1/1] tests/shell: no longer support unprettified ".json-nft" files
Date: Fri,  9 Feb 2024 13:10:39 +0100
Message-ID: <20240209121147.2294486-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

By now, all ".json-nft" files are prettified and will be generated in
that form.

Drop the fallback code that accepts them in the previous form.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index f1f33991b454..c016e0ce1d39 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -191,12 +191,7 @@ if [ "$rc_test" -eq 0 -a '(' "$DUMPGEN" = all -o "$DUMPGEN" = y ')' ] ; then
 		cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a "$gen_jdumpfile" = y ] ; then
-		if cmp "$NFT_TEST_TESTTMPDIR/ruleset-after.json" "$JDUMPFILE" &>/dev/null ; then
-			# The .json-nft file is still the non-pretty variant. Keep it.
-			:
-		else
-			cat "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" > "$JDUMPFILE"
-		fi
+		cat "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" > "$JDUMPFILE"
 	fi
 fi
 
@@ -211,16 +206,8 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
 		fi
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
-		JDUMPFILE2="$NFT_TEST_TESTTMPDIR/json-nft-pretty"
-		json_pretty "$JDUMPFILE" > "$JDUMPFILE2"
-		if cmp "$JDUMPFILE" "$JDUMPFILE2" &>/dev/null ; then
-			# The .json-nft file is already prettified. We can use
-			# it directly.
-			rm -rf "$JDUMPFILE2"
-			JDUMPFILE2="$JDUMPFILE"
-		fi
-		if ! $DIFF -u "$JDUMPFILE2" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
-			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE2\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 			rc_dump=1
 		else
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff.json"
-- 
2.43.0

