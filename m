Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E77C11D10
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 17:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593BC20801
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 17:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgBTRMx convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:12:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727709AbgBTRMw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 12:12:52 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-uwoZ-ubePpOPTGSUyxCD_Q-1; Thu, 20 Feb 2020 12:12:48 -0500
X-MC-Unique: uwoZ-ubePpOPTGSUyxCD_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C96589A0A1;
        Thu, 20 Feb 2020 17:12:46 +0000 (UTC)
Received: from egarver.redhat.com (ovpn-121-46.rdu2.redhat.com [10.10.121.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A645D5C1D8;
        Thu, 20 Feb 2020 17:12:44 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH 2/2] tests: shell: json parsing prefix inside concat
Date:   Thu, 20 Feb 2020 12:12:42 -0500
Message-Id: <20200220171242.15240-2-eric@garver.life>
In-Reply-To: <20200220171242.15240-1-eric@garver.life>
References: <20200220171242.15240-1-eric@garver.life>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Eric Garver <eric@garver.life>
---

# ./run-tests.sh ./testcases/sets/0044json_prefix_in_concat_0
I: using nft binary ./../../src/nft

I: [OK]         ./testcases/sets/0044json_prefix_in_concat_0

I: results: [OK] 1 [FAILED] 0 [TOTAL] 1


# NFT=/usr/sbin/nft ./run-tests.sh ./testcases/sets/0044json_prefix_in_concat_0
I: using nft binary /usr/sbin/nft

W: [FAILED]     ./testcases/sets/0044json_prefix_in_concat_0: got 
internal:0:0-0: Error: Expression type prefix not allowed in context (RHS, PRIMARY).

internal:0:0-0: Error: Parsing expr at index 0 failed.

internal:0:0-0: Error: Invalid set elem at index 0.

internal:0:0-0: Error: Invalid set.

internal:0:0-0: Error: Parsing command array at index 3 failed.

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1

---
 .../shell/testcases/sets/0044json_prefix_in_concat_0  | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0044json_prefix_in_concat_0

diff --git a/tests/shell/testcases/sets/0044json_prefix_in_concat_0 b/tests/shell/testcases/sets/0044json_prefix_in_concat_0
new file mode 100755
index 000000000000..9bc48caa136f
--- /dev/null
+++ b/tests/shell/testcases/sets/0044json_prefix_in_concat_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# JSON parsing "prefix" inside "concat" for a set element
+
+RULESET='{"nftables": [{"metainfo": {"json_schema_version": 1}},
+         {"add": {"table": {"family": "inet", "name": "foobar_table"}}},
+         {"add": {"set": {"family": "inet", "name": "foobar_set", "table": "foobar_table", "type": ["ipv4_addr", "inet_proto", "inet_service"]}}},
+         {"add": {"element": {"elem": [{"concat": [{"prefix": {"addr": "10.10.10.0", "len": 24}}, "sctp", "1234"]}], "family": "inet", "name": "foobar_set", "table": "foobar_table"}}}]}'
+
+set -e
+$NFT -j -f - <<< "$RULESET"
-- 
2.23.0

