Return-Path: <SRS0=EbRH=2B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE9AC2D0C6
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 16:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BA421556
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 16:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388975AbfLKQKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:10:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47028 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730822AbfLKQKa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 11:10:30 -0500
Received: from localhost ([::1]:60118 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1if4ZI-0000lM-3Y; Wed, 11 Dec 2019 17:10:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Add BUGS section about command line parsing
Date:   Wed, 11 Dec 2019 17:10:20 +0100
Message-Id: <20191211161020.1327-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Illustrate potential pitfalls when entering nft commands on command
line and list possible counter-measures.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index abb9260d3f2f6..d69c2283f52db 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -802,6 +802,32 @@ On success, nft exits with a status of 0. Unspecified errors cause it to exit
 with a status of 1, memory allocation errors with a status of 2, unable to open
 Netlink socket with 3.
 
+BUGS
+-----
+COMMAND LINE PARSING
+~~~~~~~~~~~~~~~~~~~~
+The syntax used in nftables is prone to cause problems when given on command
+line. For instance, *semi-colon* is used in all relevant shells to delimit
+commands.
+
+In some places, *quoted strings* are expected. If not escaped, the shell will
+silently eat them away.
+
+There is also an internal problem regarding *negative priority values* (e.g.,
+when defining base-chains or flowtables): The leading dash catches getopt's
+attention which in turn assumes user specified an unknown option flag. Getopt
+allows to ignore any option-like parameter after the first non-option, but
+that would prevent typical commands like *nft list ruleset -a*.
+
+There are multiple ways to mitigate these issues: Shells can be prevented from
+interpreting special characters by prefixing them with the escape character
+(typically *backslash*), getopt won't recognize options following a parameter
+consisting of *two dashes* alone (which in turn is ignored as well). Probably
+the easiest way to avoid even unforseen issues is to enclose the whole
+nftables syntax in *single quotes*. This turns the multiple non-option words
+on command line into a single argument which is passed to the parser just like
+before but the shell as well as getopt will leave it alone.
+
 SEE ALSO
 --------
 [verse]
-- 
2.24.0

