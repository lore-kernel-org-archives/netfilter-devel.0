Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839CE175D2E;
	Mon, 12 Aug 2024 10:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458536; cv=none; b=mhitEzugXI/NoBeZikDxriTEximKbzE9rEzyq+6mXGLCoMlEDAd39xuSj4RKuliZVYc7mowMsyhYaJx+CxtPWlxxOElkzPyLKnFuAefTLlVd1XhR0K5v+kyqWCLEiAHBQVuMS5K/TmS4hUTGD99Bu/QoJlM12KhDGX/5bZl6n3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458536; c=relaxed/simple;
	bh=cuZVklKLu/VAub9s4GsxkJQ3myH79M/UchS28ZB6HTM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qpYfldixYiwigJsMSct/Ttf7g6S+wlCwn4ysQtnAk91cXFQnwjFw3JY3EnjpaC7L3PdvmUJn9dsQz2DfAyFs4iHR1PtwV7fSvNnq1sKrk/Gfl7mvG1tufQV7JiNTH6KDZqiAD4A38fWC7FDEirHNEjS68zfEBBrAtIvu0OpbVhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4.x 0/3] Netfilter fixes for -stable
Date: Mon, 12 Aug 2024 12:28:45 +0200
Message-Id: <20240812102848.392437-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for recent fixes already upstream for 5.4.x.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) b53c11664250 ("netfilter: nf_tables: set element extended ACK reporting support")

2) 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set element timeout")

3) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")

Please, apply,
Thanks

Florian Westphal (1):
  netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso (2):
  netfilter: nf_tables: set element extended ACK reporting support
  netfilter: nf_tables: use timestamp to check for set element timeout

 include/net/netfilter/nf_tables.h |  21 ++++-
 net/netfilter/nf_tables_api.c     | 128 ++++++------------------------
 net/netfilter/nft_set_hash.c      |   8 +-
 net/netfilter/nft_set_rbtree.c    |   6 +-
 4 files changed, 53 insertions(+), 110 deletions(-)

-- 
2.30.2

