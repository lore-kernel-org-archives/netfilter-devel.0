Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F75C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1365D61019
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhG1P45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 11:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbhG1P44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 11:56:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A5EC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 08:56:54 -0700 (PDT)
Received: from localhost ([::1]:38202 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1m8lvQ-0004SS-HJ; Wed, 28 Jul 2021 17:56:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] doc: ebtables-nft.8: Adjust for missing atomic-options
Date:   Wed, 28 Jul 2021 17:56:43 +0200
Message-Id: <20210728155643.31855-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Drop any reference to them (and the environment variable) but list them
in BUGS section hinting at ebtables-save and -restore tools.

Fixes: 1939cbc25e6f5 ("doc: Adjust ebtables man page")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ebtables-nft.8 | 64 ++++++-----------------------------------
 1 file changed, 8 insertions(+), 56 deletions(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 1fa5ad9388cc0..08e9766f2cc74 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -44,12 +44,6 @@ ebtables \- Ethernet bridge frame table administration (nft-based)
 .br
 .BR "ebtables " [ -t " table ] " --init-table
 .br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-commit
-.br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-init
-.br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-save
-.br
 
 .SH DESCRIPTION
 .B ebtables
@@ -149,11 +143,9 @@ a table, the commands apply to the default filter table.
 Only one command may be used on the command line at a time, except when
 the commands
 .BR -L " and " -Z
-are combined, the commands
+are combined or the commands
 .BR -N " and " -P
-are combined, or when
-.B --atomic-file
-is used.
+are combined.
 .TP
 .B "-A, --append"
 Append a rule to the end of the selected chain.
@@ -313,39 +305,6 @@ of the ebtables kernel table.
 .TP
 .B "--init-table"
 Replace the current table data by the initial table data.
-.TP
-.B "--atomic-init"
-Copy the kernel's initial data of the table to the specified
-file. This can be used as the first action, after which rules are added
-to the file. The file can be specified using the
-.B --atomic-file
-command or through the
-.IR EBTABLES_ATOMIC_FILE " environment variable."
-.TP
-.B "--atomic-save"
-Copy the kernel's current data of the table to the specified
-file. This can be used as the first action, after which rules are added
-to the file. The file can be specified using the
-.B --atomic-file
-command or through the
-.IR EBTABLES_ATOMIC_FILE " environment variable."
-.TP
-.B "--atomic-commit"
-Replace the kernel table data with the data contained in the specified
-file. This is a useful command that allows you to load all your rules of a
-certain table into the kernel at once, saving the kernel a lot of precious
-time and allowing atomic updates of the tables. The file which contains
-the table data is constructed by using either the
-.B "--atomic-init"
-or the
-.B "--atomic-save"
-command to generate a starting file. After that, using the
-.B "--atomic-file"
-command when constructing rules or setting the
-.IR EBTABLES_ATOMIC_FILE " environment variable"
-allows you to extend the file and build the complete table before
-committing it to the kernel. This command can be very useful in boot scripts
-to populate the ebtables tables in a fast way.
 .SS MISCELLANOUS COMMANDS
 .TP
 .B "-V, --version"
@@ -371,16 +330,6 @@ a target extension (see
 .BR "TARGET EXTENSIONS" ")"
 or a user-defined chain name.
 .TP
-.B --atomic-file "\fIfile\fP"
-Let the command operate on the specified
-.IR file .
-The data of the table to
-operate on will be extracted from the file and the result of the operation
-will be saved back into the file. If specified, this option should come
-before the command specification. An alternative that should be preferred,
-is setting the
-.IR EBTABLES_ATOMIC_FILE " environment variable."
-.TP
 .B -M, --modprobe "\fIprogram\fP"
 When talking to the kernel, use this
 .I program
@@ -1100,8 +1049,6 @@ arp message and the hardware address length in the arp header is 6 bytes.
 .br
 .SH FILES
 .I /etc/ethertypes
-.SH ENVIRONMENT VARIABLES
-.I EBTABLES_ATOMIC_FILE
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH BUGS
@@ -1109,7 +1056,12 @@ The version of ebtables this man page ships with does not support the
 .B broute
 table. Also there is no support for
 .B string
-match. And finally, this list is probably not complete.
+match. Further, support for atomic-options
+.RB ( --atomic-file ", " --atomic-init ", " --atomic-save ", " --atomic-commit )
+has not been implemented, although
+.BR ebtables-save " and " ebtables-restore
+might replace them entirely given the inherent atomicity of nftables.
+Finally, this list is probably not complete.
 .SH SEE ALSO
 .BR xtables-nft "(8), " iptables "(8), " ip (8)
 .PP
-- 
2.32.0

