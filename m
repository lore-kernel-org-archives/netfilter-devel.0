Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB62475E3
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786899992; cv=none; b=Fu9VhuQB53rumVLUiNS7U7hHs85tBZ5jzTaMQDDTdKtBaVE15u6OVqdnwFfhimKtLhs6j+OvTZFGZsJod/YlvEfes/0ubpvj8J4a6HczhoFR2/rIvtqzSGH8opyGoJTxu5Rw99nFmJPF4wSYvt3UareYbd1HQjtSMRg5fFxtfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786899992; c=relaxed/simple;
	bh=L69+1dDustAyU3dm2EpyPXLTtInw8sint+wEfWpmtFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FBiZdreq3aTBsMOVd5FMOBqsr8cdbGVVbBDPw99Y8DBxI6gSKXKtu4Iwlumz+FUGfrD+J0526CTUl8FA+ut/6G9dKVljtawkcFN5Qw3ZZZGri1uOYhIxXrWeTDGuN02P6UGXiUGK86mlBGPtJ87VfJfjf2VsxkQ1dUbcQzTdEHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QH2v8wNU; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QH2v8wNU"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4956242332dso27598425e9.2
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786899989; x=1787504789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JGPakpBM4X+7dwcTf1cyu5+L/mRrMIuOJFQinoZgjxc=;
        b=QH2v8wNUAFvEg9D/MEdkAC4PjlS7T4E1DksAUNXUSD8OMbCR96E30RHt1PbJh2MRLe
         QzyQhaDTsZYlp6/8RxMDcgBk9vnSaAQAPaLGi7lrdu15brKpwhdbjP0I+XJSjmryllE6
         h5OWnQhUNg/bj/4HWztSsEPHApy5Iyp2t7f8xe3i+JkxrzE3ueNxBisvoVp2Cu9UZPgn
         NvBQMDOit5Tx3YnG6gLgQ0khN8C9ZL23wF3x50zjAcx48IRcOpj+r5uWZYnlC+VKyeKq
         1sfGksSXpGY2c5oQZlyqbD/H8TVDgtVAZCtUw4wqRcm4uzw9d/LPyYH9pNzF2bD1QM/t
         HnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786899989; x=1787504789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JGPakpBM4X+7dwcTf1cyu5+L/mRrMIuOJFQinoZgjxc=;
        b=Ud+jpzTYGjqfdA71s2pHJJqBLD9pC4r9ALxHzjjD0aUzbx5ZZHpGtLVta8bnsgeit3
         IpAdF8yOcLYazMS3I1QXA7wBk/5mFfIfY/IbJfIGTeaPfWBG+e3BA0K/TqQ4clW+x05Y
         QlximB9xyH2g6wJup4E55Z39mW8ALglztoVz1QFEilZEtWMeO7ig7VsmcLIAGsJ8sCzc
         zIt/F8nAMWh4EN6kMaFEb6KjQdoeUw0eAzHw+5SQuM9SxsUu+wARChPIV8HqPwrCtfIf
         G4MxhlzqycecYqTbXVOBgXOVR0fXhg2zUsZIHHapmTD+RaSt5Yw+8xIk/E2EWfvTSpA/
         9aPw==
X-Forwarded-Encrypted: i=1; AHgh+RoFs5BTXB1LYO6qxA+FCqROd5NlP3rN7ieK6VvxL0qpeMcV7fpbOFvr0wVyX7kv6mQMuPuu8SJGH5oM11O+ia4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEZxs380eRB+V1MzMJ2wlnmAgEwzm7kMr4mkbAO8mYdGJoJ/Bp
	F2AFAWzYS6U2n6kgNGvt3MiAVH8HZY2W4V+tnu7duwe0MzDDfa7l5YVS
X-Gm-Gg: AR+sD10s5P4aTK2iDSjUvjYrvR/x1JL+ofnCqWnY/dPuZqZB3J9InLldfSVfgfHKFIX
	KUmt25qG7wu8EKdN6DboQI6bGzq7nu2wBXfBVRIljspnkwfBVfPKcqth51h136N7y4nBZvAGJla
	yc3geCx6D+1bpQxMrY2Ckgw5ABkmJVZUQQTwDFNtyATKnulbkOOwAYx0TNgBZj1Jm1hL6qDhEZ9
	v/bDuG8CN63y3dUaWqxWElXrzSVJu7F4Tka8i95WHE5kwwBaj4gEyYo5lDqBrjPPNyuriQLulvT
	BiAPHM6cZOg3/C0VPeL4BlFfkmoiAkYQET+0Lcw24aVJf3UEv82Eyw5AWtkH27trLWn/o6RHmyF
	2b4dyJC/lTH6mhwwz9ACdUgJaAD2/F86vQWicnDtLlm0vKhnZgw0dEKodA8GRjGrpVQE9j1Uy0z
	tyKbD55RWt3FTI5resC38XJRcEn7u1y7CVs5wvSUviQnpHNeHDLJCJtInwAeC0c66L0NKKeNTW0
	Ewabb68G7vHVswTB/W8GoBxeyLRgW1/p/p6acxcG5gChC0YPqZkIOOQyzl+pAKBdQMRVHP1gqGu
	InbV8eZ+3wxf9//gL60mDCgZzFpAZPArgVlZozI=
X-Received: by 2002:a05:600c:12d3:b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-49987980889mr187027505e9.10.1786899989122;
        Sun, 16 Aug 2026 10:06:29 -0700 (PDT)
Received: from localhost.localdomain (p54a14b85.dip0.t-ipconnect.de. [84.161.75.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999618acafsm55671335e9.14.2026.08.16.10.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 10:06:28 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: [PATCH 0/4] lib/textsearch: fix ts_bm resume offset, add tests, two small cleanups
Date: Sun, 16 Aug 2026 19:05:36 +0200
Message-ID: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lib/ts_bm.c never updates state->offset. With the "bm" algorithm
textsearch_next() reports the first match over and over, and a caller
looping until UINT_MAX does not terminate. kmp_find() and fsm_find() both
update it. This is an inconsistency between implementations of one
interface, not a documented limitation of Boyer-Moore. It has been there
since ts_bm was added in 2005.

Patch 1 fixes it. Patch 2 adds the KUnit coverage that would have caught
it. lib/textsearch.c has had no tests since it was merged in 2005, and
every bug found in ts_bm.c since was found by inspection or by a user
running into it. The fix comes first, so the tree is never left with a
failing test.

Patches 3 and 4 turned up while writing the tests. Both are independent
and can be dropped without affecting the rest.

  3  struct ts_state.cb is cast to structures containing pointers but is
     not aligned for them, unlike skb->cb. Latent today, since the only
     in-tree ts_state is a stack local.

  4  ts_fsm only reports a match once the data is exhausted, which the file
     header does not mention. Documentation only.

A related patch was turned down in 2017 with "There are no users of this
functionality. Once you add one, you can submit this patch alongside of
it." [1]. That is what patch 2 does. The tests are the first in-tree caller
of textsearch_next(). Patch 1 is not marked for stable, since no in-tree
code was affected before this series.

Testing. The suite is 20 cases, 10 against each of the two algorithms, and
passes. Without patch 1, ts_next_advances, ts_next_finds_all and
ts_blocks_iteration_terminates fail for "bm". It ran under UML and on a
real x86_64 kernel in QEMU, with CONFIG_KASAN=y and again with
CONFIG_KMSAN=y (clang), while driving packets through iptables -m string.
No sanitizer reports in either.

textsearch has no MAINTAINERS entry. get_maintainer.pl routes patches 1, 2
and 4 to LIBRARY CODE. include/linux/textsearch.h, touched by patch 3, is
covered by no entry at all. Netfilter is on Cc as the only in-tree user,
kunit-dev for the new suite. lib/tests/textsearch_kunit.c would want a
MAINTAINERS entry of its own, but that means naming a maintainer for
textsearch, which I did not want to do unilaterally.

The kernel-doc of skb_find_text() still tells callers to use
textsearch_next(), which has been impossible since commit 059a2440fd3c
("net: Remove state argument from skb_find_text()"). A fix was posted and
acked in 2017 [2] but never applied. That is a net/ change and will be sent
separately.

This is my first kernel submission. Corrections on anything I got wrong in
the process are welcome.

[1] https://lore.kernel.org/all/20170207.105320.45609559819874123.davem@davemloft.net/
[2] https://lore.kernel.org/all/20170208084455.GA1878@salvia/

Bernard Ladenthin (4):
  lib/ts_bm: advance state->offset past the reported match
  lib/tests: add KUnit tests for the textsearch infrastructure
  textsearch: align ts_state.cb like skb->cb
  lib/ts_fsm: document that a match must consume the remaining data

 include/linux/textsearch.h   |   2 +-
 lib/Kconfig.debug            |  19 ++
 lib/tests/Makefile           |   1 +
 lib/tests/textsearch_kunit.c | 327 +++++++++++++++++++++++++++++++++++
 lib/ts_bm.c                  |   3 +-
 lib/ts_fsm.c                 |   7 +
 6 files changed, 357 insertions(+), 2 deletions(-)
 create mode 100644 lib/tests/textsearch_kunit.c


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.49.0.windows.1

