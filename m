Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09953CE4B3
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776241252; cv=none; b=tYGoFHQZt7LhCdJHz50kkih1x3QTIQ5k2e+Ssh1/seQIrz/IuW8Gz77PTi7nYYHDRvtZ+ZnR1M0aPv8BoJHyKraBP29q/GCTulN2iFcF7Qq2IkikdlLkCr4P7PHf6Kl/hB09StjuntOUvRg22dnbxQFSoWaUV0VyzwkV9KoVz8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776241252; c=relaxed/simple;
	bh=lRYidYLkPnZz+p5075EonPA6T7+6f4qBKv3r9NuuMNc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WTurnvQ5FaDmKXhcegt/yTqnavfoOgwuQG1mvN2XmBaOXIneBuav1oEKOwuer0BJMe+qO/9+qZNgk8Wzuf+HszSpAfA8FuveheIpamR9UYo+gSa3g+z+gMYLP9icfsAb2Nqplxy/ZBOL6YXTVNJUiG7tldsJwyvVBrBI0tMfirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=mQRrFKMj; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="mQRrFKMj"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4fwYxP4wx3z3sb9B;
	Wed, 15 Apr 2026 10:20:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1776241239;
	 x=1778055640; bh=Cj5ypcYX4abMajpOuB/KBgq2MXNK4NCt8v6LzouYick=; b=
	mQRrFKMjs+WDQ1CmSVdqiCU1kY3Zy3sVrbkp3Of4RkETuZdXTnB+pvV9Rz7Uar9x
	EXlO9GK9dZk6a9b40qsAPee1cCJE/eyfVOfltfQuvN6AhXe8ppphgBrQ6LKGCvYa
	BOQ7Uiq/oe1G76iouTtAygP+RXujFOA2SrsokZ1C6S0=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id rtjmnCVdVsL5; Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4fwYxM5F92z3sb8s;
	Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A9D8A34316A; Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/2 v3] netfilter: ipset: concurrent add and dump fixes
Date: Wed, 15 Apr 2026 10:20:37 +0200
Message-Id: <20260415082039.4133308-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo, Florian,

Please consider applying the next patches:

* Fix a data race between add and list in all hash types due to setting
  the position index too early.
* Fix a data race between add and list header commands in all hash types=20
  by protecting the list header dumping part as well.

Best regards,
Jozsef

The following changes since commit a9d4f4f6e65e0bf9bbddedecc84d6724999197=
9c:

  net/mlx5: Update the list of the PCI supported devices (2026-04-06 19:1=
7:42 -0700)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 90262ae5b482a4bfb9282c

for you to fetch changes up to 90262ae5b482a4bfb9282c19f035aafcc7ac9af2:

  netfilter: ipset: Fix data race between add and dump in all hash types =
(2026-04-15 10:16:33 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (2):
      netfilter: ipset: Fix data race between add and list header in all =
hash types
      netfilter: ipset: Fix data race between add and dump in all hash ty=
pes

 net/netfilter/ipset/ip_set_core.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)
