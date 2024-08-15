Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE307DA70
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721846; cv=none; b=iTjWWko80ttE4t1He4j7qFvionpND/3py1d/adAopuPXrfFfU12rDqpZQ0yEibufiB16cgp1YKqSmcNY6k2wfEDB8purn5LvU5XExsRSR6IF2qo4hXrsdb9oZYwV0McscAYUM8S9uXPwjkBpWZswi7tvGP2e4JONStAi2JOrw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721846; c=relaxed/simple;
	bh=7GseGzIgNvR7WaAmDch5kdTnv5RFGyDljhMU+gyKNQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g4WFx0I8AvbKq6+8wI1C/QIiaRISSTGzmr+KzNWr5nmmmA3V43KSqp/Kbyh8tLSMkckk2YDAlWg4ayFRuQGQNcuMSmWLrEr1X9jCLSsUGyLsMxYITZrYYwTuOfNL8CO4fjyTbPDS+nqPeJcL0kvP3NlkiM42hakH5mEaBe+9rwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 0/5] relax cache requirements, speed up incremental updates
Date: Thu, 15 Aug 2024 13:37:07 +0200
Message-Id: <20240815113712.1266545-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset relaxes cache requirements, this is based on the
observation that objects are fetched to report errors and provide hints.

This is a new attempt to speed up incremental updates following a
different approach, after reverting:

  e791dbe109b6 ("cache: recycle existing cache with incremental updates")

which is fragile because cache consistency checking needs more, it should
be still possible to explore in the future, but this seems a more simple
approach at this stage.

This is passing tests/shell and tests/py.

Pablo Neira Ayuso (5):
  cache: rule by index requires full cache
  cache: populate chains on demand from error path
  cache: populate objecs on demand from error path
  cache: populate flowtable on demand from error path
  cache: do not fetch set inconditionally on delete

 include/cache.h |  1 -
 src/cache.c     | 23 ++++++-----------------
 src/cmd.c       | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 18 deletions(-)

-- 
2.30.2

