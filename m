Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6EE39F19F
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 08:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783154902; cv=none; b=plGA8/MEPvsBYalPvew6Mb/g86Bp1N/lz4sk3V8zKo2i5McGHudhpZQq/LD81RtWdQwgMZD/RQkl6/0CxnTfaRNy/DdcH36LF4QM/OAeGtANzguqAc4RGZlyCJByfbC8t+uO0RGNGu6Z2k+RpKBhjCp6Fpw800zslmrqQJuQ76c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783154902; c=relaxed/simple;
	bh=7Vg9FyTiaVXousrvSu43Pe+g03Xs4t0IO5jCRDUAJzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IEhyXWkohxgiql8u+M3LH0PBRHLb720PFs4n5+/YfA32IFTQQZE7re7DZclR0BZXCLtF8MyWHZwGJnMov8Ba2aqFT5kdtxWcjPRnTrf7uVN7x/pU8KtqwV/0j4uDWbNyv+xR+wSqB6eGZyimjmoUeG07ynzNKzWv1Ce6tX6I4Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1FBC860491; Sat, 04 Jul 2026 10:48:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: ebtables: shashiko nitpicks
Date: Sat,  4 Jul 2026 10:48:08 +0200
Message-ID: <20260704084811.27355-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three academic bug fixes for ebtables, based on sashiko
drive-by reviews.

All of these "bugs" have existed forever, kets treat this
as cleanups.

Florian Westphal (3):
  netfilter: ebtables: zero chainstack array
  netfilter: ebtables: account compat ebt_table_info to kmemcg
  netfilter: ebtables: bound num_counters in do_update_counters()

 net/bridge/netfilter/ebtables.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.55.0

