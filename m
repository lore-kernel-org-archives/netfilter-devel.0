Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E146444
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 09:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961732; cv=none; b=juroITnbypvwff2y8JOPQMRCAVxSyzyNbEAwlhHF/ehECbPE/+zj2+jIqKWFcgkDUccFTca4TZKgm1Rq5PYNEk/SNa0XjwDX/7Vybei1DgQaOT/Za/esV9Q3htuByaSgjmP3kdS4VMm708peaUV6xLRFvLx/fq6HkEODTnTvJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961732; c=relaxed/simple;
	bh=8eaDIOtTLUXJ7vyhOOpKEo/YwUWp2aklxuijc009sRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SOxaPYsMgsXfSqe39UP4B+sjXf1eh8xy3ryNy8qDxV9MlH/xkcxvgIdjcOYPMoutEscYrRwsve28MXsaA0CEeBExlsJp3DqB4AXoq00WWk5/ze1aOkdHBl58naWweOOjsYNRms0OOEd4wCiAQBihwGiUjiO7tYAT5L7QnZgk4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1snxUN-0002Fc-MD; Tue, 10 Sep 2024 11:48:47 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack: clash resolution for reverse collisions
Date: Tue, 10 Sep 2024 11:38:13 +0200
Message-ID: <20240910093821.4871-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series resolves an esoteric scenario.

Given two tasks sending UDP packets to one another, NAT engine
can falsely detect a port collision if it happens to pick up
a reply packet as 'new' rather than 'reply'.

First patch adds extra code to detect this and suppress port
reallocation in this case.

Second patch extends clash resolution logic to detect such
a reverse clash (clashing conntrack is reply to existing entry).

Patch 3 adds a test case.

Since this has existed forever and hasn't been reported in two
decades I'm submitting this for -next.

Florian Westphal (3):
  netfilter: nf_nat: don't try nat source port reallocation for reverse
    dir clash
  netfilter: conntrack: add clash resolution for reverse collisions
  selftests: netfilter: add reverse-clash resolution test case

 net/netfilter/nf_conntrack_core.c             |  56 +++++++-
 net/netfilter/nf_nat_core.c                   | 120 ++++++++++++++++-
 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../net/netfilter/conntrack_reverse_clash.c   | 125 ++++++++++++++++++
 .../net/netfilter/conntrack_reverse_clash.sh  |  51 +++++++
 5 files changed, 347 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh

-- 
2.44.2

