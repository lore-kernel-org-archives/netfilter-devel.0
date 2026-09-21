Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F24E020E
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 20:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024235; cv=none; b=ExqmKliHP8SebgBa6YXlfArtsIH3UsH6fUjZkIt1TlBEZGkeazNZD48Ms3s+aIIOfBPxFsVDLJcsAZ1MvJqjCcqGKkAixBLA7mrQpVIk+N7sAUihE1l6yxqBEpsoSHIo3tkTYhqkvmGB+22189ZZ/Ok4sD1twLJF6jG+bK6sqXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024235; c=relaxed/simple;
	bh=QBGnVsKL7XQ6CEv4zCqkLJszS+z3nzpJRHqlJUn7+kk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=joa84PnNL487hy6KkNyoVyNUBpLABZ4hnmZ1JAeksUbW8au2UWz0vLZKpUziKTKlAHZxExfBmzgfPpp4m64zdi03/cARFPfVu+MMbOqBmbeYPcebfGL8Aucd27JVo+JB+as5Z2wu0CKo0WP5vtpwYAJEBZXMn1LLkG/Jxjgt4Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQNCXLC/; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQNCXLC/"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-7aa0603e450so573137137.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790024232; x=1790629032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NlPHnolCKbK4Um4HjBJGTEj15gE2VNMVPjQkwtQhdCo=;
        b=CQNCXLC/Egyi753be36mcjSPM9LAd79jOK4BEkUccMmj3KsKRH3IhRi/czF3th3Uhg
         KBDZfIOBV7QRtr6B8Hl9Uqwqh/Ywbz2mlT+IJopqUdPySv8W65F3JXF79KERT2/uQ3di
         ywfUWsY7T/KF4RG0D6ANDE5HURZlCMmd+vFt7y/fw0xhotOinBMIvRHKupB5qfXPmy9T
         7IwpTHToF/JRai2eibx/7DZr8oN7hUCrF/YnVwmAvoHShx5QlqaiKjoj+c3u365TexuS
         uOEC3fj763Px6K2voyeote4jasJfbal9El+ricZIAu+zuSfu4hHF9lxZKxGMKSap/+2b
         LlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024232; x=1790629032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NlPHnolCKbK4Um4HjBJGTEj15gE2VNMVPjQkwtQhdCo=;
        b=eo+DbMcCx7gihQLM5LBgKaS0MhTvqjWHooeBs2gpks4/JkM8KheiCmLmJ6ue4L6ZnI
         YReTCWMpo9Jlysjj7S6f/yNS+gslxsyvkjK2TBcDEKytt/qbg7S2O2WlTQRQPjxasQe3
         xiWnPpNJ6r3mfxNRPa7pDIf+SzV4NT92RBkBXH9cWutGZkEqu/c7eQkKwOUvEEIqiSS5
         u327pmGoaGZwh/+1vLk4BetJhow3ao3YnAmjyguarsZiceggAn+FGGF2ipPE7TP2QiUD
         g2IpByV9zt0iQUogXipF1jMXCIzLvuk4ycZe8M4awme3G+vQ+ccs/PKj2HUUNwFSUy6I
         +cBA==
X-Forwarded-Encrypted: i=1; AKwUvBxanj2/m8no1zTXbOEdt499PdHydzwFjExok2QmEMUJBzMRgi9eW3Ps4GHNpNVjCUCMuLd1JKOZqHsDx5iR7sM=@vger.kernel.org
X-Gm-Message-State: AFuF++kgOPPS2NqaVFHJa6OYQAoQ55C3Nr+PFK13A4dQJOgGZKtdNPL1
	kjbJUiq9rfex0RYxSbVuObMVKfdi23dmU6751G1UPCjY5Mz3RSbE5Ve0
X-Gm-Gg: AYBFou0qhKPr960GA1sxyzyoNqB0AT7G/HObAlpktRHSuUWyIz4ctTBlFGZmmKFhHNs
	K78lnYyy1OesnURyPJC7EEcgngURUeheL8XwT9204e6eQcsm38TxhwbYwiLfE2j3qnmmOMxGOIq
	LM/MEzmFDxnCxTv+9PEPpX2UNUzlNpK0G6gK83xCu+NbGmZuGXTcXJuYjwe3Oh0cWInqZ95MQn6
	Ku2uEZ94pXzN0bzvqQvqXxYoMNnxVlkFPJpac5l5Lo/g7xcqThpqjJKrLDh3HEJ2a8SCBOZwcWH
	H+bXLYBnY5wUVPk90B/FT6ULo2/Z+uQRrOrIyMAgM/a/jQ3yWfhW8nxhJWAU+Otsk1dF3TC9m8/
	DLt0ZwsLyXO9db/bwCRGRCo+Rcighjn3AbX3VrkPLeCi5m8j+MwvjR4yE34eI0WTr0noz11DFv2
	a5bzokbx5cqLJSw/eYc48YXMqjVHzbXf+P72ATjMZ3mrWO1jCBShUbXPMcthfyNVo=
X-Received: by 2002:a05:6102:5120:b0:7a8:b017:1e3e with SMTP id ada2fe7eead31-7a8b01729b8mr3872343137.21.1790024231821;
        Mon, 21 Sep 2026 13:57:11 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9e591d496sm286884e0c.2.2026.09.21.13.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:57:11 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 nf-next 0/3] ipvs: add per-service secure_tcp
Date: Mon, 21 Sep 2026 17:57:03 -0300
Message-ID: <20260921205706.1055288-1-adrianox@gmail.com>
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

  1. uapi: define the per-service secure_tcp flags and stamp the flag in
     ip_vs_bind_dest() (cache-bypass has no dest)
  2. honor it in the TCP state machine, resolving the stale FIXME, and
     document the new default/opt-in split
  3. kselftest contrasting a secure vs. a plain service

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

Changes in v4:
- selftest: check the return values of setsockopt(IP_HDRINCL), sendto()
  and mnl_socket_bind(), and fail do_add() when IPVS does not reply.
- selftest: fix the remaining Sashiko comments: check inet_pton(),
  initialize fam and the parsed addresses, and verify the flags attribute
  length before copying it.

Changes in v5:
- Document secure_tcp as the netns-wide default and the new per-service
  IP_VS_SVC_F_SECURE_TCP opt-in.
- selftest: reword the changelog to "a bare SYN followed by a bare ACK".
- selftest: skip when the ip_vs or ip_vs_rr module is unavailable.
- selftest: check the probe exit status so that a probe which dies after
  the SYN cannot leave the secure-side SYN_RECV assertion passing.

Adriano Cordova (3):
  ipvs: add flags for per-service secure TCP state table
  ipvs: tcp: enable per-connection secure_tcp in state machine
  selftests: netfilter: ipvs: add per-service secure_tcp test

 Documentation/networking/ipvs-sysctl.rst      |   4 +
 include/uapi/linux/ip_vs.h                    |   2 +
 net/netfilter/ipvs/ip_vs_conn.c               |   4 +
 net/netfilter/ipvs/ip_vs_core.c               |   3 +
 net/netfilter/ipvs/ip_vs_proto_tcp.c          |  16 +-
 .../testing/selftests/net/netfilter/Makefile  |   6 +
 .../selftests/net/netfilter/gen_tcp_probe.c   | 158 ++++++++
 .../net/netfilter/ipvs_secure_tcp.sh          | 169 +++++++++
 .../net/netfilter/ipvs_secure_tcp_mln.c       | 337 ++++++++++++++++++
 9 files changed, 692 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/gen_tcp_probe.c
 create mode 100755 tools/testing/selftests/net/netfilter/ipvs_secure_tcp.sh
 create mode 100644 tools/testing/selftests/net/netfilter/ipvs_secure_tcp_mln.c


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.51.0

