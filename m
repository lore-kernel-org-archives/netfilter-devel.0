Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AB61F9EB0
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470464; cv=none; b=FblucQmxW18BX3r+3NF4AKof8J5FCHFolX6gF85iPGx/Rnf/KPk/1+UOyRDYpzMIu2/UxZKYa+upUjroiHiZjrnAXYmF1eHLYn+6fD9Co25//mUv6Qv5EFr7WG/AtOyKwmIDQyLUILkRXlzf0dCfYSxfV2itUymLYFkIrvSpMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470464; c=relaxed/simple;
	bh=QXjaV9ul+jpkBKv9MODe/jAA4pzvpr2IuDa6+g+fOOg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ViB8dw73eleOkcNtUisbsIXkcBYZogtqtHLbZALqFQmzPRa97HfFYXAHALfbUKppzykH5bhz7Yuin6TKtOLYwMeEdGm2ENHz4jjd7T8Cy0ex4K4hd/bUkucNpraD3mg2W1g3856//6J/yP5aSNciFNHbKFIfvQGRibChyWnEHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/6] shrink memory usage for interval sets
Date: Tue, 17 Dec 2024 22:15:10 +0100
Message-Id: <20241217211516.1644623-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is a continuation in the effort to reduce memory consumption for
sets from userspace.

Patch #1 adds a helper function as preparation work.

Patch #2 fixes invalid auto-merging of elements with different timeout.

Patch #3 add EXPR_RANGE_VALUE to reduce memory consumption of ranges,
which now require two struct expr instead of four.

Patch #4 makes a simple constification of a helper function to detect
interval sets with single key.

Patch #5 renames a field from set to init in mnl_nft_setelem_batch()
to prepare for passing struct set.

Patch #6 reworks the transformation from range to the singleton elements
that represents intervals through EXPR_F_INTERVAL_END to create them
only before the netlink message.

This shrinks runtime userspace memory consumption from 70.50 Mbytes to
43.38 Mbytes for a 100k intervals set sample.

Pablo Neira Ayuso (6):
  intervals: add helper function to set previous element
  intervals: do not merge intervals with different timeout
  src: add EXPR_RANGE_VALUE expression and use it
  rule: constify set_is_non_concat_range()
  mnl: rename list of expression in mnl_nft_setelem_batch()
  src: rework singleton interval transformation to reduce memory consumption

 include/expression.h |  13 ++
 include/intervals.h  |   2 +
 include/list.h       |   8 ++
 include/mnl.h        |   3 +-
 include/rule.h       |   2 +-
 src/expression.c     |  85 +++++++++++++
 src/intervals.c      | 280 +++++++++++++++++++++++++------------------
 src/mergesort.c      |   2 +
 src/mnl.c            |  81 +++++++++++--
 src/rule.c           |   4 +-
 10 files changed, 345 insertions(+), 135 deletions(-)

-- 
2.30.2

