Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01FA1AE00E
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731618837; cv=none; b=qS51dvBJD8pHrflwsxl4HFz355MtaBnMgEHSpbiqUJExWl7OJL9K1ZnA1csS6d5zCA4Tp6ruwmPC9PYNZuOYFXWrpimBJxG3yz3OTe7dyiwQ/AfNfKlB2Xy1N1nsTNMsg6rNGj+ljlaGf/FPol4B6rFenSOig96BERJljayNFwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731618837; c=relaxed/simple;
	bh=i7Ok1vymPuVpzsu/dR8GV9BWCLQ7KW92pGZp9YA9GP4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sFW4YyrrvFVkTrf97CFCMkRvtOMYAO+B7DFoHx562ggxfCIfRKWLN0KFOTLZUIML3NPKt1bFneZmPy1wB3L8Sr+FwsoO6LK5U1JideaF5Nf+CYzGD7w95YEokhzjEP185QKr451p4OIYkpZfhW+X/Wj4wj76jUU4wmRftR91hhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH nf-next 0/2] nftables bitwise multiregister support
Date: Thu, 14 Nov 2024 22:13:45 +0100
Message-Id: <20241114211347.24700-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is just a rebase on top of nf-next of Jeremy's patchset.

I am in the process of reviewing Jeremy's work in userspace including
enhancements.

Jeremy Sowden (2):
  netfilter: bitwise: rename some boolean operation functions
  netfilter: bitwise: add support for doing AND, OR and XOR directly

 include/uapi/linux/netfilter/nf_tables.h |  18 ++-
 net/netfilter/nft_bitwise.c              | 165 +++++++++++++++++++----
 2 files changed, 154 insertions(+), 29 deletions(-)

-- 
2.30.2

