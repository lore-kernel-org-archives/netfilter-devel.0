Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B2EC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7CE32086D
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfCBSfO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:14 -0500
Received: from mail.us.es ([193.147.175.20]:35764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbfCBSfN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A66DD1361AE
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C232DA86C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81418DA856; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30DFEDA844;
        Sat,  2 Mar 2019 19:35:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D78554265A2F;
        Sat,  2 Mar 2019 19:35:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/29] netfilter: nf_conntrack_amanda: add support for STATE streams
Date:   Sat,  2 Mar 2019 19:34:30 +0100
Message-Id: <20190302183457.3079-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Tham <tham@fidion.de>

The Amanda CONNECT command has been updated to establish an optional
fourth connection [0]. Previously, a CONNECT command would look like:

    CONNECT DATA port0 MESG port1 INDEX port2

nf_conntrack_amanda analyses the CONNECT command string in order to
learn the port numbers of the related DATA, MESG and INDEX streams. As
of amanda v3.4, the CONNECT command can advertise an additional port:

    CONNECT DATA port0 MESG port1 INDEX port2 STATE port3

The new STATE stream is not handled, thus the connection on the STATE
port cannot be established.

The patch adds support for STATE streams to the amanda conntrack helper.

I tested with max_expected = 3, leaving the other patch hunks
unmodified. Amanda reports "connection refused" and aborts. After I set
max_expected to 4, the backup completes successfully.

[0] https://github.com/zmanda/amanda/commit/3b8384fc9f2941e2427f44c3aee29f561ed67894#diff-711e502fc81a65182c0954765b42919eR456

Signed-off-by: Florian Tham <tham@fidion.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_amanda.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 20edd589fe06..f2681ec5b5f6 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -54,6 +54,7 @@ enum amanda_strings {
 	SEARCH_DATA,
 	SEARCH_MESG,
 	SEARCH_INDEX,
+	SEARCH_STATE,
 };
 
 static struct {
@@ -81,6 +82,10 @@ static struct {
 		.string = "INDEX ",
 		.len	= 6,
 	},
+	[SEARCH_STATE] = {
+		.string = "STATE ",
+		.len	= 6,
+	},
 };
 
 static int amanda_help(struct sk_buff *skb,
@@ -124,7 +129,7 @@ static int amanda_help(struct sk_buff *skb,
 		goto out;
 	stop += start;
 
-	for (i = SEARCH_DATA; i <= SEARCH_INDEX; i++) {
+	for (i = SEARCH_DATA; i <= SEARCH_STATE; i++) {
 		off = skb_find_text(skb, start, stop, search[i].ts);
 		if (off == UINT_MAX)
 			continue;
@@ -168,7 +173,7 @@ static int amanda_help(struct sk_buff *skb,
 }
 
 static const struct nf_conntrack_expect_policy amanda_exp_policy = {
-	.max_expected		= 3,
+	.max_expected		= 4,
 	.timeout		= 180,
 };
 
-- 
2.11.0


