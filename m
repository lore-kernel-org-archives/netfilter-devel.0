Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F407C001E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 15:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjHAPPd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 11:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjHAPPc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 11:15:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E661B1
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 08:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cT06ld6xUiThuoJ2eB/Nz8hUVJ/BHpETSfyGZeL36Sw=; b=as2cNPYddIGlzRXNttsOA3NsON
        WHo+qw/vtUy9vgxq1Agewwhqp7CgA2s85cfBFrYDkUzoltG4UeooFalYKEEHnpWR00ByDq7O7P54t
        qiFEnHt4PpSk56502oDUpmYL6U1vNiQpwE8UKL1cSCfodrDatxffgp99JX8HBjwbLdPSHUYuSbvTy
        ukHE4CN/8eMxJ2yCACfXrFuB1Mi3tvjWXcAJPbVdSgY9fuogmO4+Km2xCWUCDIq8Ab3mEKGvemoXj
        oHnx6oY+JELHLtUHdUIXNKR/0kt6dOyRdvrzSaPT0eFLJ3PfiiQMu5qTkGd+46QDgir4K/BxQ8Krp
        nwLjZvOw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qQr5p-0005Tg-VE
        for netfilter-devel@vger.kernel.org; Tue, 01 Aug 2023 17:15:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] iptables-apply: Eliminate shellcheck warnings
Date:   Tue,  1 Aug 2023 17:15:17 +0200
Message-Id: <20230801151517.15280-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230801151517.15280-1-phil@nwl.cc>
References: <20230801151517.15280-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Actual warnings were only about use of '-a' in bracket expressions
(replace by '&&' pipeline) and the immediate evaluation of the variable
in trap command.

The remaining changes silence info-level messages: missing quoting
around variables, pointless '$' in arithmetic expressions, backticks
instead of $(...), missing '-r' parameter when calling read and an
awkward negated '-z' check.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-apply | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/iptables/iptables-apply b/iptables/iptables-apply
index 3a7df5e3cbc1f..c603fb2113ef3 100755
--- a/iptables/iptables-apply
+++ b/iptables/iptables-apply
@@ -141,9 +141,9 @@ for opt in $OPTS; do
 			;;
 		(*)
 			case "${OPT_STATE:-}" in
-				(SET_TIMEOUT) eval TIMEOUT=$opt;;
+				(SET_TIMEOUT) eval TIMEOUT="$opt";;
 				(SET_SAVEFILE)
-					eval SAVEFILE=$opt
+					eval SAVEFILE="$opt"
 					[ -z "$SAVEFILE" ] && SAVEFILE="$DEF_SAVEFILE"
 					;;
 			esac
@@ -163,13 +163,13 @@ done
 
 # Validate parameters
 if [ "$TIMEOUT" -ge 0 ] 2>/dev/null; then
-	TIMEOUT=$(($TIMEOUT))
+	TIMEOUT=$((TIMEOUT))
 else
 	echo "Error: timeout must be a positive number" >&2
 	exit 1
 fi
 
-if [ -n "$SAVEFILE" -a -e "$SAVEFILE" -a ! -w "$SAVEFILE" ]; then
+if [ -n "$SAVEFILE" ] && [ -e "$SAVEFILE" ] && [ ! -w "$SAVEFILE" ]; then
 	echo "Error: savefile not writable: $SAVEFILE" >&2
 	exit 8
 fi
@@ -205,8 +205,8 @@ esac
 ### Begin work
 
 # Store old iptables rules to temporary file
-TMPFILE=`mktemp /tmp/$PROGNAME-XXXXXXXX`
-trap "rm -f $TMPFILE" EXIT HUP INT QUIT ILL TRAP ABRT BUS \
+TMPFILE=$(mktemp "/tmp/$PROGNAME-XXXXXXXX")
+trap 'rm -f $TMPFILE' EXIT HUP INT QUIT ILL TRAP ABRT BUS \
 		      FPE USR1 SEGV USR2 PIPE ALRM TERM
 
 if ! "$SAVE" >"$TMPFILE"; then
@@ -257,13 +257,13 @@ esac
 # Prompt user for confirmation
 echo -n "Can you establish NEW connections to the machine? (y/N) "
 
-read -n1 -t "$TIMEOUT" ret 2>&1 || :
+read -r -n1 -t "$TIMEOUT" ret 2>&1 || :
 case "${ret:-}" in
 	(y*|Y*)
 		# Success
 		echo
 
-		if [ ! -z "$SAVEFILE" ]; then
+		if [ -n "$SAVEFILE" ]; then
 			# Write successfully applied rules to the savefile
 			echo "Writing successfully applied rules to '$SAVEFILE'..."
 			if ! "$SAVE" >"$SAVEFILE"; then
-- 
2.40.0

