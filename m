Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22A6C55178
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4F3206BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgJ2KN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:13:57 -0400
Received: from correo.us.es ([193.147.175.20]:34668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ2KN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 06:13:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96953EBAC6
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8688CDA78F
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:13:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7BDF5DA78C; Thu, 29 Oct 2020 11:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56819DA84B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:13:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 29 Oct 2020 11:13:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 405DC42EF42B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:13:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrack: allow to flush per family
Date:   Thu, 29 Oct 2020 11:13:44 +0100
Message-Id: <20201029101344.8808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows users to flush IPv4 entries only through:

 conntrack -F -f ipv4

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 66f513b84a2c..6e8363e04c13 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -392,7 +392,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
 /*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
 /*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0},
 /*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
 /*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 /*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
@@ -2828,7 +2828,7 @@ int main(int argc, char *argv[])
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfct_query(cth, NFCT_Q_FLUSH, &family);
+		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &family);
 		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
-- 
2.20.1

