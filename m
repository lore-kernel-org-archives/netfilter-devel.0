Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6587EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjFVPrI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjFVPrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 11:47:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E061EA
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 08:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nMKYsAtz3+jN6MfD+qnUaE7zeRwmd+mh1krEPprIyOQ=; b=QrPK4G2ebsQeqdZzOwKlv17m2n
        A5vfhwMhVcyLho8VrypUzuZjQZz2niSeeExI7bU9DRG0l/7WX/NMWMZdLgpq9TW8hAF3OKRcNEcxO
        zofcfAEb1w/UtBf7XKffLOKpwHl4dF2FMX5MIvqBOVIXiio8VImYgMDNTKH1Jj6XzZ7y10iWGr2Z7
        mxnXyxVPlU4+wG5AHXLXQKxxVdX76TPBZnlmNQd5Z271PlNEWjbXnDLq6HQD7iGZxUxiSqBSlgUfK
        y7WZH2S+juP4W6E2XKIE8NYCEQ7PTVXgnQ4csqje2ZDoXLknf6qbVqASisBBGTst2XbNAdgFSNOZu
        OhRr5Utw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qCMWW-0001sm-Lt; Thu, 22 Jun 2023 17:47:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] tests: shell: Introduce valgrind mode
Date:   Thu, 22 Jun 2023 17:46:34 +0200
Message-Id: <20230622154634.25862-5-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230622154634.25862-1-phil@nwl.cc>
References: <20230622154634.25862-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass flag '-V' to run-tests.sh to run all 'nft' invocations in valgrind
leak checking environment. Code copied from iptables' shell-testsuite
where it proved to be useful already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/run-tests.sh | 47 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 931bba967b370..1a69987598314 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -69,6 +69,11 @@ if [ "$1" == "-g" ] ; then
 	shift
 fi
 
+if [ "$1" == "-V" ] ; then
+	VALGRIND=y
+	shift
+fi
+
 for arg in "$@"; do
 	SINGLE+=" $arg"
 	VERBOSE=y
@@ -106,6 +111,48 @@ find_tests() {
 	${FIND} ${TESTDIR} -type f -executable | sort
 }
 
+printscript() { # (cmd, tmpd)
+	cat <<EOF
+#!/bin/bash
+
+CMD="$1"
+
+# note: valgrind man page warns about --log-file with --trace-children, the
+# last child executed overwrites previous reports unless %p or %q is used.
+# Since libtool wrapper calls exec but none of the iptables tools do, this is
+# perfect for us as it effectively hides bash-related errors
+
+valgrind --log-file=$2/valgrind.log --trace-children=yes \
+	 --leak-check=full --show-leak-kinds=all \$CMD "\$@"
+RC=\$?
+
+# don't keep uninteresting logs
+if grep -q 'no leaks are possible' $2/valgrind.log; then
+	rm $2/valgrind.log
+else
+	mv $2/valgrind.log $2/valgrind_\$\$.log
+fi
+
+# drop logs for failing commands for now
+[ \$RC -eq 0 ] || rm $2/valgrind_\$\$.log
+
+exit \$RC
+EOF
+}
+
+if [ "$VALGRIND" == "y" ]; then
+	tmpd=$(mktemp -d)
+	chmod 755 $tmpd
+
+	msg_info "writing valgrind logs to $tmpd"
+
+	printscript "$NFT" "$tmpd" >${tmpd}/nft
+	trap "rm ${tmpd}/nft" EXIT
+	chmod a+x ${tmpd}/nft
+
+	NFT="${tmpd}/nft"
+fi
+
 echo ""
 ok=0
 failed=0
-- 
2.40.0

