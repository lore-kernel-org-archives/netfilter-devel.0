Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA761C072A0
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Nov 2023 19:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbjKJTlR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346463AbjKJTkn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2023 14:40:43 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D684F83FA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 23:24:11 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-359c1f42680so6381955ab.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Nov 2023 23:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699601051; x=1700205851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rjB1X3SXMF68OO7aTDUNgdvpcOuk8kYVyLhwIBgU6Lk=;
        b=PJUCtqhG1P1UGsbZOdaK7/iOhrHHhfbMVCs5gh6X42xkR3auvKx+AxF32rbXq3qmCh
         NAwfp3fJPLa9vGyMVNC4EXnCluxh3wPDk7Mp841LPB5totJff7kDcjSdcJibFQYEyvv1
         Rmw9LlabuM0pCPVZ5HuGPNP/xXL+Xcue4dqMmoZvHewxDi8gwCQSoZZ8LinPsqLPM8lF
         nCrgrS2eCsrU2vWfAGNXl4wPCrmxxdS32Cpd7Vl24ZKzUolFXif37FK1cZVQeJohckTh
         ak0iRJ67m5mM+dz1C8W+ozl1seouGJESUtu5NMkDPTOx/WnVUl2+CUIeoNg7IT8VUnws
         dgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699601051; x=1700205851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjB1X3SXMF68OO7aTDUNgdvpcOuk8kYVyLhwIBgU6Lk=;
        b=krfGGpiDZd4Ah15T2g+hanyVceKlBjEX686+RZNhmsHbROc2ReDaacE0f69hXEMlDv
         nbBgf0qy0S56ZsDn5W0Fy4JEhyga4zbggu0jmgM+iIlOzw+xXYlrVjFgaCooQoDjlVTh
         rOkDvQsYFCQRxpmvBwINMikDJm35JCVVRkoqOiBEy5akYcHEMaTVh/tJS0XgVnbjLXoO
         l/z3cuuGCHgxLzLBgeaOFKOHmRoty7dhxmHBeNXGnWXbuQ8rkFDDoWHRFX4apXO8YVTo
         jZ4GH7NCm1ztQyqoMtezQvDLuFHdc2MieNvRksqFmj3GY1/Xl/Gdbq0cBCiifrxaL5Fa
         ViFg==
X-Gm-Message-State: AOJu0Yw6wyk9ekgmxKZgXljznBZ6JfRzwbfYnclR0JrUxxX8P2BySepa
        kEo12wblN1yKqSkhg2lkuXA8Fe9sS5c=
X-Google-Smtp-Source: AGHT+IEzJARCELNUQsS5eNZ0nvP/JItD5fQtuDJPg8izvH+GM20kNC2ZpeogT9ddOHi9EQhq2fSSZQ==
X-Received: by 2002:a17:903:1103:b0:1ca:d778:a9ce with SMTP id n3-20020a170903110300b001cad778a9cemr8537490plh.38.1699589769642;
        Thu, 09 Nov 2023 20:16:09 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id a3-20020a1709027d8300b001c62e3e1286sm4316219plm.166.2023.11.09.20.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 20:16:09 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] utils: Add example of setting socket buffer size
Date:   Fri, 10 Nov 2023 15:16:04 +1100
Message-Id: <20231110041604.11564-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The libnetfilter_queue main HTML page mentions nfnl_rcvbufsiz() so the new
libmnl-only libnetfilter_queue will have to support it.

The added call acts as a demo and a test case.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 utils/nfqnl_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 682f3d7..6d2305e 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -91,6 +91,7 @@ int main(int argc, char **argv)
 	int fd;
 	int rv;
 	uint32_t queue = 0;
+	uint32_t ret;
 	char buf[4096] __attribute__ ((aligned));
 
 	if (argc == 2) {
@@ -107,6 +108,10 @@ int main(int argc, char **argv)
 		fprintf(stderr, "error during nfq_open()\n");
 		exit(1);
 	}
+	printf("setting socket buffer size to 2MB\n");
+	ret = nfnl_rcvbufsiz(nfq_nfnlh(h), 1024 * 1024);
+	printf("Read buffer set to 0x%x bytes (%gMB)\n", ret,
+	       ret / 1024.0 / 1024);
 
 	printf("unbinding existing nf_queue handler for AF_INET (if any)\n");
 	if (nfq_unbind_pf(h, AF_INET) < 0) {
-- 
2.35.8

