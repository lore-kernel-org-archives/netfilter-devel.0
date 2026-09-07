Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AC46DFF7;
	Mon,  7 Sep 2026 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801462; cv=none; b=GhU983QCzBmsUFWmDKJ1Y1XHVt9wdRROaVqrCRiw667e6hDcAu1BxL9ierSyq4eNt6I87tKgyPiU+FKUpufvcxVNvDCVu9aZfMGcTW7Wh66B3JcI7+3xa0iY7C13yDu9ZX02ghUCCZbERuba8dU6s7uEgCkkBxhzXbQmIe+hT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801462; c=relaxed/simple;
	bh=p+FbTp4ohMfgcjQLgykJUfntEbCw7hGIefG19R7ed2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZP6NPF3FSormfVXBDLG73CfsetwyUoHhz5f5wIH8xCs2Xq1vX0vlSpNhA3B700WOXXtET7HLixlyaYGNfNSn63CURAa3/mNYYaEQ+Fv39kovkCqPpNHost5SvsBTA1q3BcSfn7qnB9V3gkxn1UZARv7aYW3lj+lrT9g7YtNzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YDogvqGk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YDogvqGk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801458;
	bh=s7yPQSRnQ1hhnkW8YAUymPj6fDL0OZFBNPehDkm5fwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDogvqGkzCBqrAPLZrjyHo1NfDZzmNGTJnJJWEcY568qVdHkZsaG4pxqgcreL0syu
	 0vNVdBddqRhO3AXhcLAqpxA8IEQ+JLCjk7hMmrnlqnkG0zufqC3atPN39Zwhxci1Du
	 Gh7cqhlnpYOxSirAc2+Ez/KziqWh5qO+UoOtulTlIS6dxXmHTFMSmAXb2NtMg3gTfS
	 1pGhYgoKMM3m+yYUk0+PTEOHuJb9G6SjFArRkja39QxXFTVMS4wWcBPQPSaVkT8Sip
	 fvtiijsHGk6ImpltP/Czkys3sHjsnbwiPXftbVCtJtpHwG/ekahPbeDOtryH/96hZI
	 luIOAMYeJA7wA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D30D2607D0;
	Mon,  7 Sep 2026 19:17:37 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 1/9] ipvs: reject invalid states in connection template sync records
Date: Mon,  7 Sep 2026 19:17:24 +0200
Message-ID: <20260907171732.1407739-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

IPVS sync receivers validate protocol states before creating or updating a
connection. For connection templates, however, they only log states outside
the template state range and still store the value in the connection.

A template can be returned by ordinary connection lookup. TCP and SCTP then
use the invalid state as an index into their transition tables.

Reject invalid template states in both sync protocol versions before
looking up or modifying a connection. The version 1 path handles both
IPv4 and IPv6 records.

Fixes: 275411430f89 ("ipvs: add assured state for conn templates")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index ea5fdd4f4ce7..1deb063cd72c 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -999,10 +999,10 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 					pp->name, state);
 				continue;
 			}
-		} else {
-			if (state >= IP_VS_CTPL_S_LAST)
-				IP_VS_DBG(7, "BACKUP v0, Invalid tpl state %u\n",
-					  state);
+		} else if (state >= IP_VS_CTPL_S_LAST) {
+			IP_VS_DBG(7, "BACKUP v0, Invalid tpl state %u\n",
+				  state);
+			continue;
 		}
 
 		ip_vs_conn_fill_param(ipvs, AF_INET, s->protocol,
@@ -1159,10 +1159,10 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 			retc = 40;
 			goto out;
 		}
-	} else {
-		if (state >= IP_VS_CTPL_S_LAST)
-			IP_VS_DBG(7, "BACKUP, Invalid tpl state %u\n",
-				  state);
+	} else if (state >= IP_VS_CTPL_S_LAST) {
+		IP_VS_DBG(7, "BACKUP, Invalid tpl state %u\n", state);
+		retc = 40;
+		goto out;
 	}
 	if (ip_vs_conn_fill_param_sync(ipvs, af, s, &param, pe_data,
 				       pe_data_len, pe_name, pe_name_len)) {
-- 
2.47.3

