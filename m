Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BB3EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjHBCEO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjHBCEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2495310E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IAXi4lyOEP5hr6x7ExXGFYh8egDz79F+h5P0zMt5pgY=; b=J4+uja6JVchGmeOKIbp8ApkbtZ
        jUQCMyZXo7FVcFI5Pb4/b6l6nh+wnE4jRvdavcU3PlIsb7pWuytATFne7MVdlfnKcQQTD04jZZkk9
        J3mRY5PWF+fTI9WSfDwWTVzCHgbBweNnUBBMbyslqLzhiCzD9oHrR0WKtpCTZ5sYbSSQDYQwBmu99
        x/EOsvOARm408SQSbcnhAthpNdgbeTEgOOYjBFsazsur7/+PcPAwPtDiRrwXfaHmOdHqAxFgdr6GO
        je/sEsC+7DyUg7JmUeE9hO4gvqoqgja+62sqepocrmbFdKXscJzo1JKKq3EOGOiv3IuuNDT8vz0PR
        BeFymjAA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Dc-0002oK-LH; Wed, 02 Aug 2023 04:04:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 06/16] man: iptables.8: Trivial font fixes
Date:   Wed,  2 Aug 2023 04:03:50 +0200
Message-Id: <20230802020400.28220-7-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No content changes intended, just type commands in bold and the single
path reference in italics.

Reported-by: debian@helgefjell.de
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables.8.in | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 71a6251d6b00c..5a9cec6c9eb35 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -200,7 +200,7 @@ or
 .TP
 \fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
 Print all rules in the selected chain.  If no chain is selected, all
-chains are printed like iptables-save. Like every other iptables command,
+chains are printed like \fBiptables-save\fP. Like every other iptables command,
 it applies to the specified table (filter is the default).
 .TP
 \fB\-F\fP, \fB\-\-flush\fP [\fIchain\fP]
@@ -242,30 +242,30 @@ The following parameters make up a rule specification (as used in the
 add, delete, insert, replace and append commands).
 .TP
 \fB\-4\fP, \fB\-\-ipv4\fP
-This option has no effect in iptables and iptables-restore.
+This option has no effect in \fBiptables\fP and \fBiptables-restore\fP.
 If a rule using the \fB\-4\fP option is inserted with (and only with)
-ip6tables-restore, it will be silently ignored. Any other uses will throw an
+\fBip6tables-restore\fP, it will be silently ignored. Any other uses will throw an
 error. This option allows IPv4 and IPv6 rules in a single rule file
-for use with both iptables-restore and ip6tables-restore.
+for use with both \fBiptables-restore\fP and \fBip6tables-restore\fP.
 .TP
 \fB\-6\fP, \fB\-\-ipv6\fP
 If a rule using the \fB\-6\fP option is inserted with (and only with)
-iptables-restore, it will be silently ignored. Any other uses will throw an
+\fBiptables-restore\fP, it will be silently ignored. Any other uses will throw an
 error. This option allows IPv4 and IPv6 rules in a single rule file
-for use with both iptables-restore and ip6tables-restore.
-This option has no effect in ip6tables and ip6tables-restore.
+for use with both \fBiptables-restore\fP and \fBip6tables-restore\fP.
+This option has no effect in \fBip6tables\fP and \fBip6tables-restore\fP.
 .TP
 [\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
 \fBicmp\fP, \fBicmpv6\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP, \fBmh\fP or the special keyword "\fBall\fP",
 or it can be a numeric value, representing one of these protocols or a
-different one.  A protocol name from /etc/protocols is also allowed.
+different one.  A protocol name from \fI/etc/protocols\fP is also allowed.
 A "!" argument before the protocol inverts the
 test.  The number zero is equivalent to \fBall\fP. "\fBall\fP"
 will match with all protocols and is taken as default when this
 option is omitted.
-Note that, in ip6tables, IPv6 extension headers except \fBesp\fP are not allowed.
+Note that, in \fBip6tables\fP, IPv6 extension headers except \fBesp\fP are not allowed.
 \fBesp\fP and \fBipv6\-nonext\fP
 can be used with Kernel version 2.6.11 or later.
 The number zero is equivalent to \fBall\fP, which means that you cannot
@@ -281,7 +281,7 @@ be resolved once only, before the rule is submitted to the kernel.
 Please note that specifying any name to be resolved with a remote query such as
 DNS is a really bad idea.
 The \fImask\fP
-can be either an ipv4 network mask (for iptables) or a plain number,
+can be either an ipv4 network mask (for \fBiptables\fP) or a plain number,
 specifying the number of 1's at the left side of the network mask.
 Thus, an iptables mask of \fI24\fP is equivalent to \fI255.255.255.0\fP.
 A "!" argument before the address specification inverts the sense of
@@ -343,7 +343,7 @@ destination ports of such a packet (or ICMP type), such a packet will
 not match any rules which specify them.  When the "!" argument
 precedes the "\-f" flag, the rule will only match head fragments, or
 unfragmented packets. This option is IPv4 specific, it is not available
-in ip6tables.
+in \fBip6tables\fP.
 .TP
 \fB\-c\fP, \fB\-\-set\-counters\fP \fIpackets bytes\fP
 This enables the administrator to initialize the packet and byte
@@ -491,4 +491,4 @@ Man page originally written by Herve Eychenne <rv@wallfire.org>.
 .\" .. and most of all, modest ..
 .SH VERSION
 .PP
-This manual page applies to iptables/ip6tables @PACKAGE_VERSION@.
+This manual page applies to \fBiptables\fP/\fBip6tables\fP @PACKAGE_VERSION@.
-- 
2.40.0

