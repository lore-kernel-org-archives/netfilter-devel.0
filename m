Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789866;
	b=Q2UG2mMD36WatbdEdrU1dIDNcLuGFNZRWfDfVWSCKWrofqka0DFCIMTu7D5xsXRmb2GC
	 k5e3IP6L42G8/fiH23cqkamDYsdEAoHIMN/UHuILF7iaKwHtVUMznLJWwJ1m3o/qmsFSu
	 FcoShtrcuY+TSCA15IEb2f1jfeCjDz6N9+65AKh0sVSXWqLigieqtMo1ukZkLBRz5snAr
	 JnUDokpFKWIWmCjjG3nFD5NXWYgwFksidVnF9s9gbDnVI9OpuEFegkNeLzHXVxyHzs/ok
	 V43iLlqrJQsfgf6YDYvZp1Y0xec5MOAntVl78+Rv8nr0MUJiQwDyX1HIBTs3RcLzm4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789866;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=iy4TGIRj/y0rTfGvhCEsPkvS8/SqmV+ZRLhEWbG+xdk=;
	b=uvMWC8Xcrs1eUF1L4jOfwYGJoI3KYN57vg1lZsiTGpEKzzluxqKbtK1J9F8ZT1aiSnOd
	 BUxCov6fR2bbNPJg8O7zlHrXNMqieI0280Y7ubLeFYRa5/PmsOkCSeQS6ruJbbUnPtViA
	 xRgH+l2DF4PwoIbYJCvl5YJAKd2gOCGLlGnXmNfLTJGjoof7XMYZgqHvWfNPoxK0sJRyv
	 //Bcy4A3+ESIYpZ8GjjWhRm93jX0DEgh3K1Ji5jXdlN7RdjkkbOKxnounre614VTezi2h
	 OthillQXQ5lc2hPnJJ8THWvOswKrm7fZRAlrMmh4fF+dTSihjGrTYAgWreZFVw42PKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ph5k8guq;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D066A606A331;
	Mon, 16 Nov 2026 00:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D066A606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ph5k8guq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789864;
	bh=iy4TGIRj/y0rTfGvhCEsPkvS8/SqmV+ZRLhEWbG+xdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ph5k8guq69fFtexYN47y0cHSjpDx2R750FuM9TOqqPuqSWBJhow0E74VPDfaUnYqD
	 fhAQaE+J6Des81uu/7dmsTIEr4VAr4JqaFlHX1TaeH1QHdHoljFAjH2ZhWIIRPkN3f
	 we6HvsTCyFFDyTEpV24DGhLmpUvEDZVFNoAxbiL6G6TkmgXIGJSu0eGZhAMuILP5ui
	 Sw1yX+dTiNvsTKV7mC/WSv48wauXiiQvi4oqGl+dnL/j6I/1iezkwp1/DJ9/HkC3UQ
	 sluKr/9H1Z7TmyXdvht8ZoKcDOEGxH/Heb6NK7keB3sqI4BR/0vWtQxxeG9AFEbJhR
	 UsjBjCuOraNUg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7D1D96005B;
	Mon, 16 Nov 2026 01:44:23 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/11] ipvs: validate cport in received sync records
Date: Mon, 16 Nov 2026 01:44:01 +0100
Message-ID: <20261116004404.2821183-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Axel Mierczuk <axel.mierczuk@1password.com>

Local templates have cport 0 and IP_VS_CONN_F_NO_CPORT clear, so
ip_vs_conn_in_get() cannot match them. A template received over the
unauthenticated sync protocol with a nonzero cport can reach the
protocol state machine. Before template state validation, this
could cause out-of-bounds reads, crashes and kernel data leaks.

Ordinary records with cport 0 and IP_VS_CONN_F_NO_CPORT clear, or
with a nonzero cport and IP_VS_CONN_F_NO_CPORT set, create connections
that incoming lookups cannot match. The latter also keeps the
cport-zero fallback in ip_vs_conn_in_get() enabled.

Reject all three cases. Continue accepting ordinary connections with
cport 0 and IP_VS_CONN_F_NO_CPORT. The companion commit f96e91748f63
("ipvs: filter some flags received in the backup server") rejects
template records carrying IP_VS_CONN_F_NO_CPORT.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index f11c59eca553..7e562e745ab5 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -871,6 +871,25 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 	struct ip_vs_dest *dest;
 	struct ip_vs_conn *cp;
 
+	/* Templates require cport 0. Ordinary connections require
+	 * NO_CPORT exactly when cport is 0.
+	 */
+	if (flags & IP_VS_CONN_F_TEMPLATE) {
+		if (param->cport) {
+			IP_VS_DBG(2, "BACKUP, template with cport dropped\n");
+			kfree(param->pe_data);
+			return;
+		}
+	} else if (!param->cport && !(flags & IP_VS_CONN_F_NO_CPORT)) {
+		IP_VS_DBG(2, "BACKUP, conn without cport dropped\n");
+		kfree(param->pe_data);
+		return;
+	} else if (param->cport && (flags & IP_VS_CONN_F_NO_CPORT)) {
+		IP_VS_DBG(2, "BACKUP, conn with cport and NO_CPORT dropped\n");
+		kfree(param->pe_data);
+		return;
+	}
+
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 		cp = ip_vs_conn_in_get(param);
 		if (cp && ((cp->dport != dport) ||
-- 
2.47.3

