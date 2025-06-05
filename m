Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040C472632;
	Thu,  5 Jun 2025 08:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113866; cv=none; b=hhboZuNLPJKX2D6h/WcxmWmUuBTXZlK75JZRjC938SdX9rLq3g+oaZ/W/Bv7WC/rJOUaSlv2gI1Vo0yd5mwokn2YA7G2uDVTv0ZH7CmrwSVrXB5ukaiVGgdiM2DWW0IJj3Sp7QrRx0VqcmBmguCx0KmTr2mKROo5pDDZYtWkvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113866; c=relaxed/simple;
	bh=S+xNIODA+R+IUYokDmx8smSlNYufzN29UtIFU1oaoYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UNYuF23Y6EPjIEr65bW3vzUlqaJZh/ICRZbCd8OM0nwFiHLD14O0HPk9/DAk/CZEN7PtgIEPSIVrePWZDwJONzbFjcxMdCYBEmhdY8jh1v2CogzVY/nR6QflOIXULgA1MJ/z1SoB6rHh+O7z2sag1mC8U1f6CG1mSqOo+0NQEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=icuiKLCK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fsz5Ppbb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="icuiKLCK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fsz5Ppbb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A57946075E; Thu,  5 Jun 2025 10:57:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113861;
	bh=qUNMrLFsFoMupvLBq1NdoJJgt4XruSTMX0Bk0xyxTeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=icuiKLCKNDHcqyhdo2gYFQ0CEJ6Bb4byDjp++ljMADAaPFtrbt2miISGvYUo05e1p
	 o+5/p7Jf4mg23dJfdccseeNxFqwiGxMFvJmM20PenD2srAg8edyEo/AFrkV3zZ6YIa
	 +zOsBiyXKiBSk/cl4DnyP31eJTzPhJn/C37bfxs5twzEcw7pLP5/MtRhFonoNrarKr
	 hLJ+9VYNFhmxizfVZerFnUZhZIGqKl8SGBxuJ+N8P6AqBCqkxIaK6b5uAn/so+Nyiu
	 eQP1FuKjgxyzfchma9GnxkVaQVoK2m8Bg8GpIskTXv59bJILZhIX5BbD43cKjOVh1v
	 x9wrWF216tz1g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2D81760750;
	Thu,  5 Jun 2025 10:57:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113859;
	bh=qUNMrLFsFoMupvLBq1NdoJJgt4XruSTMX0Bk0xyxTeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Fsz5Ppbbhje9lZNAUljVz0CNlNS/sYw/PWxOMkZ5mep3uVeZznUQ3+gq0QlNGFqAN
	 n/+06Y5UAYNatcYkXUb+e0WPqLp+MGxhOkXXDKMePIl7w5V/n2mAun5QzslVKriHP5
	 7ZpfvRVeJZjM0F48WUvrutXfufyH26J546LbmpeutvzOeNYhLXXuls1hl+wxsiv2MY
	 AxthwFBbe2vKjEMZmcbLieGTphedZkpTOFk0iTUir7XsVnWudOqmIbY+cNpI/QyJB8
	 VYRs3l+R/Q+aPIchC9AOzB0t9t8Y+aY1VM1qKqobJsWfYsAqg5V4UCZSHtdiyI/s0r
	 fGW9y4hzc2aVg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date: Thu,  5 Jun 2025 10:57:30 +0200
Message-Id: <20250605085735.52205-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Zero out the remainder in nft_pipapo AVX2 implementation, otherwise
   next lookup could bogusly report a mismatch. This is followed by two
   patches to update nft_pipapo selftests to cover for the previous bug.
   From Florian Westphal.

2) Check for reverse tuple too in case of esoteric NAT collisions for
   UDP traffic and extend selftest coverage. Also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-06-05

Thanks.

----------------------------------------------------------------

The following changes since commit 12c331b29c7397ac3b03584e12902990693bc248:

  gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO (2025-06-04 12:06:13 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-06-05

for you to fetch changes up to 3c3c3248496a3a1848ec5d923f2eee0edf60226e:

  selftests: netfilter: nft_nat.sh: add test for reverse clash with nat (2025-06-05 10:50:05 +0200)

----------------------------------------------------------------
netfilter pull request 25-06-05

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: nf_set_pipapo_avx2: fix initial map fill
      selftests: netfilter: nft_concat_range.sh: prefer per element counters for testing
      selftests: netfilter: nft_concat_range.sh: add datapath check for map fill bug
      netfilter: nf_nat: also check reverse tuple to obtain clashing entry
      selftests: netfilter: nft_nat.sh: add test for reverse clash with nat

 net/netfilter/nf_nat_core.c                        |  12 ++-
 net/netfilter/nft_set_pipapo_avx2.c                |  21 ++++-
 .../selftests/net/netfilter/nft_concat_range.sh    | 102 ++++++++++++++++++---
 tools/testing/selftests/net/netfilter/nft_nat.sh   |  81 +++++++++++++++-
 4 files changed, 193 insertions(+), 23 deletions(-)
