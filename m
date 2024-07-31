Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139EE1B140E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445758; cv=none; b=myGQmk4WZ+oVydIRJZVjNc+iC5aS1nYdoehhvs/K5WhS7tO/WUp6lPlJf+WuEkp3PQ6vYjheTkdA6YLSfeGWFinbAaNq5i3oRIOiB2Nd9BCDHFePaqLL1LLmU5sHg/t3MHwcopZdyEyTHcg5WoEsDmdkjbE0H8YQhatQPHnoDyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445758; c=relaxed/simple;
	bh=d6pmGhfxcpn48YnI4VN4u39x6Hx/ekyxst0N+wze+J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sUB/5gQOzQ6pkMuTDQyE72p5QE6Oz0z5uzh1H3fpXcBNwqUkBptevGVEDQD8Ts6s/KCMtjGPidhEeKDW/cClPfSezF1vQiXdE0663JEm7PQwrI17dX/HRDQMQBcN+txPri1eQfe3OLAZ5OMh/aSODc+eRP1yiCoDtzGlYO+6V7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCp2-0006xr-Hh; Wed, 31 Jul 2024 19:09:08 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 0/5] src: mnl: rework list hooks infra
Date: Wed, 31 Jul 2024 18:51:00 +0200
Message-ID: <20240731165111.32166-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Turns out that not only was 'nft list hooks' mostly undocumented,
there was also confusion on what it should do.

First, clean this code up and make it strictly a tool to dump
the NFPROTO_X registered functions.

Then, remove the 'hook' function argument, this was still passed
from back in the day when one could ask to only dump e.g.
ipv4 prerouting.  This ability is of little value, so don't restore
this but instead just remove the leftover code.

Next, allow dumping of netdev:egress hooks.
Lastly, document this in more detail and make it clear that this
dumps the netfilter hooks registered for the protocol families,
and nothing else.

Once this gets applied I intend to make
'nft list hooks netdev'

dump device hooks for all interfaces, if any, instead of a
'no device provided' warning.

Florian Westphal (5):
  src: mnl: clean up hook listing code
  src: mnl: make family specification more strict when listing
  src: drop obsolete hook argument form hook dump functions
  src: add egress support for 'list hooks'
  doc: add documentation about list hooks feature

 Makefile.am                 |   1 +
 doc/additional-commands.txt | 116 ++++++++++++++++++++++++++++
 doc/nft.txt                 |  63 +--------------
 include/mnl.h               |   2 +-
 src/mnl.c                   | 150 ++++++++++++++----------------------
 src/rule.c                  |   6 +-
 6 files changed, 179 insertions(+), 159 deletions(-)
 create mode 100644 doc/additional-commands.txt

-- 
2.44.2

