Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C7214831F;
	Tue, 24 Dec 2024 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735083085; cv=none; b=h9WGtbPdgVMvsCSvqexMF9SVW9hdpamJoMbXrZ2I7zy7qZZi+fQPWIFjCzC+qJCG/x5SofyrfDEUn7ERFlhieYvEkkqZlhUnxsTznYBZO36xkNWMXPhZ2O3HfZdlTsaLDFwK/D+t956YtodShgYHc+ec7XlXnUMRZzA++yKaHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735083085; c=relaxed/simple;
	bh=cYVwcGo+Duf1Kot+jfv45Ww78pyx4uwT0O2MyJ/wt+s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iicyYdWBfpcQ/BE33i5iUeexUurl2/mI2APZXza/3js5oUW80zxp70z6EiffwDNVMgHF/w+z/cofPMJoqtXzoSi9u8Och9loWHIwMFRZj3yQkVuI4MzW5gq24bZI+gNO444a6bWhIupWX0+qdqANmwQI70SRGaJMm9L3ipxE+YM=
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
Date: Wed, 25 Dec 2024 00:31:08 +0100
Message-Id: <20241224233109.361755-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains one Netfilter fix for net:

1) Fix unaligned atomic read on struct nft_set_ext in nft_set_hash
   backend that causes an alignment failure splat on aarch64. This
   is related to a recent fix and it has been reported via the
   regressions mailing list.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-12-25

Thanks.

----------------------------------------------------------------

The following changes since commit b3a69c559899b00ca106767c873680b0adf5882c:

  Merge branch 'mlx5-misc-fixes-2024-12-20' (2024-12-23 10:54:07 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-12-25

for you to fetch changes up to 542ed8145e6f9392e3d0a86a0e9027d2ffd183e4:

  netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext (2024-12-25 00:27:49 +0100)

----------------------------------------------------------------
netfilter pull request 24-12-25

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext

 include/net/netfilter/nf_tables.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
