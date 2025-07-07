Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC8290D8C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 09:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751881661; cv=none; b=XUQIfeTqiXoELaAraavGg6cfH/fPyz4ahGzUhiBW3Cnzt8XnJbdtJrpA7sJ/cis/m7mR1hb1iuNlMoblV9pRunaq0KcmVtQp5/cuUtOE0Xgh3XFPNY2EVZihvVwD9Yu5+ffjjzxj8Dqhu790i1YbOQC/sLYC75tTmN8C0kuRdGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751881661; c=relaxed/simple;
	bh=oIkn92lgGqIrnaqOwF0j4NKNT1K36neUeRHhy1Fv36I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VOczT6nbMl0jfVrhw6s7b8a1uZF2hbie9yttzcsWJiEXImrJuCqdqv3bRKRqT2YzP4I7+MLHb+2ZQwQontHL0fL/DPiQHOe9od5Y5llHm2gp+6Omz6mhk5Cx03DXwk8t0IQVeYcPEsZZhyrW4/6igEhROIFuFM7FTVhWQvszuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 714216123D; Mon,  7 Jul 2025 11:47:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/2] src: add conntrack information to trace monitor mode
Date: Mon,  7 Jul 2025 11:47:12 +0200
Message-ID: <20250707094722.2162-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First patch is a preparation patch that moves the trace code
from netlink.c to the new trace.c file.

Second patch adds the ct info to the trace output.

This patch exposes the 'clash' bit to userspace.
(Technically its the kernel counterpart).

If you dislike this, I can send a kernel patch that removes
the bit before dumping ct status bits to userspace, let me
know.

Change since v1:
- prep patch to split to trace.c
- add ct status fields to data types

Florian Westphal (2):
  src: split monitor trace code into new trace.c
  src: add conntrack information to trace monitor mode

 Makefile.am                                   |   1 +
 doc/data-types.txt                            |  31 +-
 include/linux/netfilter/nf_conntrack_common.h |  16 +
 include/netlink.h                             |   5 -
 include/trace.h                               |   8 +
 src/ct.c                                      |   8 +
 src/monitor.c                                 |   2 +-
 src/netlink.c                                 | 332 -------------
 src/trace.c                                   | 462 ++++++++++++++++++
 9 files changed, 512 insertions(+), 353 deletions(-)
 create mode 100644 include/trace.h
 create mode 100644 src/trace.c

-- 
2.49.0

