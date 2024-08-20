Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA931BE228
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 22:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192022; cv=none; b=pPLOJ7hapjjuHrq/GnIMl+7kExezo7sFJWJVubQdrSb8v7HkMfGJzi/sr94dK0jFW/f4LgCOWDZVa4e/aSUnJmaBMOCkq1lbCw/y2YB7GiZ6kHwwvVFZecvFuGayjREQZFdAb3jF49CG5hHJQhjV3+FyQRlJM52Jceg1gDeDyUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192022; c=relaxed/simple;
	bh=VfL2SRf89ZSvdh/LkG7ZTHn189SXBOZJrtL/eDyX1vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nt8WyN5eRMLbcC+BwlkwR3BSH45kEGgg+5DwD2o1ZoEbV8Fvr+fdnplrh1WWG4pHQ0P9/vs5gm2xHqBUKITm8+1VMtS2cJrSRs4GdrdRwj1+ZKWnfkkWG6yMAUXEh/NfUn6lhscyyI/Y51pVtl0T1pdXnCsdRdvKeIgUDEK/2HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgX6Z-0002MT-HG; Wed, 21 Aug 2024 00:13:31 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/2 nft] mnl: query netdevices for in/egress hooks
Date: Wed, 21 Aug 2024 00:12:25 +0200
Message-ID: <20240820221230.7014-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset adds a new iterator helper that allows to query
the existing interface cache.

Then it extends 'list hooks' to automatically query all active
interface for netdev hooks.

This is done for 'list hooks' and 'list hooks netdev'.
If a device name is given, only that device is queried.

Florian Westphal (2):
  src: mnl: prepare for listing all device netdev device hooks
  src: mnl: always dump all netdev hooks if no interface name was given

 doc/additional-commands.txt |  8 ++---
 include/iface.h             |  2 ++
 src/iface.c                 | 17 +++++++++++
 src/mnl.c                   | 58 ++++++++++++++++++++++++++++++-------
 4 files changed, 71 insertions(+), 14 deletions(-)

-- 
2.44.2

