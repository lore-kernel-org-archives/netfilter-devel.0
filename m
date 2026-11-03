Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725159;
	b=feb6gOD86Zo0ron1BI2gAMuk8kDtX7I1Piw1wrschtC783iUmoLcPKvo0eM+qR9CaVwX
	 SbfT6Lp0bzyOKh5GKJkNZnxZ37yJ1rp97DSQNRybvsa4zY+bTmNn3GdjYMWZ7TZydqahk
	 Weey3SVkK/BXZVv0cAn0jAeqcMpjVM4airffiUPRFGmt6H4tJxZD4oHZToVNfVOKT/XWz
	 ld7H+oocKjaZ5VYxxXmG3iN3eP1pOWPeWiKXekLr0L5hsE1RxLgqVz/6aY2SPCJPvI85K
	 cNaDAijDVfsLIza1Cgwo3WKoOV6MHc7+vuP9GkdkoZ4JQSRNsqVKCR8wHkrgHf4ec4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyie3lp94voMetIz4ZK0UyMQldPElbkTK8vbvrxDQEs=;
	b=GIZ594Pni4CrJFZAr7PaVHLoplINoNxOKAcyLJuhf+rVfvHem/A3BawaIbE7Up107FMR
	 aTo+nA6oZ+cSXY8EgeGSzevN6oh0cDPojcUhAn/AroH6r3qt3c0XClpZXxGfnVtj3Nx3k
	 y7bCfKpjYGr9PTt6+T0GkozKFCtjO39g/BpjhcII3hl1FPRmtl7uM0AXu0lT02os906+A
	 K6dy37LvpoMMHPcKZ93DbbNPfOCPmlocR66li+mQoRMKbvn2CUSoy6rniF/f9AnTpqsB+
	 xYek+mxTayoDdP20KJCEXlAXWpEwFv0tkaKynE8JAOGxn+L5EgDL7Uw8CkV/3jrkFwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=e2u4H5ji;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA89A606A329
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 16:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA89A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=e2u4H5ji
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-945ae2daa68so112525585a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 08:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1793725158; x=1794329958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qyie3lp94voMetIz4ZK0UyMQldPElbkTK8vbvrxDQEs=;
        b=e2u4H5jiGKGo9r6gEd2se4tGTZwmdU5p9nRdnHtOCSYXWlvFZj83tcGAwxxRpJ9zAV
         Mro8wC0WTq2rpRb1Ji8FduryNwdXihHaxmOaRYFBF1Tw8cmDMDaeaikwpbhBcj0Ovq4t
         1zp7PeTOuJVNUfTKrkm+Y2EsfuDAtAvurwlTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793725158; x=1794329958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qyie3lp94voMetIz4ZK0UyMQldPElbkTK8vbvrxDQEs=;
        b=ayrEXQSm9mbJg9wwOkQ5J7mlZUG2XvdaBAorQLsdwOO7DEL5xS7x5eylIeqB6qRw0t
         Odc8hU3aQHJB1IJS1yzHuvk93ArcxHyNQYdtt5jUa9nbt+c0cb0fdnYPIpztW2foLtiN
         xxoEV9/6L0mASc6wsIqXxH9TGfNWO1JJAYyUTtgYR2kUjZuJaXmP+Q0fdXCHGMcOrZX1
         gDe3YyosXxYznxVfkvroGQkZKpS2ooN2mIGqgp+wPypz4NX69qT/KowwLfF9KfbA5fti
         e8Gs4ul1j38cPBG6C2wZ/HyzSxcSco81XEkUQp5s21Pg2pxapo0WA6H1dWGAgEFv0H71
         RLMA==
X-Forwarded-Encrypted: i=1; AKwUvBy64+7jGfWeRO7KlPLVgCX6xhPjaxp6drv/390oAUFWIwU0IbcuNmhZ7jSVpT4P56JNkXu7K3ow/CQsU231x+4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8/n0oX2vt0gcWZV5UqrAwzfDsnJna7AMJ+4XP3tnSR9aj7p1Fe
	BIj372Ct+LUn7ZX4plTh+yC3Jp9WS7SM3SAiNPFLGQStevng85r0h1W5p4nN7p7F0y0=
X-Gm-Gg: AYBFou0ekROgFMY3WlxHOWcTc35i1bPeGXfMfbZm838o2Sr80GUrGP7xcvWTXNWnj8t
	56rK06MGvqVNDQXoHW0gPXVkz74vF9vvoRUoJV+Oap0Eb1M773ysRF4eDYWZceQbZq+keUZsB6U
	YWe53ciHtOBX3n47yUyS3lzPFlS/+4kDnEcWt7u+wul9Ff+Fkx0orNtE/EEFrnchnxVitbo+TkZ
	abj2xVKElaTYiN2kFlFjoymM9hFmNU2KvwPVTy6E05DPVD6iKQXt3DwcWRljSZlWepBmmmbVehh
	KnQ/NDpOYgVP74rBM7LEDJVFGHtlr6UZx5a/lIAYNpI2ysUg1R08SQnb2aa6SstvdOwend7LqN1
	LvV+sDXGQyN+KAqHUMvJ6wiwdLBYxh53qBJUMT5vjJA1UvQOlX3QyNYUDf9/tUPoHc+JF3JWbV3
	4Aq2sh9YMTFsdIyvbaQoJaRh3U9Aq2jcNHMlEJ5AynwOcL5eOj3RxON6c/HwX6WnTKAkSy4GVbh
	6q+cirOFxAXqUs9wAf1skaeDv5kh9nlPm3QkuLb8t8GC+mjyHgp9t6mJ0JGSLc9nx3afZm3puUJ
	Vn1KnIGkXu3YIEiRvbONdFXbHKtNeN2KMQG8NNeZFBJuIFk4Pds+woM208VP/7gvTeUHnBq9oZu
	dacc2FQ==
X-Received: by 2002:a05:620a:4613:b0:93f:1789:8359 with SMTP id af79cd13be357-944133bf945mr2719600885a.31.1793725157802;
        Tue, 03 Nov 2026 08:59:17 -0800 (PST)
Received: from localhost ([2600:4041:59c3:300:a850:2af1:eb93:4121])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d3410ae4sm5514285a.26.2026.11.03.08.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:59:17 -0800 (PST)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: ja@ssi.bg,
	horms@verge.net.au,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	w@1wt.eu,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v2 1/2] ipvs: validate cport in received sync records
Date: Tue,  3 Nov 2026 11:57:45 -0500
Message-ID: <20261103165746.39516-2-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261103165746.39516-1-axel.mierczuk@1password.com>
References: <20261103165746.39516-1-axel.mierczuk@1password.com>
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

Local templates have cport 0 and IP_VS_CONN_F_NO_CPORT clear, so
ip_vs_conn_in_get() cannot match them. A template received over the
unauthenticated sync protocol with a nonzero cport can reach the
protocol state machine. Before template state validation, this
could cause out-of-bounds reads, crashes and kernel data leaks.

Ordinary records with cport 0 and IP_VS_CONN_F_NO_CPORT clear, or
with a nonzero cport and IP_VS_CONN_F_NO_CPORT set, create connections
that incoming lookups cannot match. The latter also keeps the
cport-zero fallback in ip_vs_conn_in_get() enabled.

Reject all three cases. Continue accepting ordinary connections
with cport 0 and IP_VS_CONN_F_NO_CPORT. The companion patch
"ipvs: filter some flags received in the backup server" rejects
template records carrying IP_VS_CONN_F_NO_CPORT.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_sync.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 157f5c8361ab..a85dc95e29cc 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -853,6 +853,25 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
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
2.50.1 (Apple Git-155)

