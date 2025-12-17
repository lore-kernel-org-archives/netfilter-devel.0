Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC85D34D4C1
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988883; cv=none; b=PX9gMzad6/1D45ligvrlu88iJkNBg4viZxHlSgeC3yfoFEx8tiEwHoKQVqj0sZGlVM0s2JcBHKLJl7caWHYOb9p/Vd6TSvtSsOOB8WGF1zy+3u2icezsP3fpBL3XCcscHnKT4DqwdXjL9j5rJE1SxftdmR3jmdIEmwFZwtquS14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988883; c=relaxed/simple;
	bh=0v6GiZwQmw10VgYg7XmvF5rjkeue5FWN8L2ipdtQVmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c0KQKCrEqLWmNUsMmjDhoWuY/EEKMuIOXHbGYdNtWYfboQnq98d8SQqjf92PE/IUaFnoNry/Ydj48u+95rhNeL8vajy299aLZHv6aDd/6e9v35qzIItbXlEB9g7P8R6XQn8FPZADydIzjWELWmYPGEs90hfIjn+lb9JrPE5dxgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UbGQDrg+; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UbGQDrg+"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47789cd2083so32819815e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 08:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765988879; x=1766593679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AUIBRQ1EfMgD4rZghNrrxsliWBknI9gTPJQu3bDLcJY=;
        b=UbGQDrg+UUeEvVqqTzNHHL2CAtmr0I9eivMDfiPs4dvksQdkDU/B3/wR9FEybrFdHr
         SgIjdbP6RwhsIXv5PHq85HSnQFzcXVHnTKEStgGDukUaTAYffZ4OOz6dtGN1coTVe9FO
         Nehe2UuFXP6JgfANpbTmZK4g+WlyNCbIMgGcsLes3wNE3khOOdj7mNbWAcWsu+5PjlkQ
         9+URkf7nYwCCb5XIlw3QHFKkzA9OnvR6QP/5eil33+qX9EZRYOuR4wlL5GM+Ay/sqnGv
         Jr4mfbsJdqrdkWD6uyWFIOvjMcABh1LW7b5DWRBxnP5rg6R4V2AHdYMWnYBuIaRN+gLy
         72sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765988879; x=1766593679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUIBRQ1EfMgD4rZghNrrxsliWBknI9gTPJQu3bDLcJY=;
        b=aEFAy5O0Pzz1OwdddRVP9dR9Eq8P9MvGnscEJ5RTOB+kmq3AfJviJe0pagYnOSmnzB
         A44mQtCqQcd+BXNPV8NHkx80B1shjucvqAj/rdOsmxUSdvSnWm7hgA3inRlF4VFnAtAh
         X8/vZzo1Re/tX7MG73K+bWc2fB66gyGVQ+OhEQUQURREqgK+L0N8a0n5MVr1+ZOO6UjK
         xcJ1hkzGHHU26+6M+hLfPsBjRV+ZHUQZF6X1d8cT3W3I6nISIxORrf8LosXD5KQpKY+V
         LqpoDaBzGOnLJCtR+FPPMso3qGzqPmYLdoqhISni6r4q3u/dH1vpzG/qP3wje6TF8l2S
         +BQA==
X-Forwarded-Encrypted: i=1; AJvYcCVJats5k3wUrrTT4BYyn0akVoWG5UQllNi3A0HM50k59kzwM8C3KhVLTaEjbGmKduhwbkicn0+BzsLIRNF8fUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze9Q4fdTq4oahXzrE9+b95WmMnYILKuYVQj4tJvYBSH8xDIEON
	waKuWwJel6m4+E7hq65KsNhmwN7h3ijL1xULdx0X/LoruGaUFLxwbHmTuQH0MxhNnjc=
X-Gm-Gg: AY/fxX5GDnbk5DCCHRZSjEkH/kn/ovAcVCMwT5QvHdVR8qoCEnnnAHHgfk9TiXR6HXM
	SCFYfoLA+iqZKDLnbWPhf2hzOwiob9Oi82jBLr4X3RRu+OQXHFbLtfwupC6qDS0+7/8A8whoKq9
	wHWUKxk07UP/2kAL165wdfnBpgNggr7gMOnhpFQ8Ox+5XeCqQydPG3MuC4ZdGjt4iPhiB3PFJ9r
	KesSxl/oteXc6SWKYb9ybn30qiNB4CirhSmCDS2342Hj5wKXgxF82HKQ0DuFI1Pnmb7DSZ4tgMh
	3Rz5jjGM5G9M5VLk5mKyQqvVBAF9UwtlQy6EfaqMMSHT6MUDu/9UdD/2EJQVAKMlB7h7cRzvEqP
	fs4z170qsRvoz/g1ZCfrZn2LN3q8kElkxeiaODAsuwl9D3s9AooqEPeWA8JdzPTIx8VPot1bfTv
	9OsXlZL6IFHLtXTspF+D3cxoD8bRM6o5c=
X-Google-Smtp-Source: AGHT+IHGmMOUEefQoO5S3en43Zsul1QO3grq/W53kRWnWoSN5JrVJ1XTvQBX4MbJYn1xXsNPaQdx7A==
X-Received: by 2002:a05:600c:5298:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-47bdf5f0e9dmr21345875e9.21.1765988879254;
        Wed, 17 Dec 2025 08:27:59 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adeee0esm5728364f8f.29.2025.12.17.08.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 08:27:58 -0800 (PST)
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To: linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Hao Luo <haoluo@google.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Phil Sutter <phil@nwl.cc>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	KP Singh <kpsingh@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Jiri Olsa <jolsa@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Song Liu <song@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Simon Horman <horms@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/4] Use __counted_by for ancestor arrays
Date: Wed, 17 Dec 2025 17:27:32 +0100
Message-ID: <20251217162744.352391-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The trick with utilizing space in cgroup_root for cgroup::ancetors flex
array was an obstacle for kernel reworks for
-Wflex-array-member-not-at-end.

The first patch fixes that, then I wanted to utilize __counted_by for
this flex array which required some more rework how cgroup level is
evaluated.

Similar flex array is also in struct ioc_gq where it was tempting to
simply use __counted_by(level), however, this would be off-by-one as it
has semantics like cgroup's level (0 == root).
Proper adjustment for __counted_by() would either need similar
level/ancestor helpers or abstracted macros for ancestors up/down
iterations.

I only made a simple comment fixup since I'm not sure about benefit of
__counted_by for structs that aren't sized based on direct user input.

Michal Koutný (4):
  cgroup: Eliminate cgrp_ancestor_storage in cgroup_root
  cgroup: Introduce cgroup_level() helper
  cgroup: Use __counted_by for cgroup::ancestors
  blk-iocost: Correct comment ioc_gq::level

 block/bfq-iosched.c           |  2 +-
 block/blk-iocost.c            |  6 ++---
 include/linux/cgroup-defs.h   | 43 +++++++++++++++++++----------------
 include/linux/cgroup.h        | 18 ++++++++++++---
 include/trace/events/cgroup.h |  8 +++----
 kernel/bpf/helpers.c          |  2 +-
 kernel/cgroup/cgroup.c        |  9 ++++----
 net/netfilter/nft_socket.c    |  2 +-
 8 files changed, 53 insertions(+), 37 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

