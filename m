Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FDF3E494
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 08:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNTvS-0006q8-A5; Wed, 10 Jan 2024 09:27:02 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft 0/3] set related parser fixes
Date: Wed, 10 Jan 2024 09:26:51 +0100
Message-ID: <20240110082657.1967-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes parsing and evaluation of sets and
set elements more robust.

See individual patches and the included bogus-input-tests
for details.

Florian Westphal (3):
  intervals: allow low-level interval code to return errors
  src: do not merge a set with a erroneous one
  evaluate: don't assert if set->data is NULL

 include/rule.h                                |  2 +
 src/evaluate.c                                | 31 +++++++++-
 src/intervals.c                               | 62 ++++++++++++++-----
 .../expr_evaluate_mapping_no_data_assert      |  4 ++
 .../nft-f/invalid_range_expr_type_binop       | 12 ++++
 .../bogons/nft-f/unhandled_key_type_13_assert |  5 ++
 6 files changed, 99 insertions(+), 17 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/expr_evaluate_mapping_no_data_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expr_type_binop
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert

-- 
2.41.0

