Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274AA49B45E
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591840; cv=none; b=B3jYHJ9H07fxyaVMb2iT57JXMWgLHzZpOPTh3CsiECJJPkkj9EVI8jSzxUGfY0w1VBZSJ24xu7gBiusFccPexzKMSs8YAR8P41TcQ1/URKYEyDlHjW1lLLkmrl6HsGWOR8YsWuKl0kFT2Oleq20O1feElwFF0/NF/PW17SjiNIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591840; c=relaxed/simple;
	bh=bEtEzsnXYYFLAJt9P+qU2PoYTGjg6T24CauSUDL8WF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q3TIblnEmP1AAuccxQ6esG2S0Zm2uLGYGFD7f7E46FQ1dYDOtLuY0razehWw0YS+AVz8VPiYBFkQmV4Qk7YstDBUuBRcY/l5Yw4VMjiUD7KWyM18gPfyVjhsAvLMNqEoFn36u4riGM7E1BPYLFGM3O607+uG/6hun+ItwG+FbY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4dVqgsN; arc=none smtp.client-ip=74.125.227.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4dVqgsN"
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-78a7003f9f5so96804137.1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789591824; x=1790196624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Maxm8CxuPA4nCelqWyiYlq1sMsSnvsLzLF802cTMgp4=;
        b=J4dVqgsNyphdYMuxc+UxuXr4kUIVvIpw6daBwE6XAiHytFg/fFRsCR/5cnqZ1vD23L
         Kcu2OcyWhrDhffk6KqUEsMXKjDHp4pt6DF26TVzoaY19VsA3WKn7tJJ6tnlparSo6/5r
         u0e3253zSTU0d1aSj+mWkoIVvTuT3AXoDgKmi1Ecw/iWfZ01nnZGLOWCH0S2HOSr+y/P
         LbBiDeDzrIMoQQZuQQXcgktX8Fk56Jf2Zp0ofNth6q/ZlKmqejOKOLClSMMXHiPxRpIk
         zZokK1rnirR4jBgc2b3311B+NINkzczYtnI+4Y8ufF/LMpn0QXTsRRVQ/jh0O9gJR52P
         IpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789591824; x=1790196624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Maxm8CxuPA4nCelqWyiYlq1sMsSnvsLzLF802cTMgp4=;
        b=LIrObIWyg2KjxQx06hXl9drpAJLsRhRmEYjSSG5z9VkLngji3EG8WRrEILqNWdhib4
         hpgFkoZ4QQwDZ1tpjr9vTyVhOmgEQi+gn8Ajeo1WklFBIgH7z2NT1B4sOxBg1J7J9Hjh
         JM6FELUxhZ207bNGqzF01cA+9b4Vfq5Sd/5ClBQ6TBL2tmQ8XY6axhMuDOLWbSr+27Zl
         aBNTSMpyNsOSxuEgUpf2wdavzrfBnNF4/x5FW7VJvzr6ooufME7Wx2TvoK0zn1dJQ+3N
         EjzecErNfxY7Mu7am24sBxEiRig9MJhMY/aKpzu/rAeyUq9pgrb26tVVTifeX2AZ7zP8
         RZjw==
X-Forwarded-Encrypted: i=1; AKwUvBwCwUpnKt7N9kx1uZ6E68DLwyjCwA4GoI5/cnTtDu6Jz1OcOkWQjIHQjcO14zfiKHgi8/ZKViTYVMUEg4u9BoI=@vger.kernel.org
X-Gm-Message-State: AFuF++nAmwRhwYBfv9c4jECKl0byFm7l3ngUjgySEF4WU7oBKIyASiFk
	hWqqRVxK9BmSlJRC53urK65OU1BYWPu+io8XDgWULcuyfD5PHua/V7ae
X-Gm-Gg: AYBFou3TAXoeFiVN0Zav6hwKDFeTBy/2Npv0QkHWJ80srYInBYRha0NVF6zGktswhhU
	+hZ+oQzlAv/pEPUO/irZGwNSYYUheeZkI65LieA7RQQx5pGAoh1mMdqGOFCtekCdp/c7hYcf9KI
	YZEYgS4IyNLKDARIeW2FrFZ5d/55LPtjo9sRIFDOftwzDjlD55qQ1Tl3Hqc862R2Ah9z2TnpA41
	RZ5sG836oeNk3BiTYGzrKSPrECKcP13DHn/wZGLjzFDLaTje2agOMn8UX0b0Ad0hP0xp/xRyhBs
	oG6cwTqFXaIwvhzIUHykm0GWbHG8zfd8KKHganqdAcNEYBb8CDok0uNmUMAY1zrLfkNX5LCrq/i
	n2yn316k8yBTYpMgHNjo1oGltKhCgdFppulBpg0FgKO/hiF+R5abjPyCn9tDXVg+GLoCmGrA8LQ
	BMY1rAiW79gnLetHm69o3Qz/6iKMgwORXhguzZkiitkH57Q3ZPNnCDA4gZsjAVCu8=
X-Received: by 2002:a05:6102:d88:b0:79f:c4b7:1b20 with SMTP id ada2fe7eead31-7a2024bd8f3mr233309137.10.1789591824134;
        Wed, 16 Sep 2026 13:50:24 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9832354a8aasm947799241.10.2026.09.16.13.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:50:23 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>
Subject: [PATCH v3 nf-next 0/3] ipvs: add per-service secure_tcp
Date: Wed, 16 Sep 2026 17:50:01 -0300
Message-ID: <20260916205004.647194-1-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IPVS currently exposes secure_tcp as a per-netns sysctl. It switches the
TCP state machine to the hardened tcp_states_dos table.

These patches make it per-service: a virtual service can set
IP_VS_SVC_F_SECURE_TCP which is passed into IP_VS_CONN_F_SECURE_TCP at
connection creation. set_tcp_state() then selects tcp_states_dos for those
connections with IP_VS_CONN_F_SECURE_TCP set and keeps pd->tcp_state_table
(the netns default, including the nomem floor) otherwise.

  1. uapi: define the per-service secure_tcp flags
  2. stamp the flag in ip_vs_bind_dest() (cache-bypass has no dest)
  3. honor it in the TCP state machine, resolving the stale FIXME
  4. kselftest contrasting a secure vs. a plain service

Changes in v2:
- Let IP_VS_SVC_F_SECURE_TCP be 0x0100, leaving 0x0040/0x0080 for the
  scheduler flags. Let IP_VS_CONN_F_SECURE_TCP be (1 << 17) and no longer
  in IP_VS_CONN_F_BACKUP_MASK.
- Set flag in ip_vs_bind_dest() instead of at every ip_vs_conn_new()
  call site.
- selftest: send probes with TTL=1 instead of an nft drop, and fix
  Sashiko comments.

Changes in v3:
- Merge patch 1/4 and 2/4
- Re-send patches (v2 dropped patches 3/4 and 4/4)

Adriano Cordova (3):
  ipvs: add flags for per-service secure TCP state table
  ipvs: tcp: enable per-connection secure_tcp in state machine
  selftests: netfilter: ipvs: add per-service secure_tcp test

 include/uapi/linux/ip_vs.h                    |   2 +
 net/netfilter/ipvs/ip_vs_conn.c               |   4 +
 net/netfilter/ipvs/ip_vs_core.c               |   3 +
 net/netfilter/ipvs/ip_vs_proto_tcp.c          |  16 +-
 .../testing/selftests/net/netfilter/Makefile  |   6 +
 .../selftests/net/netfilter/gen_tcp_probe.c   | 141 ++++++++
 .../net/netfilter/ipvs_secure_tcp.sh          | 153 +++++++++
 .../net/netfilter/ipvs_secure_tcp_mln.c       | 323 ++++++++++++++++++
 8 files changed, 641 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/gen_tcp_probe.c
 create mode 100755 tools/testing/selftests/net/netfilter/ipvs_secure_tcp.sh
 create mode 100644 tools/testing/selftests/net/netfilter/ipvs_secure_tcp_mln.c

-- 
2.51.0

