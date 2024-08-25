Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FE647796
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Aug 2024 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724626041; cv=none; b=kQEY1Wqnu2T/ZE7Sv60x7hueTXkviyaQvig3ziS6VPLdXYWX+Wr+YvF+Naq1ELqsZsSLb4BzUuwDvJP8mtR+sL5Z6kNqONeyKYccOpSE5xmOrHD4dpY6e/RNYXZ67PIQ33GbsAQcC/BA2HVHS6jHr1rO86peroDDW3clTJIfpRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724626041; c=relaxed/simple;
	bh=PymbJqsQGH396Na6BMJIT7Br2ADESo8N8GC/AmoTgk0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=TtKtWysxL5hpMQD9CJ3xfTGKxtwwpYoXddm1GeMFjy5ZX+6I/SgEFvUeZzenevXaixZniV5xYK9jLthm03Qx0C46NnuZRbHIZBbS1qw0xRPc3qzrsCkstU27Yt/Ja5IzxZNNGf4LyEDXcrkoztF+gpvh2iu61axKQRLsbEaRFRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/5] cache updates
Date: Mon, 26 Aug 2024 00:47:02 +0200
Message-Id: <20240825224707.3687-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This batch contains updates for the cache infrastructure:

Patch #1 improves integration with objects and the existing netlink
         dump filtering infrastructure.

Patch #2 updates rule dump per table, to avoid refetching rules
	 several times.

Patch #3 updates reset command to use the cache infrastructure.

Patch #4 and #5 extends test coverage.

Pablo Neira Ayuso (5):
  cache: add filtering support for objects
  cache: only dump rules for the given table
  cache: consolidate reset command
  tests: shell: cover anonymous set with reset command
  tests: shell: cover reset command with counter and quota

 include/cache.h                               |  12 +-
 include/netlink.h                             |   5 -
 src/cache.c                                   | 165 ++++++++++++++----
 src/evaluate.c                                |   2 +
 src/mnl.c                                     |   7 +-
 src/netlink.c                                 |  78 ---------
 src/parser_bison.y                            |   8 +-
 src/rule.c                                    |  48 +----
 tests/shell/testcases/listing/reset_objects   | 104 +++++++++++
 .../testcases/rule_management/0011reset_0     |  31 +++-
 10 files changed, 283 insertions(+), 177 deletions(-)
 create mode 100755 tests/shell/testcases/listing/reset_objects

-- 
2.30.2

