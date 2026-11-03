Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725154;
	b=bEjuERvGbOtj2w3eIPC1vL0NgYeiBAypSSafO3BNjys5MrpcO7+nAj8wrr7TzuneyMtl
	 Yioe2up7Fm3jEVieLLMq+1nCrgsbkZXsU4fSkJ4etj1c1LJUZG6Qo3H47jSKW/xJ/XJM/
	 6AotebsgcnUPXaIOkCx92SeNFUzI2UP+5O8Lh+o1pBjhFStRBh2pcppsTIvR0gz0vlqAo
	 0yuJvMSacJSrxwZSC01ekq25KKa+13lgJCw0lE08wZ50hSLFihdxsVdoxo0CpVZ6InDMj
	 JNdJ7SUdH8KKk8Uda75tAYx3rWmlDsz5GcAHT4wa+U//sp/a30m0kNbELR208ICcT4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725154;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N2nmgAkk9tKVW9ZZZ6y0Nm3a3F6PCdPuD8mrqugKq5U=;
	b=Xl1ZgXXyT3NeJkmNklD2GevsdfH0kyT8zq/K172KJyGxUN67wiqu/DzRBuUpPWKCkMS4
	 b9o/xfkHa1wNrkj2P/svSz1Kp2G6NRg7IvnAzXxTlyUTB/EWFhcqETh/er2PU2pPMtL4+
	 O+r2Jq99cWc9pqSqPfe37J1cmDOVnU2jGRKR2xXS5UBwNu511ESCWmonN6fyF4vejW3B6
	 J+LWLPbU4ZS7HrZqP5cwoAYkiJOaPyclFHMOgbuLqUCbDLZO3vJ9X4dE9NZ9pMTWqL9CC
	 EBBw8PrCC2eyL2LOwJlcYVdKVsfSRecd3EiviluUoyo9f43SGRvCXYLAB0FqiQfvxqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=Z2SC43w2;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D1F606A32D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 16:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20D1F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=Z2SC43w2
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53397554beaso60090161cf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 08:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1793725152; x=1794329952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2nmgAkk9tKVW9ZZZ6y0Nm3a3F6PCdPuD8mrqugKq5U=;
        b=Z2SC43w2Jegfalwfgu+2q/1oAUA+RXjVC6sKz/YdcFg4UC2x+XgGUs+2ttfIx/923/
         TdyxACU2F8UKQcE2sl3mLgvVVw/hKOoEYrDeQPuRcLkBkRsFm3B2i/KtCPrBTIQNu3tH
         T540yzoo+oQoP7XQHaclkUpQQ1a5vIlF4Pc28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793725152; x=1794329952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2nmgAkk9tKVW9ZZZ6y0Nm3a3F6PCdPuD8mrqugKq5U=;
        b=0XIEDrXvk3r+Jn8GbOqAG9w2onU/FJsCQE09DrDqnj9EK5pZJhmk81TVz781anvZ7D
         jo9zh8KhDDULZ8HdkKwgrC1xu833DqOzYElRd5RDFGO2mPl9ub2t4adUGTt2zZkQ1aKR
         yb58s8OgJwqmE6mzZczUual3MvWT5+S+w/PQpYL1obWVssQnrcfGJ6VcyVruT01ICVct
         gkv60lCbinY2tHG4alrssecyHAKS3hsc7e+S5uRJCm+w15nYtr3xDi81dBKRDMcmBKZA
         ExiOVxy/99pjeWA/C7njJUSGvgnSBt6z3vzIpnga9YU2nSE+2DFY7lNA9EKLg7BwwG9o
         wqnQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwgw5agwlYw4L9q9XDCrTQgkUFTM0R4ojGMrgWeRhwkCHnKjk5dKxefZp1qFqqUv8u+ViIYS9FO90FWVLNbEE=@vger.kernel.org
X-Gm-Message-State: APuU4Z81tDgLxuFKx/su6PGS6el8NZaDmoUyM70Cfd5bdkaoFPsEx10Q
	fg/0bfpxqZWibS4kH+Yy5Mt7K4dQYmaM8uxKcBvVGaS2XZLFNnEzX3adNjRvZOHlc7Y=
X-Gm-Gg: AYBFou2Zq6aFPirGTPHeon8CxBL4STN/qOw/a6gigVKwo2BqIFIVSxBGRtb2d+TIxzT
	X5lxPsC/qjml8hqh29kkA4tQYaxVdsYysfvtBFfA8YapECkfUqlYwpZ+E7Wc10Hhz/ASz1TYVd+
	BdhDCJZXZu3JHA6V+yPf6irzSO17MrtZ6P2XTFMFCUELsdRgGT6YgmdJqAZbXVgiDv9ZZhg7rmH
	+1L/SGIxj3sdd0LIodDfa7R862lWyx7+mR3FvUNVOpcLJYLBDRS4RDLqJahvlKdvrM+0ltf8gbk
	Qk+NQc4g1GaixcwdrrlYVCKKVzS8FZcn/lXcPwW0U1y+BkkcTXTZ4gKggRJxWHAQpHdEqz65tJS
	XVD+yk8j/NVIdxkyfzQO/2GzojsIcie6938cY2cFw1ACPinxlSNtbwhV/5aEl2yfu6m8KlKf02N
	226ADRfdqz5KjBXeyZoAR2JFVvZRLd7hoIoUi3GpBPVgNPK01QVXe6eLtpn9rGrUsFWZtCEamvi
	J8AGeF3qrsQHhoYOXtKeZ0l2mFt7im/PD1zb04zX6icJNDVAPprcVOASQwBVwOhIq8SOElcuZq6
	LR2S69xPj8gB+V+TecScPxcudxgCb2pQItDFvdowKXJ0ixP3G1F1vzu3jDh9769y4mdyZ3d0b8M
	siHJH3A==
X-Received: by 2002:a05:622a:a584:b0:536:6ae9:f581 with SMTP id d75a77b69052e-542b8ad94a8mr237532011cf.67.1793725151850;
        Tue, 03 Nov 2026 08:59:11 -0800 (PST)
Received: from localhost ([2600:4041:59c3:300:a850:2af1:eb93:4121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca95caf90sm118485686d6.30.2026.11.03.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:59:10 -0800 (PST)
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
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH nf v2 0/2] ipvs: keep templates and cport 0 conns away from packet lookups
Date: Tue,  3 Nov 2026 11:57:44 -0500
Message-ID: <20261103165746.39516-1-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
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

A template received over the unauthenticated sync protocol with a
nonzero cport is matched by data packets in ip_vs_conn_in_get() and
the protocol state machine runs on it. Patch 1 rejects sync records
with inconsistent cport and IP_VS_CONN_F_NO_CPORT combinations on
the backup.

Patch 2 applies the cport rule of __ip_vs_conn_in_get() to
ip_vs_conn_out_get(): a lookup for client port 0 matches only
connections flagged IP_VS_CONN_F_NO_CPORT, so templates and cport 0
connections cannot be matched through the out hook, while the
"update or create" lookup in ip_vs_ftp_out() keeps working.

The companion patch "ipvs: filter some flags received in the backup
server" is already applied and rejects template records carrying
IP_VS_CONN_F_NO_CPORT.

Packets with port 0 are handled separately by Julian's patch "ipvs: do
not create conns from packets with port 0".

Changes since v1:
- Patch 1: unchanged, added Acked-by from Julian.
- Patch 2: test p->vport against IP_VS_CONN_F_NO_CPORT instead of
  requiring a nonzero cp->cport. The v1 check made the
  ip_vs_conn_out_get() lookup in ip_vs_ftp_out() always miss, so a
  duplicate data connection was created for every PASV/EPSV reply,
  and it read cp->cport twice. Reported by the Sashiko review and
  Julian. Commit message rewritten.

v1: https://lore.kernel.org/netfilter-devel/20260925141115.16126-1-axel.mierczuk@1password.com/

Axel Mierczuk (2):
  ipvs: validate cport in received sync records
  ipvs: skip cport 0 connections in ip_vs_conn_out_get()

 net/netfilter/ipvs/ip_vs_conn.c |  2 ++
 net/netfilter/ipvs/ip_vs_sync.c | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.50.1 (Apple Git-155)

