Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6EEC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhKXR14 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbhKXR1z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD92C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:46 -0800 (PST)
Received: from localhost ([::1]:44922 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0i-0001Bj-Bw; Wed, 24 Nov 2021 18:24:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 14/15] tests/py/tools: Add regen_payloads.sh
Date:   Wed, 24 Nov 2021 18:22:50 +0100
Message-Id: <20211124172251.11539-15-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The script used to regenerate all payload records after massive changes
to libnftnl debug output formatting.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/tools/regen_payloads.sh | 72 ++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100755 tests/py/tools/regen_payloads.sh

diff --git a/tests/py/tools/regen_payloads.sh b/tests/py/tools/regen_payloads.sh
new file mode 100755
index 0000000000000..ed937584d780b
--- /dev/null
+++ b/tests/py/tools/regen_payloads.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+
+# update payload records in an automated fashion, trying to reduce diff sizes
+
+
+# scan payloadfile and print record for cmd (if found)
+find_payload() { # (payloadfile, cmd)
+	local found=false
+
+	readarray -t pl <"$1"
+	for l in "${pl[@]}"; do
+		if [[ "$l" == "# "* ]]; then
+			$found && return
+			[[ "$l" == "$2" ]] && found=true
+		fi
+		$found && echo "$l"
+	done
+	$found || echo "Warning: Command '$2' not found in '$1'" >&2
+}
+
+cd $(dirname $0)/../
+
+# make sure no stray output files get in the way
+rm -f */*.got */*.gotgot
+
+# store payload records for later
+# clear payload files to force regenerating (but leave them in place)
+for pl in */*.payload*; do
+	[[ $pl == *.bak ]] && continue # ignore leftover .bak files
+	cp "$pl" "${pl}.bak"
+	echo >"$pl"
+done
+
+# run the testsuite to create .got files
+# pass -f to keep going despite missing payloads
+./nft-test.py -f
+
+# restore old payload records
+for plbak in */*.bak; do
+	cp "$plbak" "${plbak%.bak}"
+done
+
+# sort created got files to match order in old payload records
+for g in ${@:-*/*.got}; do
+	pl=${g%.got}
+
+	[[ -f $g ]] || continue
+	[[ -f $pl ]] || continue
+
+	readarray -t ploads <"$g"
+	readarray -t cmds <<< $(grep '^# ' $pl)
+	for cmd in "${cmds[@]}"; do
+		found=false
+		for l in "${ploads[@]}"; do
+			if [[ "$l" == "# "* ]]; then
+				$found && break
+				[[ "$l" == "$cmd" ]] && found=true
+			fi
+			$found && echo "$l"
+		done
+		$found || echo "Warning: Command '$cmd' not found in '$g'" >&2
+	done >${g}got
+
+	cp "${g}" "${g}.unsorted"
+	cp "${g}got" "${g}.sorted"
+	mv "${g}got" "${g}"
+done
+
+# overwrite old payload records with new ones
+for got in */*.got; do
+	mv "${got}" "${got%.got}"
+done
-- 
2.33.0

