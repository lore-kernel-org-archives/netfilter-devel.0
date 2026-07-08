Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D17407CC7
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502578; cv=none; b=EJw7ZIYpVyWSQMypQJ5uXB0ASFWdfHzP2f5yGLD22y7sNwYf0U2jpP5z4ajNKeHY4s3e1vvK5PZ75nXX+ROBdzL9+UtHhZ4Yd2yGzmUXoEr0IiXYZmAhpKShNS7l1G0gqWqRxu+Yr+nEb9JB7OluWPCvtmnHB0K8l/M99z62k4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502578; c=relaxed/simple;
	bh=71IPpVxSL6rELSFV3RscCJl7aym1gXBpQyo2V285sW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QAjzgU/gu8jWESuGBhI3ma3WMvKtLX/V9aulYgus4QYKVPcVA7vQM8461GVBTuTnQWrX/kiNtnYnL8ZN5YNheBiiSE1ATuRiRzmLFpqiMNjTZ6soshPUHs+9dw8BqzPvmxR+zKMrDIjhEpWfw5XXqMdKw3m+IkH1ooc+ZwXnMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oiAX3HRW; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oiAX3HRW"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3811f512167so575660a91.3
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783502576; x=1784107376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bESlo7lvNwhdiVElYDSnZy0QW9Bj+WsccRVrVGGNJng=;
        b=oiAX3HRWBGooIDPulrZn1l987zJdstH6BPbfN05ASw4hB35iJdMBZ0YS8nsNTs7ePL
         j3IRes2PnwojXzYU9NApKi2RPH1kFghEsvJNjad8A6lt6NAlQaacFDggaaA2t0aOzkeP
         f7v0sXq0y/aGroJ8n16OTv5EUFZztalq3WLGn5J9wrYco9f2DIqB03K/KNJ7u25p35WY
         Q5ClouECdVbbyz0uZqQM0Se4l21yINh6j2LzNPH+4Zf12OWh6bK0ZFma4b2+btlDju8u
         b43opC16xq8o0VFCk0hr9hp3uu29bs14ZReLVRqPFZ3K2hFvatl1D2nBqAZyadRfMo3k
         zxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783502576; x=1784107376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bESlo7lvNwhdiVElYDSnZy0QW9Bj+WsccRVrVGGNJng=;
        b=fNvANsjRC6RwSlHGmYm8IazUG4w0EFoCYbEP3n7jq7Vkq0UJcLQp8nCiUbhSVUfVAD
         f6RYNzmtygRbsIEY2IHPxVHe5Ga/rbCIhqudTfKiFcz/lEIpu//EtAs5maaKnnJ6k3Ic
         5PMjrmyo3hkROK3K3CfCfOsupXxkCsZb6CK4UkA5YN6GqYGd57uYHGD+KtyPUidyr5x6
         oWOiCvl1SH4mk7evumJnYkRtypoCbRsBtw5CaY4fX2yLAJ96P/nAFDJS1u1l/vsPl/mh
         wX2/T6ubB70D/gM2SkhkvKuiPwJTrZoZtHtzc8WuZYazeFY4WYOd6qXAb/tDNkf0fj/H
         BdjQ==
X-Forwarded-Encrypted: i=1; AHgh+RpcxkLXvkjRK22ZlthtMbcrXNam+XfEQnPaaEcAZ4DFr9Sgn0CCmi1vUIBfGLv6mZi/P4m91Fboh67o2AwkQxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1f7vyUlWIT+Sc/n9bfYySkX/XVXRUEOQEaKtDz14m3s9uSkaw
	XEtvanblB72gsypKmMhCejcqugMuG1SyCCxTzkS63N/GPxCTVOWT9ruu
X-Gm-Gg: AfdE7cnrzzVkXEcNIag0b4do5pCXYboFGldds7tfsgaN3+IM9+eRImH9o8paBut9OMn
	Wy/y/8QI7/6e+sdQq6kIMRQ/z5U2V6veNezHzkOFwIYerGxFIUxzDX7TsmgDwqF8ST/kexpWDdO
	Exiznh0Kk1lJemUTtC++jFlRRK3ejT22sCzfNUbxbr0dNwzvV+8bxfuLt5uhLWJrqNrF+DriA9J
	L9bnvhvQ8i+1VWS5sooiKC/9AkX14+aAaqfkcSwBuWFj58ljV7doME2hreegPIQKBvFxuG6BxFe
	oCDmd4YxRfHFWweOjpjMOnL8uSZUaGk89Onu07JoJlGMRcQlevd+iwc44CWejj6NkSOK0Rn/Q4R
	ILyvyNM9KluxYg1t8fxUcz1cN8EXEYVZeD5MT/Kg6lHolP4LnUGIffHupiKgeFBP2VO9C2kTLW7
	zh3/Ni
X-Received: by 2002:a17:90b:17c1:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-3893ff630c1mr1831193a91.14.1783502576376;
        Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
Received: from homebox ([66.75.253.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118389d9bcsm9985334eec.20.2026.07.08.02.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
From: Yuan Tan <yuantan098@gmail.com>
To: linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org
Cc: yuantan098@gmail.com,
	jhs@mojatatu.com,
	gregkh@linuxfoundation.org,
	sven@narfation.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
Date: Wed,  8 Jul 2026 02:22:47 -0700
Message-ID: <20260708092247.4188498-1-yuantan098@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

We would like to ask for feedback on a proposed workflow for reporting Linux
kernel bugs found by an LLM-assisted code auditing tool that we have
been developing since earlier this year.

Since February, we have been developing an LLM-driven kernel code auditing
tool called VEGA. It started as a side project, but the results became much
substantial than we expected: VEGA has found hundreds of valid bugs in Linux
kernel.

That immediately created a practical problem: we do not want to dump a large
pile of bug reports onto mail lists and annoy the maintainers.

The first thing we tried was to fix as many as we could ourselves. We
started working with a group of student volunteers. Most of them are
college students, so we have been training them, reviewing their patches,
and trying to build an internal review process before anything is sent to
the mailing list. The goal is to turn these findings into useful fixes, and
also to help new contributors grow into people who can reduce maintainer
workload instead of adding to it.

The process was not perfect. Some patches were not good enough, and we also
made some mistakes early on when deciding what should be called a security
issue.  Our internal review process has been improving with the help of the
community.

Since March, we picked up non-root triggerable bug first and have worked on
fixes for more than 100 validated kernel bugs. we especially want to thank
the students and professor who have helped a lot with this effort.

But the remaining queue is still too large for us to handle.

Recently Jamal pointed out problems around our tags. That made me realize
that we should probably stop treating this as an ad-hoc patch effort and
build something closer to syzbot: public, reproducible, trackable,
deduplicated, and useful to maintainers.

So this mail is an RFC for a VEGA reporting workflow.

The rough idea
==============

VEGA would have a public dashboard, similar to syzbot, and would
send selected bug reports to the relevant kernel mailing lists.

The goal is to send reports that contain enough information for maintainers
or other developers to pick up, understand, reproduce and fix the issue.

For each public report, we expect to include:

  - a description of the bug
  - the tested kernel tree and commit
  - the kernel config and environment
  - the crash log
  - a minimized user-space reproducer
  - the suspected introducing commit
  - a suggested fix patch

The suggested fix patch is meant to reduce maintainer burden. It still need
human review, but hopefully it can save a lot time from building a patch
from scratch.

What will be public
===================

All VEGA findings that we have evaluated as not having major security
impact can be published on the VEGA dashboard. The dashboard would make it
possible to see what VEGA found, whether the issue was reproduced, whether
a fix exists, whether it was reported to a mailing list, and whether it has
been fixed upstream.

For issues that we have validated as having possible serious security
impact, we will not publish it on the public dashboard before going through
the appropriate kernel security process.

Dumping everything onto the mailing list may be annoying. During the initial
stage, reports will be rate-limited and sent manually. We will check for
duplicates against lore/upstream, and make sure the issue is not already
fixed or reported.

Report identity and tags
========================

Each public VEGA report will have a stable identity, similar to
syzbot reports.

One possible format is:

  Reported-by: VEGA <vega+HASH@DOMAIN>
  Closes: <public dashboard URL>

=========

We would like to hear what maintainers think about this before we start
sending these reports.

We do not want VEGA to become another source of mailing list noise. The goal
is to make LLM-based bug finding transparent and useful, and to make sure
the reports come with enough context, reproducers, suggested fixes, and
tracking so that they reduce work rather than create more.

Thanks,
Yuan

