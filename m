Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BE51CF5C7
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030974; cv=none; b=X1Ei976XCcRNVLz92qs67LfExB31xfGivbL6rQQ1aRZgza4pvj3KiB1IMUGqdbiJM4AvHZsVZaeD4tePFV+2O7C9mDOPCXE3mSm9qHkBXQet/nzKUaeVk5d8C+ITgYXazE6C4wWoiVO2kGwOJLXXlw2zvletljPQR0SIxpwpSDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030974; c=relaxed/simple;
	bh=sLPEtKHVknFLRvoAYtcrHch0qKxb0YKsdX5Q+CdkqBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F8vvN0hXi7QExAHyBLgm6QCklHaEG+C7e1En2FOMTKafDuJfajixQS8hUzs4sicfb+0uYXrRJo9sRArVgUFGJlGTtLcWXg/qZntPWLUXS21hMy6RGZ5jI0uCnFfS4tK3dNGR3/T6w3t5cvCONSkhbynsG9Nwf3tS/sjMr/D0F9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl,v2 0/5] bitwise multiregister support
Date: Tue, 19 Nov 2024 16:42:40 +0100
Message-Id: <20241119154245.442961-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is just a rebase and reposting original series from Jeremy.

I removed a userspace check to disallow to combine _DATA and _SREG2
which kernel should reject already.

I posted the series from the wrong branch.

Jeremy Sowden (5):
  include: add new bitwise boolean attributes to nf_tables.h
  expr: bitwise: rename some boolean operation functions
  expr: bitwise: add support for kernel space AND, OR and XOR operations
  tests: bitwise: refactor shift tests
  tests: bitwise: add tests for new boolean operations

 include/libnftnl/expr.h             |   1 +
 include/linux/netfilter/nf_tables.h |  18 ++-
 src/expr/bitwise.c                  |  65 +++++++-
 tests/nft-expr_bitwise-test.c       | 220 ++++++++++++++++------------
 4 files changed, 205 insertions(+), 99 deletions(-)

-- 
2.30.2

