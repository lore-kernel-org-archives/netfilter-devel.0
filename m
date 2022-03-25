Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E32C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350064AbiCYKvu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348363AbiCYKvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:51:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3A38DA4
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GlqoGqoykS3qNYLQ6tpzDy3wBtoi4C9u1V61H68ZuCs=; b=cdRn60R95xAtsEK6kkQXe/Aq0B
        74N4jvQRHmaDiwovxkSnoZZf6PbStaErBOO0OuSZ4NsyE+3bITEdV/uPQczBf3sAeN4gFf5zQApJK
        CT2uhP8v2izXQQpsdkhLUVvpEZi26iMnRcAg5ctXVAdicr8X0/rX8nUtMlbwt5B/wp3opYC/bcbpR
        8OLwofpfkoYNCSBJIRXLgBn8TeWmRg2AiF1HEpLQ1TjRRM/5ertYlrzt45/UAQLXhhF1XHc3bTbkl
        w00+uMQHQHH8fyRK9oIKN/dukIDC34AaoNbjo7XOYj/RNhAC8t6cVfWasNmYBZhHYoxmlqsAfplq3
        ZI7evY7Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWJ-0007yG-0c; Fri, 25 Mar 2022 11:50:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 4/8] helpers: ftp: Avoid ugly casts
Date:   Fri, 25 Mar 2022 11:49:59 +0100
Message-Id: <20220325105003.26621-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Coverity tool complains about accessing a local variable at non-zero
offset. Avoid this by using a helper union. This should silence the
checker, although the code is still probably not Big Endian-safe.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/helpers/ftp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 29ac55c236507..2b345340a70b9 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -332,23 +332,21 @@ static int nf_nat_ftp_fmt_cmd(enum nf_ct_ftp_type type,
 			      char *buffer, size_t buflen,
 			      uint32_t addr, uint16_t port)
 {
+	union {
+		unsigned char c[4];
+		uint32_t d;
+	} tmp;
+
+	tmp.d = addr;
 	switch (type) {
 	case NF_CT_FTP_PORT:
 	case NF_CT_FTP_PASV:
 		return snprintf(buffer, buflen, "%u,%u,%u,%u,%u,%u",
-				((unsigned char *)&addr)[0],
-				((unsigned char *)&addr)[1],
-				((unsigned char *)&addr)[2],
-				((unsigned char *)&addr)[3],
-				port >> 8,
-				port & 0xFF);
+				tmp.c[0], tmp.c[1], tmp.c[2], tmp.c[3],
+				port >> 8, port & 0xFF);
 	case NF_CT_FTP_EPRT:
 		return snprintf(buffer, buflen, "|1|%u.%u.%u.%u|%u|",
-				((unsigned char *)&addr)[0],
-				((unsigned char *)&addr)[1],
-				((unsigned char *)&addr)[2],
-				((unsigned char *)&addr)[3],
-				port);
+				tmp.c[0], tmp.c[1], tmp.c[2], tmp.c[3], port);
 	case NF_CT_FTP_EPSV:
 		return snprintf(buffer, buflen, "|||%u|", port);
 	}
-- 
2.34.1

