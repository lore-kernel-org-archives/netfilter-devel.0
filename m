Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918E3358D9
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2026 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771330611; cv=none; b=EECz/iO37ct9L1zksui4fxTNZ4wrW0f8ayddaUAynUOQXY5t+m4WOacS3r2ke0ckdwUUy9GNlHtcU8dLCUczwNwgfmQ1pmk0HQ2L0CcwK2NCsuu48lF1H6ljiIrY+fmQyDoBcJbbf24aY4IfLdEABucPrV0Il7kcCTu+CqJByx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771330611; c=relaxed/simple;
	bh=5IUOI+GdtYbqqt1hDN8PkLCp9ZIEhC7SZGm9CzRP6ww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kVL8Iwie4452Jb7Pp53ZVDd0ZgOYXS1323c8MiMKCmvsui+41FDb02GaVkxbAtx5knbdGYsvB7hsIaiBK1OMzpxx32kXN6qtlWWmlVb9VN69FbKmSuRRmHvOIM0riHxBVbFmlmRGlxNWWH/ILfBFjVU9M9So2rnfu3CCefGumjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TeN9iB3w; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TeN9iB3w"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ab39b111b9so17935285ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2026 04:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771330610; x=1771935410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oAiOkzjJS9iAgqAV01DIUVkGS9wp9fVwp/L/ZMMWkl0=;
        b=TeN9iB3wwH3UDniSM6WbMZEH6zxqmtVNnvdAfXmAzCdhgJ5zY9bAOIQsqUQt5W2ue8
         lHji+7ThTqIIf+Lbe4zbkVsJOVvZW4oh4FUO73O09D7lBflrtPXn8TzWDP6p7EGJ5xXl
         1ViX7Jd0CtdsOiojVBhPYgjt57mIeyaET40SbLQiTM/aOFuQbwJBOnkMlO89hfoR5/Yc
         3qtdlrmznQKWP4ayI43Yj6rJv+aE/vYPGcNTKY8UndN+GXnY75pGmoBunqIKSMmLyyvP
         PrbVmiowRQILPsR7bVIme6fVojXypqKOUrQxu+2H5KDxhFXCIyfGWUExTENAK9NIWBCu
         Dhkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771330610; x=1771935410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAiOkzjJS9iAgqAV01DIUVkGS9wp9fVwp/L/ZMMWkl0=;
        b=c68OfVxswE9el0Hni+54FDCQGJjNeTnStLbMLHkk4NBNbUdEferSGlElWM3sLLD6tB
         bABrEA3PQBw4lmNIuDZlueLCcDI34nN0S3OY8NB0p7rprIximCUq59d2EyFXsaxaPFAR
         6cT8BLiNRK6F9t+DySN7bhjCGIdBJyq2CGbmYJvfGz2ssETqfOnbnOcH1aAA/zK/dUDZ
         Ym7Zl0mCP5KY2gtUqEUm9i243UF1FbiJbfmUL9I8dXu27dntfi/9y1TnEXxb0E/KcaYK
         7p9A0D1yIE6JPFPVjay1UxUZHm452rDOD+mCtJgmSWgcLI2shVS6p9syuIySyEVROn+Q
         RsFA==
X-Gm-Message-State: AOJu0Yy++4ho0n9qzsAI/XeGromVpbrg0VekbsVKu6N2ksd0uSEaDP9z
	jQtnX0KkkqidjshAB6RiKPDr4V+3KDmRxqD2G7s9lKdsBeXRJjXWNUaSOnJtcQ==
X-Gm-Gg: AZuq6aII07OV46c3oZaEZUJfrwwB9ZCbr57BJIWimwhs83daz84EFuk9+TIFaonALSQ
	ISwGPqMbuCstrvhsHUW6L4ZVVTieyqhIElfHS//Fq0QRu7ljXsY0OjiN58h6wY2iTD9UypM3cVn
	nWfh5dguKBoFg2s4zEBHgUUwsXEgxTjWNuZYulka2W72VxLWgQVbz4mEy9f8w26MJfVU8bTmgNQ
	mgqr0jtxP3gREK3oKGFyjTPKdG2BHnGDwGNp0x6XKFSpZiWO1mLCb2PEO79Q4ns8MNI31yN66tu
	yze7oXw5YZ3xnM48iheimchC7zDlXeUUthm+D4IAVqGhsM1PaWZPZN0PCQGJ/orNti9mmuQ51TW
	Zm7P1HC871i04unnC3xQUn+rNH/qKG9CU2URZmC7KY0Ayoq2vd00LGNGLYfVWRAbP4sUbyunBwm
	iHXE7BREiGoA1k3Pw7EJtxnAFlJQyEym7P
X-Received: by 2002:a17:902:e949:b0:2aa:d287:6949 with SMTP id d9443c01a7336-2ad1740bcb5mr116348825ad.5.1771330609634;
        Tue, 17 Feb 2026 04:16:49 -0800 (PST)
Received: from localhost.localdomain ([112.145.86.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d595fsm94123945ad.43.2026.02.17.04.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 04:16:49 -0800 (PST)
From: Inseo An <y0un9sa@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	stable@vger.kernel.org,
	Inseo An <y0un9sa@gmail.com>
Subject: [PATCH] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Tue, 17 Feb 2026 21:14:40 +0900
Message-Id: <20260217121440.3210432-1-y0un9sa@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_tables_addchain() publishes the chain to table->chains via
list_add_tail_rcu() (in nft_chain_add()) before registering hooks.
If nf_tables_register_hook() then fails, the error path calls
nft_chain_del() (list_del_rcu()) followed by nf_tables_chain_destroy()
with no RCU grace period in between.

This creates two use-after-free conditions:

 1) Control-plane: nf_tables_dump_chains() traverses table->chains
    under rcu_read_lock(). A concurrent dump can still be walking
    the chain when the error path frees it.

 2) Packet path: for NFPROTO_INET, nf_register_net_hook() briefly
    installs the IPv4 hook before IPv6 registration fails.  Packets
    entering nft_do_chain() via the transient IPv4 hook can still be
    dereferencing chain->blob_gen_X when the error path frees the
    chain.

Add synchronize_rcu() between nft_chain_del() and the chain destroy
so that all RCU readers -- both dump threads and in-flight packet
evaluation -- have finished before the chain is freed.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Cc: stable@vger.kernel.org
Signed-off-by: Inseo An <y0un9sa@gmail.com>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b278f493cc93c..1aa8ee4a79831 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2510,6 +2510,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,

 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
--
2.34.1
