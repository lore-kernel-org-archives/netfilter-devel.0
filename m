Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD417C9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715559001; cv=none; b=r7NBoYvaTiOTi+mLGs9tWoiYWG1oBvxhpPhMC5794pz2hztJTLL+U49nRfBuj4vCgIS5aexm5iFzDeKieW1EHDaE5x1mV8oM9cayHHY5JuqG1hZPpJOwcsBJWAhPnIQN9agVvWWvrovNr7g/v/5034ZtkKRLqPr1Ql/Kx7+2PUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715559001; c=relaxed/simple;
	bh=j5ReI+dkmLfYL3rhf/NbOzaERYSzmKe+G8J3O1wgkWk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PTcTp9DLLueC7C/mDFeCrzqe2bNJu4S/OOkwHgbH2qUm7Ymb/PzIQSuMaL3gFiEOr7dkQ9CA/kZ3S/8Do40XEz/FgfjMDIle+CAe6EzJjBfcAbcF1rEC0Rkx2VdiShROzD6oPhKAVhGjAnvuJ2KarmWKDGs4+Jr1vUd3k/etUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=boF5BYzC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="boF5BYzC"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so3840514276.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2024 17:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715558999; x=1716163799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G/WEADA0knahowoCwC0UB1tfsTxvAlht8Q4CeXdnap8=;
        b=boF5BYzCtlCY5l9zBia9nyl6y5dkK5rrJ+dPbSVnoet2nOHS2XvjUXT1f3m/3QVhd2
         z3N1M/MTKJa8RE7wVsc731p7XDGgmCTgLP0VxFUnzf5A/gQBhPlxV0naLxYkG3YqqTrA
         7I7IXgtVkgHfsW1R9peJQAMFoZ67H/FVkxm8uO+CR2lzeB27o9fKTlLcXONi4o6OiKu/
         NDT00BWVRvjQfxl0booD65d3zeXPA/eetdq7yrWVbedc8yvYZUg1/c1NAWjJinhm5v8G
         bq+0gwFvs+/MRNhbJ6LI6kD7MqPcTwHIZ3fX1KjjjmsxI65BiwWWXmOopCcJPJKedSYm
         84Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715558999; x=1716163799;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/WEADA0knahowoCwC0UB1tfsTxvAlht8Q4CeXdnap8=;
        b=cxQ7DQQKjnhkC5DfE+ahAuc5O26ArdmIoym16GNE7NCMILgUj93XjpH/DztOVIlrpf
         wM//+WiQGkiXmJ2m1M3vQQlixeayA4FGFc1cl85HC5Z6F6MAxgBFIWEc1zBTbDxfZmar
         cnx8PlAq4si7LmuXaZN/yrIsinv621nP1sL4fvzXB+zYtkTzwJw5m3oUVsgLmbabtkiq
         mAuS329ey16CqhJNiBfQ+/0DIRs2LfpHq7/CArUdB5CCKr8aK+/JNvKxj9fYzPjDOEzR
         v0WE8L89NLPWaFDhH2Y9JJrGhbVP7PXyzOs2hTdhyF2tv3U5p3UnTb01m01GGyf7kj3r
         fNXQ==
X-Gm-Message-State: AOJu0YxhhOy4soMtOrc+rKnD6L7w+XVVFu2j14nvfbTXkjcUUzUyk7Lc
	064qH41ibNszwKAWGvwkxhO/RC/Cj2wq2QzXvpt9jH+Qg7vaw/4k7gQY//tFkeC1r2cjiktFfBC
	Pbm9emMm9w01u8VxopcAlyWJKo2ufMIG1xXW/Q1PRK1PIChIphMKPDmDYsTAioPzNhg4wjGgO1m
	mL4V11plexNl9HIXuaOJzPkGz3JMe0wnxh4Wysw6w=
X-Google-Smtp-Source: AGHT+IEaz6JJ60TEF++9dH3TbfnrMw2id/NnkBFJAVNxDbrsImxAT90a+Qtpr9IVS1EuXzq8Ys/l9Xw/Vw==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6902:100f:b0:dee:5d43:a0f3 with SMTP id
 3f1490d57ef6-dee5d43c91fmr1816195276.6.1715558999196; Sun, 12 May 2024
 17:09:59 -0700 (PDT)
Date: Mon, 13 May 2024 00:09:51 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513000953.1458015-1-aojea@google.com>
Subject: [PATCH v2 0/2] netfilter: nfqueue: incorrect sctp checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Fixes the bug described in
https://bugzilla.netfilter.org/show_bug.cgi?id=1742
causing netfilter to drop SCTP packets when using
nfqueue and GSO due to incorrect checksum.

Patch 1 adds a new helper to process the sctp checksum
correctly.

Patch 2 adds a selftest regression test.

Antonio Ojea (2):
  netfilter: nft_queue: compute SCTP checksum
  selftests: net: netfilter: nft_queue.sh: sctp checksum

 net/netfilter/nfnetlink_queue.c               | 10 ++++-
 .../selftests/net/netfilter/nft_queue.sh      | 38 +++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.45.0.118.g7fe29c98d7-goog

