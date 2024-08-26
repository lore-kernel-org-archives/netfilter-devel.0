Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A661A13C80F
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662505; cv=none; b=i8FgZPRHH5nxTfEOXebDtkNuPXGK/kIPGx/mSf/ZOPLXdvQ/vRRPhTcu9eM0jsHgEzJe/LjYm8ETyL7HrIFGVqUsfS82aTwA9AAEjgPJYQCGR8bapZlLW7zYQb+RfgVvmL0u1eKglSvb1SMVUXvZKGtL7gI74T3ho/qwyi9w5/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662505; c=relaxed/simple;
	bh=zrn4yD5z9iIM9FW5ytUPQBUsRB3VBL3Oc9w+CWVxVkk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=lRDh9HG0JCOR5DVhmeR2S6ASbIjL9xISLSSao1pdcxv8ge6Pz2NaXcizTdeqo0kR09D/GWhnG8g5XlLY/sDK178J8lOIlJhTFA7+yGrleAGBDor9uC1ZRsCh9u0DqB3ul1RZEH7OvcSKt7C8QhfmXogL/ra8Bk7KFjHGqYp3AJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 0/7] cache updates
Date: Mon, 26 Aug 2024 10:54:48 +0200
Message-Id: <20240826085455.163392-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains cache updates for nft:

Patch #1 resets filtering for each new command

Patch #2 accumulates cache flags for each command, recent patches are
	 relaxing cache requirements which could uncover bugs.

Patch #3 updates objects to use the netlink dump filtering infrastructure
	 to build the cache (

Patch #4 only dumps rules for the given table

Patch #5 updates reset commands to use the cache infrastructure

Patch #6 and #7 extend tests coverage for reset commands.

Pablo Neira Ayuso (7):
  cache: reset filter for each command
  cache: accumulate flags in batch
  cache: add filtering support for objects
  cache: only dump rules for the given table
  cache: consolidate reset command
  tests: shell: cover anonymous set with reset command
  tests: shell: cover reset command with counter and quota

 include/cache.h                               |  12 +-
 include/netlink.h                             |   5 -
 src/cache.c                                   | 201 ++++++++++++++----
 src/evaluate.c                                |   2 +
 src/mnl.c                                     |   7 +-
 src/netlink.c                                 |  78 -------
 src/parser_bison.y                            |   8 +-
 src/rule.c                                    |  48 +----
 tests/shell/testcases/listing/reset_objects   | 104 +++++++++
 .../testcases/rule_management/0011reset_0     |  31 ++-
 10 files changed, 305 insertions(+), 191 deletions(-)
 create mode 100755 tests/shell/testcases/listing/reset_objects

-- 
2.30.2

