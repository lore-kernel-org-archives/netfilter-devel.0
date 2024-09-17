Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFA134CE5;
	Tue, 17 Sep 2024 20:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604756; cv=none; b=NMy0A5rntaqyk0iIytBc8Xfzu6BuAm6YK3Z9FlPjcQHZKdcmHuiZnkhDGz46DTaFXX+IWSk1WBrplggAQk7Hd+VRNfkNpN7MtpgG5e4EdEmGCAWyIOfWnCWEooWrS5+K+N4elKfIY/g4q03vIjEKDchdapHKheN/LSHEbOAwoeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604756; c=relaxed/simple;
	bh=Uwr/sqI/FZya9GTLAPzgh6wNFwjXmOENwrMgZkkiDYs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AL6pZXk3I5jCE/x1IczeIlqiPYmUNT9oQfBh8Ys+owGUcaUmSBzK1Np0vHHcRydS4ewICaKmdWVDePwF3EdR8xu1lxS8FyXLtYgGf8PXlyiV8Ag9oX0gMw9kn/jwMgX+JYMJf2bv4564VD9bU11WLffK6UI5wgLW9aPZH/aVzvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 0/2]  Netfilter fixes for -stable
Date: Tue, 17 Sep 2024 22:25:48 +0200
Message-Id: <20240917202550.188220-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for fixes for 5.10-stable:

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")

2) efefd4f00c96 ("netfilter: nf_tables: missing iterator type in lookup walk")

Please, apply,
Thanks

Pablo Neira Ayuso (2):
  netfilter: nft_set_pipapo: walk over current view on netlink dump
  netfilter: nf_tables: missing iterator type in lookup walk

 include/net/netfilter/nf_tables.h | 13 +++++++++++++
 net/netfilter/nf_tables_api.c     |  5 +++++
 net/netfilter/nft_lookup.c        |  1 +
 net/netfilter/nft_set_pipapo.c    |  6 ++++--
 4 files changed, 23 insertions(+), 2 deletions(-)

-- 
2.30.2

