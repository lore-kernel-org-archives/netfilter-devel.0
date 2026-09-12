Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286763321C2
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176760; cv=none; b=OjRYRBuoY/26HrsSdajeaE/ip9QcOp1j/vHQePG5kCp8da3Rhdlt0RSeAxDO4cFBnCZLFKooigSelfmyWv/u0TLCEPo+Do94lRjJq1J4eiYIRPao6agj0a9GZhtb2OvPHbOnaAes4ceXYltRFZECdshahmf/M6bf1q8k45wvPT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176760; c=relaxed/simple;
	bh=iO5IsBdVcKSJKd6NiDoXmZ5UkiJqIiE+p+VNxy8J4R4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PENoZmCREJ23LxDhU6GYKDsNuT0AvqWGnD9BX0p04NuE8mZID0AAuS5bQjbOxA2hezrpY7NuOF95bBUl3gb8LKNL7oz2l2u7q3XYVl4pJZwYL9Dc0hP+7ovIPii7RvDdAurhyfhEJKUuypjai0Qe2OaR0ih1zB3E2qHRXhivkuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xd8xc5/c; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xd8xc5/c"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c7c25d9f6fso1374589e0c.2
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 18:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789176758; x=1789781558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZvfD/NIMhAY/sAhVFEMBC5cGXIs+97HZdpNLEZY0qTk=;
        b=Xd8xc5/cMoVy5cXn0lyTLg6FbvW3KammyCP2h7zw7rH+6Hsa8boFJtHmzWAdJusOqH
         qj6Ry3VEYCYFcA8Udv6Rs1JqimYGLf51n0yxG/iLgN/iMooU0E7MkhJbgZEmn5Bcbmhl
         hH9r18LjCq6W+9UIKzweaDqO4U8MwnrzKaDRnAXxIFxTIcfEJfWZbwOaqUK8xsFkeHdD
         GTPZTDvF48q/8jac7e5g07s3357wSdRLcLki3ymQZgd5NPxr8C5XoQSfKVwIlIcrIWex
         FzHTam4HB/7jLBF+HKmiulHhyHIQu5WYgaNrKcLUTGAurk6XR0QMVDU6G1D1JpytEBaP
         iF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789176758; x=1789781558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZvfD/NIMhAY/sAhVFEMBC5cGXIs+97HZdpNLEZY0qTk=;
        b=InK2Y9BruQr1y4F/wKlNlSf1s6rx3s9ImKCTE6QD2uGDOSmsYIELtmxs0TFIZyp7wW
         9Okha4h1jCoCNUWJimxsaJzqfPgF0o0aJy+auVolBuiqdjxgNCXe9HxgBmPRiUSpn6ZX
         33tqVaj2IwBLeeuV8s00gsnE3+Q3pikDSWdpA1T9BBt7vw7OAW/oxNVQztaEF75Z/V7b
         yruE0odmGqqcVYjG0bwGjm6CxCAzWUrt+NvOXeDJDjVq2OmSC3tOTDx8xONGanSvPjDs
         N7lZLLKq5DVlV6CPKVmFSvKsqFg0IkyIlanrxoMINFwGw21J+cjCRjOL4EIzF/+UgyEt
         6Z1w==
X-Forwarded-Encrypted: i=1; AKwUvBxlqNLzlgnJ4DST4e4C+4e0rNe1keNsDJ4cfiH6pDJR+vb1ZD9gyzcFk8vMaZ54XQImnxxUnTVbohOD9vR9EIY=@vger.kernel.org
X-Gm-Message-State: AFuF++koKzefalAM5taPCwUk3cbD88uENvLTx3lXFt9+PpWha5ejIpIa
	oRFC+Wk0FsMSrEt56MHmo9r0M/Owclhl9Duum9SPGXsWRKXsgT6cv4uc
X-Gm-Gg: AYBFou26zuWX52N84rHRY50yI0JhuRFrvNhEPaLm3OiPNpQLzKOYkyoRRrLSTZB/fFr
	cCY/oknOJdq6iQMpJNbDeNqD5SzrWtOoKCxqBm8gzjMhS+glaDZx4TCfZzRpOB6WnPDAr/b5IRr
	MbNhO9DF9Gm5IHuedz++2mALkIVROInBn6usEzM0ylFnpY06gU18za3af48tH8d00KRZsPpg79O
	o8ZUSI4nF/QIDFdAqeiy4JJ6y5rJ//uZVxepBl0aRVsE4vraEVUI5sjREmm9JyprVPRzFy8KzIj
	toaY1jB+tk3CPyaligX37GKSXp+MI9dwJ0svpRBLkF3STKF6cuNFzJYVNKRgL+EaBZp1HJe1Zlf
	jDsHZnqDLYM/Z3JjP36SBDJggCs1vSydEOt7d0GU78zOU9vLa43nEaj+yMmHbxGInurRwYnGzZa
	Vct6DoFYH2PkOsPgEZZ3kHsKYWiMcdz5bT+kfICMwqMqZeqF7z9QWDIStQLJbTtIndr4sLdDfQA
	7A=
X-Received: by 2002:a05:6122:1c8e:b0:5c7:9445:f468 with SMTP id 71dfb90a1353d-5c8462bff30mr10202112e0c.6.1789176757830;
        Fri, 11 Sep 2026 18:32:37 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c84714c380sm4738262e0c.15.2026.09.11.18.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 18:32:37 -0700 (PDT)
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
Subject: [PATCH 0/4] ipvs: add per-service secure_tcp
Date: Fri, 11 Sep 2026 22:32:12 -0300
Message-ID: <20260912013216.588300-1-adrianox@gmail.com>
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

The flag is part of BACKUP_MASK, so it is preserved on sync to backups.

  1. uapi: define the per-service secure_tcp flags
  2. carry the flag on every connection-creation path (scheduler,
     persistence, RS-initiated, cache-bypass) and on FTP data channels
  3. honor it in the TCP state machine, resolving the stale FIXME
  4. kselftest contrasting a secure vs. a plain service.

Not sure about patch 4... could be dropped or absorbed into ipvs.sh

Adriano Cordova (4):
  ipvs: add flags for per-service secure TCP state table
  ipvs: stamp per-service secure_tcp on new connections
  ipvs: tcp: enable per-connection secure_tcp in state machine
  selftests: netfilter: ipvs: add per-service secure_tcp test

 include/uapi/linux/ip_vs.h                    |   5 +-
 net/netfilter/ipvs/ip_vs_core.c               |  23 +-
 net/netfilter/ipvs/ip_vs_ftp.c                |   8 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c          |  16 +-
 .../testing/selftests/net/netfilter/Makefile  |   6 +
 .../selftests/net/netfilter/gen_tcp_probe.c   | 127 +++++++
 .../net/netfilter/ipvs_secure_tcp.sh          | 158 +++++++++
 .../net/netfilter/ipvs_secure_tcp_mln.c       | 310 ++++++++++++++++++
 8 files changed, 638 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/gen_tcp_probe.c
 create mode 100755 tools/testing/selftests/net/netfilter/ipvs_secure_tcp.sh
 create mode 100644 tools/testing/selftests/net/netfilter/ipvs_secure_tcp_mln.c

-- 
2.51.0

