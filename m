Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426928C842;
	Wed,  7 May 2025 22:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746656409; cv=none; b=fbOCsYxoDhLqL5jjHhPZBQ0cyKkQguRAnsuUuJ8R27ZwacoG6kkUYCUrSUjvVwhQIjE60w8erbZjiYJWQ+hHQ+E7i/KwzLaVClfMFZ8jtx2W0rtXDbypERxLSgbdv0lqlwyQPeEQtfi4k4yflQsSixymi8UJ2i34HsokfvB6AyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746656409; c=relaxed/simple;
	bh=3vhsKSoxBtrgsdtI3vEK+p48SwPOyqIo6kmaP7qy7jg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ChHZYI5hxID4HG3rfSBQAM/GXTXaersXs6nl9cWG3rkSUdQnHInw6sI6wrkkAFdUnIvG8VikFbQ/NsvRVmRUmFeGJRt5+EZQzUe30Pvx9jI1QrxJGVoZAG8DbiX8iI+qssVqXle36tx1qDihAsvW1KVayvnvcduHa8/J6s4SVBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SsIsgnu+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T/vi+AoY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SsIsgnu+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T/vi+AoY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D03CA602CF; Thu,  8 May 2025 00:19:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656398;
	bh=D6Yez+xoBcGpuIjAGVDKDFIugAZYUZ+hlcAH0bP1jfk=;
	h=From:To:Cc:Subject:Date:From;
	b=SsIsgnu+u2Wa5zXnXzf7rPoZJ15p1KMWkwdAX0GGIVC1dvwV++vHSAwh7mrjxY5w0
	 kdJMYWPmGXTAPEaq/YxyfqlA2P3m5NhkiEenUQMx3oZUpvgmCJtdyqwGqchtxvDURH
	 InKqrEAxZ1gZPXy+U0NrQA63YqmaOscipae1izEpmdEAGsbw6Hw79fCSmqOEhdPimm
	 gbdQ81r+5xVxw2agZLD/QCL/vfvVAzu9FTGcs1pKrDAl8+ahoG1idvk4R9NylZ6QNT
	 /0TyATxhWBDGGvCH8DLhMm0Cq5UX2IYsontAgPfCgYDd3jXHEupOvUOFfJgAahnY6Y
	 uXsPKiB3dIVnw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6495602C4;
	Thu,  8 May 2025 00:19:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656397;
	bh=D6Yez+xoBcGpuIjAGVDKDFIugAZYUZ+hlcAH0bP1jfk=;
	h=From:To:Cc:Subject:Date:From;
	b=T/vi+AoYr9D+Xd9RyqEsezQhsm3c9Bnmo1dQfH4qP/bqT8ION1oogkq/TkENEmFxO
	 K5O/kA2YIFLWhFHwdzJc4MasbWmGZh6YrRNekTH3GdNr6ADBvKll0JjfzTBH2viTxU
	 nWIKjCH0++75tbIMHUDI15mTjIRMVv3jzFCpmyM1FrKKvS6agBUjT2OfTlfWqR7id5
	 rqUPowh46Fot9FBAln0R72Yi+3/4XzwdKbj5oaUryovQuF2xFSRbKnGhlmwotXnzR3
	 zDXeQjr7JqQbUg9a8bfCSIWs2uVWHFZiCsH8H+JoAHECnKkfydVsCDfAKCVbDonXJ1
	 IT51fHZzFg0ZQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/2] Netfilter/IPVS fixes for net
Date: Thu,  8 May 2025 00:19:50 +0200
Message-Id: <20250507221952.86505-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contain Netfilter/IPVS fixes for net:

1) Fix KMSAN uninit-value in do_output_route4, reported by syzbot.
   Patch from Julian Anastasov.

2) ipset hashtable set type breaks up the hashtable into regions of
   2^10 buckets. Fix the macro that determines the hashtable lock
   region to protect concurrent updates. From Jozsef Kadlecsik.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-05-08

Thanks.

----------------------------------------------------------------

The following changes since commit 9540984da649d46f699c47f28c68bbd3c9d99e4c:

  Merge tag 'wireless-2025-05-06' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2025-05-06 19:06:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-05-08

for you to fetch changes up to 8478a729c0462273188263136880480729e9efca:

  netfilter: ipset: fix region locking in hash types (2025-05-07 23:57:31 +0200)

----------------------------------------------------------------
netfilter pull request 25-05-08

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix region locking in hash types

Julian Anastasov (1):
      ipvs: fix uninit-value for saddr in do_output_route4

 net/netfilter/ipset/ip_set_hash_gen.h |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c       | 27 ++++++++-------------------
 2 files changed, 9 insertions(+), 20 deletions(-)
