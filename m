Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C4026B2C8
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758698835; cv=none; b=lHQTw7djnwKdmPkq57EiX/5GkH1PxmkBH14wLF0PmCnCuN1xkG3qikjpXdZ+9d2jkfgUwhjdKzu34GyfcN4T1JhfpT6o+DCTS5+JZC0fWNrttGSmabe3ysUtu4RkYN3RGwbp/qxF82GWcmkA4o0RRvJh9/BWpPC21EipFCTz5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758698835; c=relaxed/simple;
	bh=YNphk3mB4ivfNu3QKEs10XGiMwMxpi1YPo4dtv7YWgw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=h6Ew+vphCexDd542hzBnjN1jtdBAHS9HFFrmb5gKyInx/s8GW0taL9Fz9bcj+aMFy2hZnkcAer3dE9auvuhSqPgXHdpE97afREYKhrotTVsasYmK5YqKz/zAOeT7k4FKCJZLbji0fe0HBCrdnc2TOGz8yYbUCGJUOWTgSyp6S9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ohyQTZ3q; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ohyQTZ3q"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-8589058c59bso43023485a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 00:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758698831; x=1759303631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6K5fm+QUCrwoVlxEjRVdfqv7MdLli6zI+B4E/bRgTXA=;
        b=ohyQTZ3q2fraYCAMhNK3QabeQtpo8SHjb+wiVksTOG3j+P6RcrUpKXRP+OeQj9Axf1
         E9mUrgSV2BGuoMtP3N+wOLqX9rMJDMOBAzivKwZ+q1cdqniESFmbLVKXKiKdva90nq9w
         lcqyzBtBfqKyvLogZ6Af925AgM2IHhYPu0j3PGccqVGhG6zywo1QOGRjv/LmyAt5H7g5
         NBlmPDpn8ue9R8qf6Z2W+Lxx/fr3NNZL+0YbWGxGQIJ8tuPbRgxxt8AUCb866gJOie3D
         PgJpzzpHUYlnY1QHzvrOunkbQjvFasE3ZFeD8uQ5awquqYKiCQfACn40lD0PBb3uxYp4
         2B+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758698831; x=1759303631;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6K5fm+QUCrwoVlxEjRVdfqv7MdLli6zI+B4E/bRgTXA=;
        b=LLn0DPYAqkkHDHB0bltZcI66DAMTQGuv/0L+m2VYkogtnBZef0O/Z8r2EioBoYTyrH
         73SJHCiiq4AUaXlJ1czpZkUQWhv695kf7F4ya3MO9/NYhiXEspRnK9qJ95ydKWrS5KTY
         Y9kcFmV8/10jAb6YDokA8tC0dUxOD49a6FRIb3MIZ0LX8GtFoKVbSLt8IW/PZHKoe35b
         AeVxKfYFVJdTwWdhZYHG+xYnU4N4JVlCngRVv/XT5fO9ORBUfsdvLryTvfTsQ83TBsNe
         r1cpewvqBN+p2jA+K4BeBGNB05DBaUDA8k1PIpjlkoOTAvHT51gvjRZoRBfegHk996Rs
         tWDA==
X-Forwarded-Encrypted: i=1; AJvYcCXnVPyGTLMGGd8+CTeLRx/gR7nhSDKSNxBHe+tbRvx8Hfwfv9DE4U9yYe9lX0zse07ZgiEA3WxyLvBSQfrlWdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjVkgzFtrH2BNDQ8GsOC9g2ABjw8uEXS1woYAUKYKjjGMZtx7A
	iDLTcDxU5FjNQ7xzsSGYav5dtlMgkzrV/ZpRQ0I5GmarbGKbbKo/okoSzXndIO2/Ki78ViUuyfH
	NG6tDG6zJevmBoQ==
X-Google-Smtp-Source: AGHT+IHbInjHcu8+g2yR5s/vHlw8EvDs5k3IxMOhdo2jXUPw2zbEl2OhrziWz6q5iYS5mQWH4t6sJSc2lQWqVA==
X-Received: from qknqj10.prod.google.com ([2002:a05:620a:880a:b0:84f:d9a2:d24d])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:4627:b0:84d:9f49:6898 with SMTP id af79cd13be357-85173700769mr688877485a.61.1758698831223;
 Wed, 24 Sep 2025 00:27:11 -0700 (PDT)
Date: Wed, 24 Sep 2025 07:27:09 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250924072709.2891285-1-edumazet@google.com>
Subject: [PATCH nf] netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

ct_seq_show() has an opportunistic garbage collector :

if (nf_ct_should_gc(ct)) {
    nf_ct_kill(ct);
    goto release;
}

So if one nf_conn is killed there, next time ct_get_next() runs,
we skip the following item in the bucket, even if it should have
been displayed if gc did not take place.

We can decrement st->skip_elems to tell ct_get_next() one of the items
was removed from the chain.

Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_conntrack_standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 1f14ef0436c65fccc8e64956a105d5473e21b55e..708b79380f047f32aa8e6047c52c807b4019f2b9 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -317,6 +317,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	smp_acquire__after_ctrl_dep();
 
 	if (nf_ct_should_gc(ct)) {
+		struct ct_iter_state *st = s->private;
+
+		st->skip_elems--;
 		nf_ct_kill(ct);
 		goto release;
 	}
-- 
2.51.0.534.gc79095c0ca-goog

