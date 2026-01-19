Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF12F352953
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 09:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768814196; cv=none; b=py5uxeg/p0fWi2YdmqLwwYlHXfBsuPL6qhjPw5QkPaW9F3Vrj0pWTbFoZeB3wVth2UBQcdU5QPRdAwI4XOiKIZHk0wZ0An6l2ibzH1iEodm5n4yYywxFTzxW1unu2Itq4kp9DSjH1BXwIXryQsqf27kUEgOsSKoacG5+kz1tXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768814196; c=relaxed/simple;
	bh=q23gHidx8498gkMO0yerRKpzSoSAJw6ifeIuU1lw1IA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NnwggKJuU0v6vjH7eHzSjm/m7A1drQo4RYoLdC81Ikwz4DzQzRif+WdxvlhVcNQfp/wcA8+jH3vKuL3gbcagLqiUbvbFIopR//o+tyMbIKV/QQWDgXNPwquk/hgwCHd358QKCtg3PRRMS6ysIDBpWqgTnIj3Zc5nFcTCtWtwXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+8dSBwM; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+8dSBwM"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12339e2e2c1so2408765c88.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 01:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768814194; x=1769418994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uIo8Sy0N2c9CqC2cXQ6iQPPYdQiGFGtp7sbsHVq8k5c=;
        b=P+8dSBwM1TRHVF4dPEWQ1x2i9wRqLgau5eb8doAJRcbFaANnLVUowArPtN+t5cnxFT
         Zca2U6Ru3UkCLqrrcbQXCSQU+SJeYH47y70IRTMFtBbcMVyRoDvMN5aL1HXoK/UwZb21
         icc1jgLRtNeZYQDonilf036vPc2bHLV6VlildpPUn/65r6TLqRWCEZjJaqvRI2sXjibP
         AqYjrCbLRMcAH5q1Im65ywRv63On0sgIpnKkTC8f5BNb3sJY+gX4e6XERZDkIsgXWZGe
         nCF4De1DRtU2RVTsVz4j/8l4p+HoiObklic0pmgR7aCbSPosNVaKHcHBE/ysM8iSdhpl
         x9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768814194; x=1769418994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIo8Sy0N2c9CqC2cXQ6iQPPYdQiGFGtp7sbsHVq8k5c=;
        b=YdAywIcVp9zIzybqoclJpgsr2u+YLsDwWFlzaU/ehHJm+CLYEXbUln8uju3sLDjuSX
         3f45orO4vvI60ni8mewGhs7v/B5H2ycrdRaMRErvmSqGyoJgFpuOWEAOk/vSJjf90Uz0
         ZQowjINe9Ih0fh/a4j5k9NiAhu5B0qJJjZJf6uFgTP1AVuXSnQzTIuhbClT+pGGb926A
         pIk7AZIUEt/CsiR1cg2KBoCjRYdMUV+QVQ5XmGxRUYROmk0kijx9mkz7r//c9s4L9ZVR
         i6JqAycS4pHRiF2emsZZiZ9JjVh6hdkdz+XNiybz3TAxn4eZSw/hMU13aByFxTsFMiDb
         nAwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD/1H63e2pxzf/bmlyraJJyShosHDdm4pO+O4UE55EGYW8FNa6g9XYnMgdCR/zug5bSfHeTV+5ZV7yKT66paM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkbAlGuBm3lbuQzE+kFEoitdQiXSSDFzL7W3cTWhFJa5rITJ1m
	sR9J94jbpbwYlf/GJ9MkPEgLy5FOTVdjlDLQMmvpLX+BU/rh7VqePokE
X-Gm-Gg: AY/fxX4JV1qBfywnISZi6q8eYtT4NQozAX3D0g4nQSZ2f3GOgcd3qm4dFjRDmkuA8h1
	APidV3WPqNbhoqwmr5QdZUtsGC6C7+NKgneOVHCAP/YBkNLYC0Zf9Ke7fcaeIMjHWUs9INklPO/
	CbAn3ffPHgV3etcu/LP1RlBGKWbCzzqdyvtzX6SLjGNQrX6EVt/6jDfNWcudvxf1B7kAulz4IsV
	FKAs+W9tghVXqXf9NtimVtrssVPxYxVnktil4p10Pj+ULjQ1P6BvyYiR5KnLuNCN7+ZmiReQHuc
	lBNe0umbW5IZZjWhmofo5WlZ3UsguvtipxyFLzPtd9hjnf1WGl/GdzVCGBzPnmJjmIf6CtkaAKW
	oOBR48EaaKQ7/qL5IZ65BJW6r4o6jH4riNX6rAXeplBJAyDfSdcyFofKCD8MbMQcRLURg2jUvE1
	zfak7GyHTCUE69G1urC971Z4JBWwNDzqzlovsaKiziN3lxuq+HNAtI+07Ko0lP2MtcAkIDNKsjS
	Y9seYVthA==
X-Received: by 2002:a05:7022:e98d:b0:11b:3eb7:f9d7 with SMTP id a92af1059eb24-1233d0adc11mr11817904c88.14.1768814193959;
        Mon, 19 Jan 2026 01:16:33 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244aefa7c5sm15578577c88.10.2026.01.19.01.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 01:16:33 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: fw@strlen.de
Cc: pablo@netfilter.org,
	phil@nwl.cc,
	daniel@iogearbox.net,
	ast@kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] netfilter: nf_flow_table_bpf: add prototype for bpf_xdp_flow_lookup()
Date: Mon, 19 Jan 2026 17:16:15 +0800
Message-ID: <20260119091615.1880992-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sparse reports:

  netfilter/nf_flow_table_bpf.c:58:45:
    symbol 'bpf_xdp_flow_lookup' was not declared. Should it be static?

bpf_xdp_flow_lookup() is exported as a __bpf_kfunc and must remain
non-static. Add a forward declaration to provide an explicit prototype
, only to silence the sparse warning.

No functional change intended.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 net/netfilter/nf_flow_table_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_bpf.c b/net/netfilter/nf_flow_table_bpf.c
index 4a5f5195f2d2..a129e0ee5e81 100644
--- a/net/netfilter/nf_flow_table_bpf.c
+++ b/net/netfilter/nf_flow_table_bpf.c
@@ -31,6 +31,9 @@ __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_flow_table BTF");
 
 __bpf_kfunc_start_defs();
+__bpf_kfunc struct flow_offload_tuple_rhash *
+bpf_xdp_flow_lookup(struct xdp_md *ctx, struct bpf_fib_lookup *fib_tuple,
+		    struct bpf_flowtable_opts *opts, u32 opts_len);
 
 static struct flow_offload_tuple_rhash *
 bpf_xdp_flow_tuple_lookup(struct net_device *dev,
-- 
2.43.0

