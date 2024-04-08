Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628FC1487CE;
	Mon,  8 Apr 2024 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611307; cv=none; b=qK3gkymGN4axJu/2PiVj7yGOspLf1CYiQHMbQ7sBn5Abl/p7WkZdk/Vk6FI0duvuf7mfDbhtnjT7ZmpLvaf93VpKXzAJo9LRwmnZc+IpOltfaeWome1cNKxPRve0WSscJJFKi6m04I0MpM1aEM2UwyVnmkWs7/hG2v9YYZ038zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611307; c=relaxed/simple;
	bh=tFjiiQufQV4VelbCmcbvWZoWarnXgUMt9Op+4wgmTAo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ts1d2Fba4GEr9OmgtJrYsOlxWVsBNrlMXQyDAmYezPqw78BwmrAJ68taavzqGt5aHiEwV44kHEkeLEdO3BcFcSxEx5JxY8dWe8OgyQEF9RxatbTvAyum6vMkXEfIOWLw8cTi36E+ou7ObToqRD7NX0VQQiimAIPJpnD1E+Sl76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Subject: [PATCH -stable,5.4.x 0/5] Netfilter fixes for -stable
Date: Mon,  8 Apr 2024 23:21:37 +0200
Message-Id: <20240408212142.312314-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for recent fixes already upstream for 5.10.x,
to add them on top of your enqueued patches:

994209ddf4f4 ("netfilter: nf_tables: reject new basechain after table flag update")
24cea9677025 ("netfilter: nf_tables: flush pending destroy work before exit_net release")
a45e6889575c ("netfilter: nf_tables: release batch on table validation from abort path")
0d459e2ffb54 ("netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path")
1bc83a019bbe ("netfilter: nf_tables: discard table flag update with pending basechain deletion")

Please, apply, thanks.

Pablo Neira Ayuso (5):
  netfilter: nf_tables: reject new basechain after table flag update
  netfilter: nf_tables: flush pending destroy work before exit_net release
  netfilter: nf_tables: release batch on table validation from abort path
  netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
  netfilter: nf_tables: discard table flag update with pending basechain deletion

 net/netfilter/nf_tables_api.c | 51 ++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 10 deletions(-)

-- 
2.30.2

