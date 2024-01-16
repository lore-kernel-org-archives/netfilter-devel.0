Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6811C6B0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2024 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="OU7noT1u"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 55C9ECC02C2;
	Tue, 16 Jan 2024 17:29:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1705422597;
	 x=1707236998; bh=PLmW9+rsMQfORnoxPX10xwfEeerrfD7c7gtFg0vLXq8=; b=
	OU7noT1uUVPJ2wWHFk0u+QOnwLItBrMP7O1V10LaeYv4w1oOcMLkBQkmzBXQPnc0
	YF8JeqKPhSd7c4DvaLxvcqDpvsRXz9Ox25tqn1+JXXgd4EF4IRb0pTXgPV9xma/W
	yQuRQfQSQisAO/hAF7BlySOYwt09lQh01eHZXG1xrDI=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue, 16 Jan 2024 17:29:57 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0CC38CC02BD;
	Tue, 16 Jan 2024 17:29:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 05D34343167; Tue, 16 Jan 2024 17:29:57 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>
Subject: [PATCH 0/1] ipset performance regression in swap fix
Date: Tue, 16 Jan 2024 17:29:55 +0100
Message-Id: <20240116162956.2517197-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Please consider to apply the next patch to your nf tree. It should be app=
lied
to all stable branches to which the patch "netfilter: ipset: fix race con=
dition
between swap/destroy and kernel side add/del/test", commit 28628fa9 was a=
dded.

* The synchronize_rcu() call added to the swap function to prevent the ra=
ce
  condition makes it too slow. The race can be prevented by using call_rc=
u()
  in the destroy function instead.

Best regards,
Jozsef

The following changes since commit ac631873c9e7a50d2a8de457cfc4b9f8666640=
3e:

  net: ethernet: cortina: Drop TSO support (2024-01-07 16:05:00 +0000)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 9833c7d18f7065c2

for you to fetch changes up to 9833c7d18f7065c2ef31aae67973bcb198d761bc:

  netfilter: ipset: fix performance regression in swap operation (2024-01=
-16 17:19:19 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix performance regression in swap operation

 include/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_core.c      | 31 +++++++++++++++++++++++-----=
---
 2 files changed, 25 insertions(+), 8 deletions(-)
