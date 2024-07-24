Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119F24D8BD;
	Wed, 24 Jul 2024 08:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721808804; cv=none; b=TafqdgEi34qJdybu7K1sPew/I83jfuX10tMVQilIzSGpREBXtdtyfHwAMbBA+ykiqzuxS08aRy9j3HuZH47clEoomDjZ9hr7nvEF9NVTFdcGcOJ0t8KoeLOI5hgSSO3xdTgN48QA6hppQGsLvP6EFmrTAzsCNvuQPlcGu4dv+5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721808804; c=relaxed/simple;
	bh=dq+YmKlani4jyAN+X0TsbQ3oj3zkj0fagKlUk1cWFbg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U2vtQI5g8e0s1wEt891H6xGFylVYobHEw+2OPkztvJ5UDdz7hsoqf6soKY7SVE3MSzYIFewZ3wras1FkKGQw1/9XHaSzCU7yTHiPfP2emYONBHbSndA84Q4CSYPHMSGiazxFz/zaRVzVxqwLPjQpIKnJ2aNcDgVULOFMSfjT8Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/1] Netfilter fixes for net
Date: Wed, 24 Jul 2024 10:13:04 +0200
Message-Id: <20240724081305.3152-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains a Netfilter fix for net:

Patch #1 if FPU is busy, then pipapo set backend falls back to standard
         set element lookup. Moreover, disable bh while at this.
	 From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-07-24

Thanks.

----------------------------------------------------------------

The following changes since commit 3ba359c0cd6eb5ea772125a7aededb4a2d516684:

  net: bonding: correctly annotate RCU in bond_should_notify_peers() (2024-07-23 15:13:12 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-07-24

for you to fetch changes up to a16909ae9982e931841c456061cb57fbaec9c59e:

  netfilter: nft_set_pipapo_avx2: disable softinterrupts (2024-07-24 10:01:59 +0200)

----------------------------------------------------------------
netfilter pull request 24-07-24

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_set_pipapo_avx2: disable softinterrupts

 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)
