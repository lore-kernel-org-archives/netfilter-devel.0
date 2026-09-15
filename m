Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572113AD510
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 22:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789512092; cv=none; b=MI9dgLNk3Quj6Rymdtgs3anbK79JQMIjXpSrE5EXjInPnnY/Ic8q4WYxKRVKTZqaXOlLi6qjQK5VYGMPOT3zWraFE8vUKJVy7Ohox2n5pVh0iAMG5YqzEyirCLs3XobIe9jBIlDWv3WTgfLZ26zSS3v9CbQHgoNVWTR2dqqw7vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789512092; c=relaxed/simple;
	bh=HXRJLUmYpVXaPYu3xm4e2KWCtmr+oTkErwLQssltxUs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tw7KP4isuGhdo8Bi2ERfOwrBW0eB/TlQI+da37legHMVfyVdLsUnlqrMtVad5mfJ7jsYmX4cB/ZdoIRQtOrgoqVLFpwJwSPGtKJNYF+cEWOzUo4zuR5yH0yYgoJNwRGWoaEFsNVbDv5Oa/v/lnyhkwT3rB1Aaar8gjGxQWoHAYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxVTWmOC; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxVTWmOC"
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c7bd056863so114434e0c.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 15:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789512088; x=1790116888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7tWlVXda5b86jyOaJH/zkj7mUpxWfUU7DwT43zc3LkY=;
        b=nxVTWmOCCz8OV2PvOIr9MJfGemyXJ78EeQ0UkcsyKhfv0ZxtNqSS8gpABlmqIqCRsh
         cvGGDuXrCxUc3dYq5VRef8KQ83WLsuZkRL9fmEZ5gf+GONgFKY8up5OzSjzvd8u4OmPk
         9P6rWuod1RGoY6qJCdf7DQIxUGLYC7uQ7/Ldq7jSk0YS2aGjpexUx7aVryNdBpDosukC
         62ecAF8JZtZJzDNVyVEloJBk3fNeqXrsyT9I0HmD96vSvGNRmlFdrNznCI5XmzcY15sa
         ljNGi7pTmemBhdLy66samHVtnJu4DySFGRAZi4DVBLLqB6eyh3NhNqnfGFT+amYx0Den
         Kvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789512088; x=1790116888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7tWlVXda5b86jyOaJH/zkj7mUpxWfUU7DwT43zc3LkY=;
        b=zZpwpgrWJwBS8a9UuKQUgGL4EWytHC7mC4QkLt3uOAeuu9kNUXUYbpsZ1cw1pYrlH9
         63ZWk3KbG5GF+fYBBnNhJe0lkMB2jGhdPXRexXZsqglfPuOlXCIGdJ7NTQAe9nvteOF3
         HlDFA/VBdiy8QTQ9PXVyo9BLfyKQnQSu2AIuHIrRaoM+xv2vMCBX9/dYpsOxmuVGrcVv
         gkALD/uzgQFpK9f6zIQdut83tLoBkco8G9a+GWeFNPyltnA1GyjJyO+yb0FruFJiSfRz
         T3z6XeQ6Wr7R+HdWul8ZUxDkxpLQo/x5fv+PQJQqWQngqmao1HUcF5MHwzgONZtEYBE3
         EObg==
X-Forwarded-Encrypted: i=1; AKwUvBxF1DQ/ScJXsKL2ulZOfkniryez9S6FDHmY+PxsUnOjqHY2J5sSb0WAvP4fLUkmonHSqchlIAdLoSZ+9588O3c=@vger.kernel.org
X-Gm-Message-State: AFuF++mSnVVZlSQy/2OuQxQ7QA974ISTUXZqt31wGr7xskSHnvA4iuE0
	0x/xeASOSvdyofAn5fPqgJNv5fkZH0YMIcgWVX2QkOgjvy4HNBnOFRis
X-Gm-Gg: AYBFou2iv+urbiDFzFJiz4BWyitpalztwEiBITTAeGZKY0aNj9cJhIIT3p/xTkj1mOC
	/lMX+cImiz7fUPYHBfSbILr92UBeNuu7OAibeQH+pwH3OGMtYscQg3Qd+uqQiufHHTtkrlLw050
	2DxrUz2kO1riW7+F0kN/NsBnt5h3/L727kwzw69cFU9dl1FQn90M18oIQ/ByhJKnD+onaBSQ26J
	IIU6fu46+lKOvLrYkhl5bINxZ50U8vybIjiKBWcNZ2FI8Q2saW4yVZ8DFXfzeBVvC2nczRmVsKf
	erLBxbMY3m9bXkT/b5Az7JNuvF5i6l6YgneUA6QCQIZH6aStjseX/ybNMYJ0ZASkg2aJoGDmEeW
	EDslk9ZezInen35KoIZ3kbKYJrMaUqBBaHLu8q5FkqgA6xJ9g824AMJcTugNRdhR5LeLOKMQkzY
	wLmkowDHOgVSsZU0u/F/yvMqHFcl0xJpyMPcxJWZ4z2BxXYPD4PXo73KKUU7S46C4=
X-Received: by 2002:a05:6122:8b10:b0:5c7:f1ba:aa12 with SMTP id 71dfb90a1353d-5c99aea978cmr111500e0c.4.1789512088068;
        Tue, 15 Sep 2026 15:41:28 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9988e5f27sm974975e0c.1.2026.09.15.15.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 15:41:27 -0700 (PDT)
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
Subject: [PATCH v2 0/4] ipvs: add per-service secure_tcp
Date: Tue, 15 Sep 2026 19:41:00 -0300
Message-ID: <20260915224104.639985-1-adrianox@gmail.com>
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

Not sure about patch 4... could be dropped or absorbed into ipvs.sh

Adriano Cordova (4):
  ipvs: add flags for per-service secure TCP state table
  ipvs: stamp per-service secure_tcp on connections
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

