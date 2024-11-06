Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2DE20D4FE;
	Wed,  6 Nov 2024 23:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730937540; cv=none; b=efVgYW97uqtWyELtaxTiux3Ul8j4T1jc+h1ks7S6P9wEMiM9CpKqC6wnQKLlUIOrFqyHoIPOMjLUEjKU7wMF9AEneNqEdeJjHvRQIpZ/j5HIh6jzhcIanreih8Fh6Y5CaE5IWU6CvvPM1tL2nqo7ls+Tzjb6ZgmXhfbNTR3W7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730937540; c=relaxed/simple;
	bh=q2LvVPAr/GfWckE3bCoqCkNBg2XnTKszJN05Dyo95fo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ei56HOuG+4rsTmmIBn9x5ajYhLrbKJXLNjuSBom1xM2Dm5StCAzKTSDOT+7GXmPQedHrVrpPvh7yr9sESbcqZadoHGwP5+oizVqdnI35o8dH+oXrSqFJwHOZCSBUcTOtYIRbebZicjPDDwRZsB/9IMPiyVnVQJtXrZQtjzfoAqo=
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
Subject: [PATCH net 0/1] Netfilter fix for net
Date: Thu,  7 Nov 2024 00:58:52 +0100
Message-Id: <20241106235853.169747-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains a Netfilter fix:

1) Wait for rcu grace period after netdevice removal is reported via event.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-07

Thanks.

----------------------------------------------------------------

The following changes since commit 50ae879de107ca2fe2ca99180f6ba95770f32a62:

  Merge tag 'nf-24-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2024-10-31 12:13:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-11-07

for you to fetch changes up to f22c3a7be6bbbfb2342ae7b21312cbfc12c7f632:

  netfilter: nf_tables: wait for rcu grace period on net_device removal (2024-11-07 00:51:19 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-07

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_tables: wait for rcu grace period on net_device removal

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 41 ++++++++++++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 7 deletions(-)
