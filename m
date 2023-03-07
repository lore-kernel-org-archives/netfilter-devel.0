Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A133C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 13:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCGN6f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCGN6e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 08:58:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9E74DEF
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 05:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1pUtQ/EadlDgYofAqvGmRW9igd8X07bCgLPW4E08blU=; b=KQp+mHPbbGZ8HHd4JkV5/MAKTC
        V7w1gokVZ1Sw6GAj1XA7kf1kj5k0/WH8rRhR1Zq3uPsh3ixJlJkp5qiqIMuIYkISEnbxrzl0mDiBq
        SQ6viXCaskRN80ooghD8tpOfoRKdbBmX0yCIqMAs039mrQVLc1rNU+cWMH2z9shJN4lcthq7wQ8WQ
        9b78btQstgZDDGfWclWKugQk9YjdvKABPciGbTy258vbGCwTbt5oT4nSeHjo/vDb0V8UQIQqQAhS2
        IPAr9H65C5LsrWOErLBNqJpjIGLi10b4rA/UPVHFRGW2I9FaiQU0mvmM67opCFub/zD4roHx4UxHD
        ANeCrTKA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pZXpn-00059C-Bv; Tue, 07 Mar 2023 14:58:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH 3/4] tests: cidr.sh: Add ipcalc fallback
Date:   Tue,  7 Mar 2023 14:58:11 +0100
Message-Id: <20230307135812.25993-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307135812.25993-1-phil@nwl.cc>
References: <20230307135812.25993-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If netmask is not available, ipcalc may be a viable replacement.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/cidr.sh | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tests/cidr.sh b/tests/cidr.sh
index b7d695ae7c0b3..2c4d9399f02dc 100755
--- a/tests/cidr.sh
+++ b/tests/cidr.sh
@@ -37,6 +37,30 @@ NETS="0.0.0.0/1
 
 ipset="../src/ipset"
 
+if which netmask >/dev/null 2>&1; then
+	net_first_addr() {
+		netmask -r $1 | cut -d - -f 1
+	}
+	net_last_addr() {
+		netmask -r $1 | cut -d - -f 2 | cut -d ' ' -f 1
+	}
+elif which ipcalc >/dev/null 2>&1; then
+	net_first_addr() {
+		ipcalc $1 | awk '/^Address:/{print $2}'
+	}
+	net_last_addr() {
+		# Netmask tool prints broadcast address as last one, so
+		# prefer that instead of HostMax. Also fix for /31 and /32
+		# being recognized as special by ipcalc.
+		ipcalc $1 | awk '/^(Hostroute|HostMax):/{out=$2}
+				 /^Broadcast:/{out=$2}
+				 END{print out}'
+	}
+else
+	echo "need either netmask or ipcalc tools"
+	exit 1
+fi
+
 case "$1" in
 net)
     $ipset n test hash:net
@@ -46,9 +70,9 @@ net)
     done <<<"$NETS"
 
     while IFS= read x; do
-    	first=`netmask -r $x | cut -d - -f 1`
+    	first=`net_first_addr $x`
     	$ipset test test $first >/dev/null 2>&1
-    	last=`netmask -r $x | cut -d - -f 2 | cut -d ' ' -f 1`
+    	last=`net_last_addr $x`
     	$ipset test test $last >/dev/null 2>&1
     done <<<"$NETS"
 
@@ -67,9 +91,9 @@ net,port)
 
     n=1
     while IFS= read x; do
-    	first=`netmask -r $x | cut -d - -f 1`
+    	first=`net_first_addr $x`
     	$ipset test test $first,$n >/dev/null 2>&1
-    	last=`netmask -r $x | cut -d - -f 2 | cut -d ' ' -f 1`
+    	last=`net_last_addr $x`
     	$ipset test test $last,$n >/dev/null 2>&1
     	n=$((n+1))
     done <<<"$NETS"
-- 
2.38.0

