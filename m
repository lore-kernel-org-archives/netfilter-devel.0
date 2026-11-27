Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738608;
	b=oDAJIaiSrRz3+sTDTQkclZXiy51yG1p85CCRN/IANo7FrGg8UYcAOjcqRQMw1mNZArgp
	 8lZl3ZFb9Rmz3NvvkD33j10ywSOpv7f9S+EnOr8n9655NI5ITPItT7S7T/Kok6qPbsrMh
	 B+tJusCY+VUhpLJVza0abnivRE5i+RJV+UVdmWNxJlvUiktX/VrkHHpGL7ZyE85uddS83
	 ANASAcex/KSiSyv4LcPOqC0JmZNgY+Cqmesf9HT0EP8qI2I+AS6TeNdp/gWmkRf+QvxON
	 Ky4U5n2bmIYheadtr8Zm8VDafQ5O6sq9r1w0xXVl5TAfbGhQMx8noQeKtxFEkYYF+UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DaucjX7EGKxhjPytfA6PE6Q1xmcvizrq4bihC56pvSM=;
	b=PKApgbwDKBTGGymCQhdklywsZ3rCsB2xzu2Bd3U5mEUx9SXtswbNq4f+vrxakqWsnOcA
	 NnTMcHAeyZTL4CM1iYgjRkzoEMHaaYYWWuSJrG79qFE9aFAe4H8aDRpZ0Oq7x2LWRz2jo
	 C6sdPjHj9deuRA0gKtSa82Mk4QjZJDPAjQxaMnvxZ0TgWUN3Sp05LwR3ymt/lbIA+OA9l
	 rkZcG+hN4D3pSAex3PgL7p9LnjAAWi7cynU4ASuZF5HuavjRmf9TGMJbRMTKMT/WOSbK2
	 OI9+12ZMH2ExQE08vagIVmRX7ZHQW0b1lQaF1LWVdagJXyJRMxVlUkvoc4ANdL585yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lwLIWbsQ;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D414606A324
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 00:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D414606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lwLIWbsQ
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso93034795e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 16:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738607; x=1796343407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DaucjX7EGKxhjPytfA6PE6Q1xmcvizrq4bihC56pvSM=;
        b=lwLIWbsQhHcHN3CDna52sVsq9gSO9DJklq6bzGLe3Els2E42gC4pjSTwi8CBXWLj69
         Y6xmDtc6vsito++1VpPJRTsurb0wgyvDhyMIg+LD/l26p52SEGOkBsnM4H/sadwjMOqP
         yqZVtUrGQauUYqpHZDGlRuUHH2sCLzuOyxWAaDjFw2nfdIdTw3taHA64sqf7Z8bP4d13
         8Z/U3f1HmgsK3yj/WRRhDbndUus2MBgUPvB2KPMI6ZVKHsF+COYApylXIc+drZgLM/Bk
         Ed4rW/K8emw3n7dCq2ap1AUGQmklHOyJbD33q+73qeC/NDNq5fnm2CwdYHjz+hEdCPim
         22Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738607; x=1796343407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DaucjX7EGKxhjPytfA6PE6Q1xmcvizrq4bihC56pvSM=;
        b=fZZ7E3hujszS05T6zZqsvyAf8r4n6MFf2cfAgDBXp1a5eZIkfI3TVFjWTFlwlHSMo/
         QmGlcICKBwVnxNkuWQtbBPPfFc1hL+b1FvwdD7I+LGRPd6uVnVJYTEJG2x3QPHB6zUSs
         AmWs/RJMQxtYfDihFD+3WzIPRE2AgB94NlExgROj22vN40Ft/CD4vXjgvawYYXGJxRkO
         MOzH0Nquo8SnoXbG9NYh76bSMHcxX70vtpnDR0sJwp8DUoYdB5i5p82F9ixyn0hxp2NY
         pmMyhbhsFZu0aGUEdDq98iKsEzqNnCSK/uV8gVjGqe7FvSc0l1cR7h59z655+sMKCdBs
         +NVg==
X-Forwarded-Encrypted: i=1; AL+hErHiR5V29d/8uMfMi7X9HN33v/Stj5uOQQhWqBSu00NhG5xd3HxoOXH4IwYsG1HoEdMUnmY+P7OgaZxkiFoH0tY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Q3fC3TtipulXe3mecRtWN0MrIuOr0aHPMvMH+/9c8kpdXWORG
	3RgdkdjM+Sj2tQCstkR0+Nnb77CeZaj1wz63LlVfKiujmWmLFIaffnk=
X-Gm-Gg: AZFdTZfLVG7s95JhsQzUmMgBv3pyfQcu+WkYWfNjYn0Irskap4L9bKWYn+NMncMk5bI
	aPsGkFmPr5d6O/z7cXa4fOrZFp6lNeK2H0Ee78LyhUhLsoBQgYDiyBUkDg7WCDW8F4HJOyptUWe
	uMTM8OLvcO9BVczJRRCrdGHpzxCZmlxGoj34Gh/LSFB4oDoTJzFsDoQcD5H7ZQ41+eguohd9y0z
	2cy/mIVzj0cGeCPLXHThzR53WCUlz54pURHaYNpsR+yiCwEBRfDyM2iGNGyiS5QfszHLCwzmULY
	xbjk68kqnPQ4HGBNEs+/V/8lb28rmBxYcj4vtwjhjJQOtYTLj85s++RP5jA7bLovsPegBrw4/v1
	M/0PG+FE1gNbBvylrU0x+Cm3eaYxzskIy2UPXQRxk4cCRHwExatzidUUQGL3J7kRBmTJkz/crxq
	eN1hiNW26U9bQmSmFB3+TjpiWhnq0UsUsInSKfBX4hLXnjE/p+Sxv/BCRGVe8+c9W/L+nyWOJlD
	LkH79S2EYG8FoytYcvtEcg3Bf0C+qgAdd0lMUGTo810HQhzML4JvkfV3/HMYk//mI5xCMam7rr0
	cYpAv7zBnDITXxs=
X-Received: by 2002:a05:600c:3f0a:b0:4a5:75d2:c104 with SMTP id 5b1f17b1804b1-4bb8880cde7mr439388735e9.22.1795738606729;
        Thu, 26 Nov 2026 16:16:46 -0800 (PST)
Received: from localhost.localdomain ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm356650865e9.3.2026.11.26.16.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:16:46 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Christian Brauner <brauner@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 nf 0/5] netfilter: pin file with get_file_active before reading f_cred
Date: Fri, 27 Nov 2026 00:16:32 +0000
Message-ID: <20261127001637.1026589-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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

From: Tristan Madani <tristan@talencesecurity.com>

Five netfilter callsites read file->f_cred through the
sk->sk_socket->file chain under RCU without pinning the file reference.
Since commit 0ede61d8589c ("file: convert to SLAB_TYPESAFE_BY_RCU"),
the file slab slot can be freed and reallocated within an RCU grace
period, so these readers may observe stale credential data from a
recycled file object.

This series pins the file with get_file_active() before reading f_cred
and releases it with fput() afterwards, matching the pattern used by
the recently merged cls_flow fix (commit 59cf9e6f48e5a).

Changes in v2:
 - Switch from get_file_rcu() to get_file_active() per API change
   (get_file_rcu was removed; get_file_active is the current API)
 - Reference merged cls_flow fix (59cf9e6f48e5a) which uses the
   same pattern for the same bug class

Tristan Madani (5):
  netfilter: xt_owner: pin file with get_file_active before reading
    f_cred
  netfilter: nft_meta: pin file with get_file_active before reading
    f_cred
  netfilter: nfnetlink_log: pin file with get_file_active before reading
    f_cred
  netfilter: nfnetlink_queue: pin file with get_file_active before
    reading f_cred
  netfilter: nf_log_syslog: pin file with get_file_active before reading
    f_cred

 net/netfilter/nf_log_syslog.c   | 28 +++++++++++++-------------
 net/netfilter/nfnetlink_log.c   | 35 ++++++++++++++++-----------------
 net/netfilter/nfnetlink_queue.c | 35 ++++++++++++++++-----------------
 net/netfilter/nft_meta.c        | 16 +++++++--------
 net/netfilter/xt_owner.c        | 27 ++++++++++++++-----------
 5 files changed, 72 insertions(+), 69 deletions(-)

-- 
2.47.3

