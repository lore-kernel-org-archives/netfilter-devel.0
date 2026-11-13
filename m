Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532514;
	b=GmmtQC/L1ERJfPhCrEZ5ol/95SFyq9rMzZOrBxrfiAqyFSCPg/YprFUOqt7ZQVFemtNc
	 K0+9YXYUqpw6hbzJeZRVdKzBAhLbCbOgG2Nfri0byezsjTDuUtY1hvahiHlnSarxpxr3a
	 H6ETOBdFuChWYDOqX73KrC3G47+Du65SjxRkc0fuAhyQUZw/NVsYc0GUlNmcKBesFo45B
	 NvbRz1XUR27dxB4L+nCb9iXZi2oKGr/GwhAhkhrGyCWW9IedcmFgyc5Lee1hnRPvHvEku
	 jJmKz8/XG3teda8Jl//ojYquNDtvSBf7ODhpTAtgBJMkNGXo4MXyCX8Xk43QQMJJ9BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532514;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=iy4TGIRj/y0rTfGvhCEsPkvS8/SqmV+ZRLhEWbG+xdk=;
	b=RbibPBATmOkTHfLw3vb2/t1z8amSgyc5U4/CrBE/XDCS4O5v48UARgl17SQ/JCb4HPh0
	 LyvbJrcBa3hTQ0k8qQVdVS5mCYAfMG6jnM2keFU890l1zQwdtH0iN1/Jjly4pLItLlK3v
	 22IQleBF6tbkHHt4SUzdwcFXlN5sjswjnSR4CeQGg05rGuftNIoGYvVYIlY/ro5GT9VAw
	 iNQUer2U8uBHlTjLoYPT9KF8NtEIfZHG+mj1sxH5aGQpMz0Ldv1H1GV47Mmsm6TEiedCH
	 k4LIRvz37qNyhIUyVKJxyaM/KQQKZYPQc1JeBPxcaAe4R5mrYqHUzN/PQ5huTO4ZFqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=g5bDnkPd;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA2B60A2628;
	Fri, 13 Nov 2026 01:15:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EA2B60A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=g5bDnkPd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532512;
	bh=iy4TGIRj/y0rTfGvhCEsPkvS8/SqmV+ZRLhEWbG+xdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5bDnkPdTuqRN6gqffVNGimA1UhWIIU73qZQL32j7q87PjcN5AY3XJGe6nJt8iHmt
	 b91E8p0oPBg+PUMAoFbF3fxZNQ0H3/hVnGlnMEa8VLOmyyInJKrHIH8ij/q2IuPPlo
	 JNikI1A5RdJcOzImjuaGkOZtnDrCC++GBwK2iwW/NtqDqAotRAmcs+bVkaIfOSxG4O
	 vvvqI6NEjHWRNJZdq43UMaLKvRjdVf2gQ3BvILtUCBt1HfZ72Lpi3r7I+FJGrHY/7Y
	 QUf4OTWSISsdHj2EwxUiIJ3ORCYDsLrFas3RQDRWBrNBlYXALtYU8+buyMUFyD9LSw
	 AaFcZxVszo0gg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6E20A6005B;
	Fri, 13 Nov 2026 02:15:11 +0100 (CET)
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
Subject: [PATCH net 11/15] ipvs: validate cport in received sync records
Date: Fri, 13 Nov 2026 02:14:43 +0100
Message-ID: <20261113011447.2357709-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

