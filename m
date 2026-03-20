Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4763AA4F1
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774007295; cv=none; b=IKozjx3VvJIIE3ivStiIwvVnhZmp3W5RYX9ErdLKOadQYH5OyxftSqy2O4PCHqg+C3+elrtY6A0lIzYThHbln8yksaXByewb3kfqrwUFSogCA8buqhCTg6K3bht29EWAfaaZUkR/IF+4urGt506hladugSmDNjq8g5APm1XbErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774007295; c=relaxed/simple;
	bh=z4/x3NjLs5HLeeM5LswuxOMrqJhfWNGpRMA4EgtdnSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hrFe1IDC8diTuqSJWJYE22thARan9N6pMRnwmQ5ThqzTvduBshhAft9YiMG+o6UjbWl0z4Yf/55YkKxXzMStVeYq0YKn6FKOMwRyZM35WPZjNV1okKO3go3MhD91FIVjpFVkmAAnWWgNHnteimszuw89gtSAXk4MzR1I4gp5VBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=oFnMhApL; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="oFnMhApL"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4fcgcC65F2z3sb9k;
	Fri, 20 Mar 2026 12:40:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1774006841;
	 x=1775821242; bh=iFEfey0YdQWu1c0XEurny+ilqWlLQ8I+J/YeqezbNQk=; b=
	oFnMhApLZsLKV0F/LnPrNtgszN/dMCIMx8ORIyflnxa1WZ1vzXOTX6reomq/GXWu
	V+G/M+zXcB/f2+vSZOMIczLbqbIt+ayb2dsYhPy3jSLu1VcHsYJRiZEBAhyIaeFO
	9iHK+yz9g5IAihTBSs6m4vcsJTliDoCPZMK3ocBGIBU=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id hLSSAycbfmQB; Fri, 20 Mar 2026 12:40:41 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4fcgc94sFQz3sb9S;
	Fri, 20 Mar 2026 12:40:41 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 8D61D34316A; Fri, 20 Mar 2026 12:40:41 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] netfilter: ipset: Fix data race between add and list header
Date: Fri, 20 Mar 2026 12:40:40 +0100
Message-Id: <20260320114041.3486273-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Please consider applying the next patch:

* Fix data race between add and list header commands in all hash types=20
  by protecting the list header dumping part as well.

Best regards,
Jozsef

The following changes since commit 9ac76f3d0bb2940db3a9684d596b9c8f301ef3=
15:

  Merge tag 'wireless-next-2026-03-19' of https://git.kernel.org/pub/scm/=
linux/kernel/git/wireless/wireless-next (2026-03-19 15:30:20 +0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf-next 1962de9a3ef9136598a53

for you to fetch changes up to 1962de9a3ef9136598a538898fe750094d3f9ab6:

  netfilter: ipset: Fix data race between add and list header in all hash=
 types (2026-03-20 12:33:37 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix data race between add and list header in all =
hash types

 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
