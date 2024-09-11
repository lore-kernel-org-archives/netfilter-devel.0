Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBA91885A8;
	Wed, 11 Sep 2024 22:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726093535; cv=none; b=bKcGWLvR5SgWdJpXNhVAWNWVeONe+gTUUE84myb6eWSZfzzBahyj7qa8KtdsD4UTngTbkXQA7r1CudhbUrBm8216KPC0NFy7KVhEXiS5K5x/okNk+v+LbwUkoIBg9wRpNJFU0O2G7EC3zoYSDFXetiNYEZcDTBWK4hzP7GjI0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726093535; c=relaxed/simple;
	bh=6l4+mdX9jF0qzzwZ/i+JIt707Jd481DQuvHJYsXOcBU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TYS0+cqv2cJj31GEtbWfrwbzi/0MV1T/mfT3Q4zhsdnN8arwtk3LC6YRUxKm6ptSsmgF64NfdvrbKQLvZjzOpUU32IMOq0BBo4fcN9NrGxIpLEuc64ruHsxS70yW3dj1yaold6hP1TRSQLq2AdeRgNfNG/M9hlOX945zaKaj0jE=
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
Subject: [PATCH net 0/2] Netfilter fixes for net
Date: Thu, 12 Sep 2024 00:25:18 +0200
Message-Id: <20240911222520.3606-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains two fixes from Florian Westphal:

Patch #1 fixes a sk refcount leak in nft_socket on mismatch.

Patch #2 fixes cgroupsv2 matching from containers due to incorrect
	 level in subtree.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-09-12

Thanks.

----------------------------------------------------------------

The following changes since commit d759ee240d3c0c4a19f4d984eb21c36da76bc6ce:

  Merge tag 'net-6.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2024-09-05 17:08:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-09-12

for you to fetch changes up to 7f3287db654395f9c5ddd246325ff7889f550286:

  netfilter: nft_socket: make cgroupsv2 matching work with namespaces (2024-09-12 00:16:58 +0200)

----------------------------------------------------------------
netfilter pull request 24-09-12

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nft_socket: fix sk refcount leaks
      netfilter: nft_socket: make cgroupsv2 matching work with namespaces

 net/netfilter/nft_socket.c | 48 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)
