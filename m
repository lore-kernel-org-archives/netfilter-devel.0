Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B390EECAAD2
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 05:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiHZFDz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiHZFDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 01:03:54 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 22:03:51 PDT
Received: from babylon.otherwize.co.uk (babylon.otherwize.co.uk [85.119.82.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF495205D1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2022 22:03:51 -0700 (PDT)
Received: (qmail 24654 invoked from network); 26 Aug 2022 04:57:09 -0000
From:   David Leadbeater <dgl@dgl.cx>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     David Leadbeater <dgl@dgl.cx>
Subject: [PATCH 1/2] netfilter: nf_conntrack_irc: Tighten matching on DCC message
Date:   Fri, 26 Aug 2022 14:56:57 +1000
Message-Id: <20220826045658.100360-1-dgl@dgl.cx>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CTCP messages should only be at the start of an IRC message, not
anywhere within it.

Fixes: 869f37d8 ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: David Leadbeater <dgl@dgl.cx>
---
 net/netfilter/nf_conntrack_irc.c | 34 ++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 1796c456ac98..3b9d6f8ba436 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -157,15 +157,37 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	data = ib_ptr;
 	data_limit = ib_ptr + datalen;
 
-	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
-	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
-	while (data < data_limit - (19 + MINMATCHLEN)) {
-		if (memcmp(data, "\1DCC ", 5)) {
+	/* Skip any whitespace */
+	while (data < data_limit - 10) {
+		if (*data == ' ' || *data == '\r' || *data == '\n')
+			data++;
+		else
+			break;
+	}
+
+	/* strlen("PRIVMSG x ")=10 */
+	if (data < data_limit - 10) {
+		if (strncasecmp("PRIVMSG ", data, 8))
+			goto out;
+		data += 8;
+	}
+
+	/* strlen(" :\1DCC SENT t AAAAAAAA P\1\n")=26
+	 * 7+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=26
+	 */
+	while (data < data_limit - (21 + MINMATCHLEN)) {
+		/* Find first " :", the start of message */
+		if (memcmp(data, " :", 2)) {
 			data++;
 			continue;
 		}
+		data += 2;
+
+		/* then check that place only for the DCC command */
+		if (memcmp(data, "\1DCC ", 5))
+			goto out;
 		data += 5;
-		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
+		/* we have at least (21+MINMATCHLEN)-(2+5) bytes valid data left */
 
 		iph = ip_hdr(skb);
 		pr_debug("DCC found in master %pI4:%u %pI4:%u\n",
@@ -181,7 +203,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			pr_debug("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
-			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
+			 * (21+MINMATCHLEN)-7-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
-- 
2.37.1

