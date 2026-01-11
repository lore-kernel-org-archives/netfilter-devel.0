Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43334D381
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149613; cv=none; b=oNvRuKFuYuElD8yysldpVl8ZFkk0e6vRHWzcmAhA3OtqUX5GeFInrPu7cTmW+T5xZSgsfYAKlsOhm9vD67/tOXI/DaE41T/FIR7pjRhZY4+QNIWX18y1VTCTUbbzYW4ysJqDjf3LOprlc0M1LatU7sfZSjATzU+XfPv0le0unpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149613; c=relaxed/simple;
	bh=awXvZ1A71UfcYDRdKlq/EuSVOy+E3bLoSReBcOuAvUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PnKorH5/IiTXUpL7NHQOjl0F0GlSqnbLxVe1HUY0730/q5Xb4+WqQP10yzY6RzDoWi/AoEHrvtw56BE2/w9l2L9kBCopJmZLCCL0omShLxX30wOXX4ywsfaUMpMr82mWBCkbOWtFJIu45/qZuQm/mR6OrFnx7+79r9ey3Bm4Wzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=R4+306aK; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="R4+306aK"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b25ed53fcbso10920285a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149610; x=1768754410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQ/cSikLvbI3hXJPKoBuG8+prqN+wus2UjaGRinM+Zc=;
        b=R4+306aKcRkTavVJgKshF5OGubKTSIvbyDEnWARlw53MLMN0tNFtZqkX/vwVwYAqJW
         mxQmNhI0Wt9GpG4y02tPLdWSESwYfdQuvx/CLcK8XEL2teZfELGcJ0798LO7Rw4v8Khx
         p49Q5jMHEPFXw79WBGPwlB0WmRA1qWd1c7bsGCTPPPphPRKboyb/XiWiDfiYJlUWJeUR
         vesrTgZI0r6rJpm4ayoELhmGuyEVdoatEAo3OhS8R/CZQkmGp+E53Pw4pd3LoHFZIIBn
         HCy+vaCupnEHWD6P4FDZ+x4KNPDo8wkGXBkdLB+nHuehgKcIcyZftcxhSWqkGbjjMqDx
         q62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149610; x=1768754410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kQ/cSikLvbI3hXJPKoBuG8+prqN+wus2UjaGRinM+Zc=;
        b=qRC4D+X+8NAhZNQw4ZOCKg4LP//ko+w0RHXK5D89sgEs282iT5cZjxdoN7LoAgEW1U
         VhaSyWMJvrhJnhneRa/4NE1pLSOvzfa8u/ryz04mQlXG/I9e36U5lS3+EhBvI+3MZ6Ss
         8koEdvciZhwltd+NQTVkR8s4q+/PFQbdSNeHW3idC2H5flJPQZNCeU2QuKcrgmEeRRyG
         /o2CBtnMWrExkhnf1R5WzPeL9954Nl//6w5eZBh9gsR6Pk0hLgU4ZFCn3Sl57Xc/HqKT
         14Y/dKT+W/VTDCxW/JAbqUL/6Pn6cFzqJHjbezgbIxkOU163i5GZrcujC/23YgUwvMs8
         e2ng==
X-Forwarded-Encrypted: i=1; AJvYcCXxjJbbCQtnOxpw2N1RVh0lcYBHak9xBPsmkcctLbNxzvccLl3Z2BNTeMJU+fVgy5wVcC3PJVpmGx9dnjFE/Ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfruUpBxQ0OvHDs7jyJKyNlnu9RSKaGcD9ao/tR1qCH2J5Av1h
	HrOfRQI9+4wLux6Oy0ModMIBazfP/psyG3n9QEX5x4AiNTDBT10/Mk2BuD9CtHVdpg==
X-Gm-Gg: AY/fxX5t7RUpl++hIsu2pd1NU6W9F3TU+tLr6hap+937e6xCxevELexzzfHmizNNaG7
	zunwFQrXLHJt7Y+m8tXhJBWr27HMUFrr5X9HpirqQoZ2zyAkyuXP0T7Zy6Lz38+3O73KLJpvXQj
	JYBHG8fqYelgZYYMW758/apwa7jIF8xeVbprR2sDeV+7aLALZQfjSiCOaXISCR+Z+EeI7bXFuZR
	6UhiPtg0g0uxujy4644ImVoUBHJynq2W0mQZcBBaAz+wWe/sPUC03MDasAWQ+GPRrFhTAu+0l41
	6Zv5VHcFS1T9IicxLbZ/4dXqFvh1dxpRrG+oBslIxZ3rbodkyH77FyVHq6jehLQXrIE/My6qZ7G
	UuK59C1+XKyDLwlm/ZhtH6v0Qc8jbjQUmFgJlshrpuRYiBg6r2HNZ7OmHjHdbJ77hoVwGWyPBK6
	ZUwXyFV6/tFlY=
X-Google-Smtp-Source: AGHT+IH8eQLPUqqvtM3zcUhfnrqqyrUCdSxRKj6x4w0G4bkcCcHfrId3b1V5LyA7v8lexn8lAaU/Rg==
X-Received: by 2002:a05:620a:3911:b0:8c1:6018:b186 with SMTP id af79cd13be357-8c38942e90amr2024853185a.87.1768149610105;
        Sun, 11 Jan 2026 08:40:10 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:08 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	zyc199902@zohomail.cn,
	lrGerlinde@mailfence.com,
	jschung2@proton.me,
	Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 3/6] Revert "net/sched: Restrict conditions for adding duplicating netems to qdisc tree"
Date: Sun, 11 Jan 2026 11:39:44 -0500
Message-Id: <20260111163947.811248-4-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit ec8e0e3d7adef940cdf9475e2352c0680189d14e.

Reported-by: Ji-Soo Chung <jschung2@proton.me>
Reported-by: Gerlinde <lrGerlinde@mailfence.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220774
Reported-by: zyc zyc <zyc199902@zohomail.cn>
Closes: https://lore.kernel.org/all/19adda5a1e2.12410b78222774.9191120410578703463@zohomail.cn/
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/sch_netem.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 32a5f3304046..a9ea40c13527 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -974,41 +974,6 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
-static const struct Qdisc_class_ops netem_class_ops;
-
-static int check_netem_in_tree(struct Qdisc *sch, bool duplicates,
-			       struct netlink_ext_ack *extack)
-{
-	struct Qdisc *root, *q;
-	unsigned int i;
-
-	root = qdisc_root_sleeping(sch);
-
-	if (sch != root && root->ops->cl_ops == &netem_class_ops) {
-		if (duplicates ||
-		    ((struct netem_sched_data *)qdisc_priv(root))->duplicate)
-			goto err;
-	}
-
-	if (!qdisc_dev(root))
-		return 0;
-
-	hash_for_each(qdisc_dev(root)->qdisc_hash, i, q, hash) {
-		if (sch != q && q->ops->cl_ops == &netem_class_ops) {
-			if (duplicates ||
-			    ((struct netem_sched_data *)qdisc_priv(q))->duplicate)
-				goto err;
-		}
-	}
-
-	return 0;
-
-err:
-	NL_SET_ERR_MSG(extack,
-		       "netem: cannot mix duplicating netems with other netems in tree");
-	return -EINVAL;
-}
-
 /* Parse netlink message to set options */
 static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 			struct netlink_ext_ack *extack)
@@ -1067,11 +1032,6 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	q->gap = qopt->gap;
 	q->counter = 0;
 	q->loss = qopt->loss;
-
-	ret = check_netem_in_tree(sch, qopt->duplicate, extack);
-	if (ret)
-		goto unlock;
-
 	q->duplicate = qopt->duplicate;
 
 	/* for compatibility with earlier versions.
-- 
2.34.1

