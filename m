Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0340055E50
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706522235; cv=none; b=Bnfid5M3z1UUS4+MCrgBjALgjrSOn4rsuPfsFXADvMUFVGz25mflHU8Yf4OcHOIqVE4VcfIAZ5v9jxJO/nOolNXQa1mZd0hMFm4T3gOCi4OCrS4J8hMION2tLFYKUatgZL9V4plVV2ouMPnsVPdLlMn+HnMM32sGxcJvoNSvzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706522235; c=relaxed/simple;
	bh=m3/0zDDu5uwe5MxhFWJrcw+ChwbyUZMWoMKOqtLTSQE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fMm0klw1xNOnnT8ec6rb6gm96lsl0gKP8NRFo3ykOPbbPe5Aak9TOyoM3KeD3lyZJpEhWQsNyXwiHQ6EYFgBzTNCSjZKbLIXDNTfsdjvCHIVf8OYsF+QeDnByDMkLwukvf5wYW5uA+gLcOTcZj0yIOFOoxMipcSGBgPp9/OUvrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=DrKXjp8Z; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="DrKXjp8Z"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id C4104CC02B6;
	Mon, 29 Jan 2024 10:57:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1706522221;
	 x=1708336622; bh=H2GLFBLUHAUI4rC43oFy/mbJnQhxkzGYjMCG1hDz2OA=; b=
	DrKXjp8ZYFTBkSGiyP5WofnPfle4pmvqy/YNDQBqgCMGzSwmIjAi+APnpbaHIIlf
	y2k3qTuZmbUAGvzKnPhGQPtmU0hmmGom97f0QtOVKoVqR4zUJoKbY0gyJK8uYwaf
	nXt/K+rTqoLuD1A9o9AOYggMzzPKz6kbQw7Xr3yTspY=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 29 Jan 2024 10:57:01 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id B0E13CC010D;
	Mon, 29 Jan 2024 10:57:01 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id AA09D343167; Mon, 29 Jan 2024 10:57:01 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 0/1] ipset performance regression in swap fix
Date: Mon, 29 Jan 2024 10:57:00 +0100
Message-Id: <20240129095701.388482-1-kadlec@netfilter.org>
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
  in the destroy function instead. However those function calls cannot wa=
it,=20
  so cancelling garbage collectors are separated to individual function c=
alls
  to execute them first, outside of the call_rcu() functions.

Best regards,
Jozsef

The following changes since commit ac631873c9e7a50d2a8de457cfc4b9f8666640=
3e:

  net: ethernet: cortina: Drop TSO support (2024-01-07 16:05:00 +0000)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf fdb8e12cc2ccb5e06a

for you to fetch changes up to fdb8e12cc2ccb5e06af6bcd68ba578b60807bcf6:

  netfilter: ipset: fix performance regression in swap operation (2024-01=
-29 10:47:14 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix performance regression in swap operation

 include/linux/netfilter/ipset/ip_set.h  |  4 ++++
 net/netfilter/ipset/ip_set_bitmap_gen.h | 14 ++++++++++---
 net/netfilter/ipset/ip_set_core.c       | 37 +++++++++++++++++++++++++--=
------
 net/netfilter/ipset/ip_set_hash_gen.h   | 15 ++++++++++---
 net/netfilter/ipset/ip_set_list_set.c   | 13 +++++++++---
 5 files changed, 65 insertions(+), 18 deletions(-)
