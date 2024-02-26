Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C62C4C70
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958048; cv=none; b=lJx1zr6q7Ey8OYSd+NVHruVRTTBf9/dDl6cvfAxUrUU/Kn/0DVHgKYmn+pgMOcWM/Vbay/lBu2xEoTCCtcZaF1Req/asUMpfRh+ODxO0JBt/JyewWc2VPpt7YVDu8MpfHIpgTRGZcjm36MfgyOYtEdLzy+H59e23mVKsB2NonvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958048; c=relaxed/simple;
	bh=FvsKrQbR70xdBF39MXD/iqbNJtg5euwSj9MRWNPTNKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QX4fhGE2NYaKLhFK+SoqlJgx+IWxCrE3Sa6zaLZawFIZvmT8o3H3lFZVuabP/ygiYwYB49Ita8g6H7EvRUV9CO2yt2ez9NGChIZSbRQRZM9JgbiAj5eOgtDlNIfL9kY+8MGh+bg+5wKot35NXPquhbpNPlWu4e7KlvhbuloLNAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rec3P-00032d-9E; Mon, 26 Feb 2024 15:34:03 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/2] netfilter: bridge_netfilter:
Date: Mon, 26 Feb 2024 15:21:46 +0100
Message-ID: <20240226142151.4670-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a day 0 bug in bridge netfilter when used with
connection tracking.

Conntrack assumes that an nf_conn structure that is not
yet added to hash table ("unconfirmed"), is only visible
by the current cpu that is processing the sk_buff.

For bridge this isn't true, sk_buff can get cloned in
between, and clones can be processed in parallel on
different cpu.

First patch disables NAT and conntrack helpers for multicast
packets, second patch adds a test case for this problem.

Florian Westphal (2):
  netfilter: bridge: confirm multicast packets before passing them up
    the stack
  selftests: netfilter: add bridge conntrack + multicast test case

 include/linux/netfilter.h                     |   1 +
 net/bridge/br_netfilter_hooks.c               |  96 +++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c    |  26 +++
 net/netfilter/nf_conntrack_core.c             |   1 +
 tools/testing/selftests/netfilter/Makefile    |   3 +-
 .../selftests/netfilter/bridge_netfilter.sh   | 187 ++++++++++++++++++
 6 files changed, 313 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/netfilter/bridge_netfilter.sh

-- 
2.43.0

