Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37063451BB;
	Wed, 25 Feb 2026 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024787; cv=none; b=JUXFbgipATb/qGl7ZKZff5Eir7/U5+5+USxXQzOMQZxghT+DetmIoNjdsFRjfpFn+zGG9qP3HjtuH7/Q2o1wzL+CQ1xyamPdnRuGUZmR5t6WMBsD/opx4OVGo3PcCBxMS5wcXBxjc2pyyT7Y0KNa5gZRXLy/rJNeWAQkhiKO25Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024787; c=relaxed/simple;
	bh=ZgVMOPKKa0qOx9GWGkh/PozdjLg/KEB0xGqaufFLIVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oht0RzDFk187SwRpXcWQ/OtMw894yqHx05tXUpIt8ybIvAv52warRxHpPEQcuV5ilgX4TUQAHG1svcMW/axodav9jsh4DGIv/k1/F+F/d5EXviZJI0Ak7oF/ZFlel75hS+Bo7EDijfKa5rQyBNe+8vG9QV73VyyUusPcZvuvrXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8246160CFF; Wed, 25 Feb 2026 14:06:23 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/2] netfilter updates for net
Date: Wed, 25 Feb 2026 14:06:17 +0100
Message-ID: <20260225130619.1248-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This batch contains two bug fixes for the *net* tree:

1). The H323 conntrack helper has an OOB read bug, it should
    ensure at least 2 bytes are available before extracting the
    length.  From Vahagn Vardanian.

2). Inseo An reported a use-after-free in nf_tables.  Incorrect
    error unwind calls kfree() on a structure that was previously
    visible to another CPU. Fix from Pablo Neira Ayuso.

Please, pull these changes from:
The following changes since commit 2f61f38a217462411fed950e843b82bc119884cf:

  net: stmmac: fix timestamping configuration after suspend/resume (2026-02-24 17:46:15 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-02-25

for you to fetch changes up to e783189e0f6ccc834909323e0b67370ad93bb9c6:

  netfilter: nf_tables: unconditionally bump set->nelems before insertion (2026-02-25 11:52:33 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-02-25

----------------------------------------------------------------
Pablo Neira Ayuso (1):
  netfilter: nf_tables: unconditionally bump set->nelems before insertion

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

 net/netfilter/nf_conntrack_h323_asn1.c |  2 +-
 net/netfilter/nf_tables_api.c          | 30 ++++++++++++++------------
 2 files changed, 17 insertions(+), 15 deletions(-)
-- 
2.52.0
