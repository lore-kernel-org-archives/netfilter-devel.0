Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627D14286
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488039; cv=none; b=OI4Hi73ivPG1xErZmgvlvSeuWQnjKQ5OAC6J1lIX1SMXYBddnFKc8f35S/SvwlHvK1dwmmi57hwSWWzSl5jGJeKFw5yEPx8b+AEZNKI7R8fdh8vjk9aIqzBIGkA26gIBDJYQv9+tZJ+W5K+4tEpeZJQ75tQmDmuxNbr8a2cyAbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488039; c=relaxed/simple;
	bh=5g06eFssOiqIQD6KUkTJYmZv3RB+wu16aDY5j45X4V8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jTNK4eG6NqBfXcHZ1iYykR22Jc9Qn44IIs2e4HLJLy9csjYz+Fn8tX6JWLcbFTk/yYJchpNXn2iNQJ5BR6ebAOYMEsKIPqxv9AlAIQaOwxoEvKhwBTtZEId0DJqWnuzfj4MDbc2miY/rmKwGyCiEvO5ct74ySSq4PLFOnUmAwcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HphAz8NI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HphAz8NI"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dc5d0162bcso13268575ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488037; x=1711092837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5YKjdaKx2qi0uOXLNKES0idQ69eOSYvV/iVEjsyb3s=;
        b=HphAz8NIqR5Sc9RfwwB8BcuS+g3F7gJm6e8ednOHTlOeNQXugbV77AoKdBrsP+8iHN
         lu+/JFK5PL3TFFt6GoykYbEvZegL2/j3oPybdnMs5DdkoIDSV84/D2T9Jsn10EgSsZ5W
         APqz32FJct9QDjF8Ap9mlSbjAQXZiSLOAHHPIG5WQz2WR4ugf8ye8o28BLSOXjUkiv7e
         4z7g4seMN6AEzzEdP69AFHD4yHaBqGD5igLrAsZwHu0h9ZiT7qJKZix+MmF2rvRDDRmN
         YmPP6Sx0IDwlmLUyjerHDRziB5InMS7RqkxikwNa/WOm+8ef1tL/cfSld+xFVP5EtzIN
         0Lwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488037; x=1711092837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q5YKjdaKx2qi0uOXLNKES0idQ69eOSYvV/iVEjsyb3s=;
        b=mh05192jFpWwaxbEFU5EDydMc44PgUiRwpKxu5peOsNdlTmSCqLNFosG3aCIYHeAWL
         CQ8WK2BLHexnrocz739h0g7EI3ZPzEQu+yqsRmtkJoXj97t894aKj9s7Jom7OWYOMSYF
         58LNn2Vw0Rv9S0rghCzqdchbCLT1aezCxZ8yFTczRnLntx6OTQVo3aVXnOHeZviforWE
         JS92FdWxh1K46UIcM+JDhEokbbohuBqfVCBq4G0IJry5RPfcDc2rQkgTpngdzpAu1ldJ
         bHC1XRduOOSSRP9NC3+uPW/lDS1+yF5Gv9K91QrdRbNkdXEYiZTntD6TK0ghv4aJFVYv
         e7NA==
X-Gm-Message-State: AOJu0Yw+a5OFRn1sqhu8TOuVq9zWf/hlzxG8tcU5xMtor137ixn/A+6r
	b/GRAJDNm232z38+lvPdHb2qla0Z++h2f7PpPyv/0QQxcNW1qlZiAh5G2gH9
X-Google-Smtp-Source: AGHT+IE7iKGsAQGXTXA/Hjzc1GgJn3Zgvrx39olIBYmyZlhBJlaUwkqP+LsNoDVFvWH0PffnYlhWPg==
X-Received: by 2002:a17:903:2b0f:b0:1dd:9263:c3bd with SMTP id mc15-20020a1709032b0f00b001dd9263c3bdmr2807169plb.12.1710488037654;
        Fri, 15 Mar 2024 00:33:57 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:33:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 03/32] src: Convert nfq_close() to use libmnl
Date: Fri, 15 Mar 2024 18:33:18 +1100
Message-Id: <20240315073347.22628-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 03c56ca..db31446 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -550,12 +550,20 @@ out_free:
 EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
-	int ret;
+	struct nfq_q_handle *qh;
 
-	ret = nfnl_close(h->nfnlh);
-	if (ret == 0)
-		free(h);
-	return ret;
+	mnl_socket_close(h->nl);
+
+	while (h->qh_list) {
+		qh = h->qh_list;
+		h->qh_list = qh->next;
+		free(qh);
+	}
+	free(h->nfnlssh->cb);
+	free(h->nfnlh);
+	free(h);
+
+	return 0;
 }
 
 /**
-- 
2.35.8

