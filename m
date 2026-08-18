Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1E233C19E;
	Tue, 18 Aug 2026 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787083250; cv=none; b=tkxXhy/okhe+ffgeI6NcNdqGZ0zt47qwhGiR1yEFYbBx/36yxUhYu+oVKnD2Q7dmaJv3NHeR2jaIqaq4nXVzWrdKtrq4Yt+sr01dL4PP9ZOPF7rUADWfBBJeIN4sOAKcx2jPGqY4pYPuYT8yMwW29KncR+YLaLGchlntcVENNKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787083250; c=relaxed/simple;
	bh=3JB4Ul6RnauhkZ3bESLwCZHjH6hhBLaQUgj2NNTpug4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HVA1BJ39J1XshgZBxi3xdFsncsHj4zuyXZSQKTGQNkikE/HdsRyqxPQAlAiZo6S89rslTY3P/RkDo8Sum2zSL5wi18QQ0kSSrDNdmICpyQQBzNgZbnNevBBDd4IsJjWS6vNQldXa1p3k9uv+H58NM/1zrBYO9f99xscC/bz7YJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=iTXoPBsK; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="iTXoPBsK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CF7yKTw/RELwvrdqXvhQFeaxVVDHW7oMfWk/EhDZ1vU=; b=iTXoPBsKl10NfFxNoAZkKXP+bW
	0hwQDo3WzJJqhIxO/Sbk7vjxzIAUeYPdmfle8NY0NUVhJexv+u2G9NHVcX6yhOgIW3T/af8sWcDUu
	jcmkfnDlR0JJw42tEFM6YLeIEof6m7R5xiObiqOB6dNaToTsa4OIrabTiF2T9k3360o+MxwAQ0rB5
	WrnaBeAxZ6I68T8Jc0BjON02uUA6vIt4Eae4g/U+AzxRbkPo5BLseIQIt1TaGbk4lebLFu/IlV9Hi
	aydAjJYO1/9mrHMSipX+jz3daS96RCJILFdmeMx0ftonNG0tz3RrOCPgAhy/oC2jlRr1GrF3zqPLw
	we55FoGQ==;
Received: from [151.115.150.205] (port=46976 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wwPzL-0000000GQLT-3d79;
	Tue, 18 Aug 2026 22:00:46 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] netfilter: flowtable: publish HW_DEAD after worker is done
Date: Tue, 18 Aug 2026 20:00:15 +0000
Message-ID: <20260818200014.2218933-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

flow_offload_work_del() sets NF_FLOW_HW_DEAD before the work handler
clears NF_FLOW_HW_PENDING. Once a flow is both HW_DYING and HW_DEAD, a
concurrent garbage collection pass can remove it and schedule it for RCU
freeing.

The offload worker holds neither an RCU read lock nor a reference to the
flow. If it is preempted after publishing HW_DEAD, the RCU callback can
free the flow before the worker resumes and clears HW_PENDING, resulting
in a use-after-free.

Move HW_DEAD publication to the common worker epilogue after the pending
bit is cleared, making it the final flow access by destroy work. Order all
preceding flow accesses before publishing the bit that allows garbage
collection to free the object.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/netfilter/nf_flow_table_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..6757fd89c1f1 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
 	}
 
 	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	if (offload->cmd == FLOW_CLS_DESTROY) {
+		/* Publish after the worker's last flow access. */
+		smp_mb__before_atomic();
+		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	}
+
 	kfree(offload);
 }
 
-- 
2.47.3

