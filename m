Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683C2191475
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2024 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718616227; cv=none; b=JJfvm8qO4D35/PzhQtWaKXw4UDPnRdsvWupxq6YLHlL64SKaiIq2JxmYgwyn4pA7ImqJcg21YQn4L6iRMB+WbWkX3TmmoMH+I3ra5li6KfpaXrFjAE7/zrPD97o5hdsleFhQpKZpfey6bMYt1pdxTjfgGUMKaNGRob+wOZP41zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718616227; c=relaxed/simple;
	bh=V0RFvhFakOAEJel9Hvd7rs7ItkwgeB1WanMImc/ozG8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DchCp2vGGY60jeFwu71XbMrqp8cAVaHPCzpK09y/1boL3UHFlmHSEXy3ni8I1tSCkkhDJzRQPJpqVId9QRS0CgFvTEqbvg9VSlEnOaKMEfpoOXxV72/P1byGtB6tfwAjvm+/tDGtpSDLnJBZ5O9nIbvPlQysDstH28y02lG8OwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=X+xoUkta; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="X+xoUkta"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 59A3BCC011F;
	Mon, 17 Jun 2024 11:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1718615895;
	 x=1720430296; bh=d1KtR7Wer+wpSgruS9B+M3fxJzCUfLoSKluDftg8OgM=; b=
	X+xoUktakp6Y9PHIJNvJFWEmRSW3ABnJRaJQlVXYTGHTF73WXyaq8mPV3SmEYmU9
	rvuQqzlkEeeHZANeNScjSyEgHVKcxR6CKovBnDksm20ELoOsL5f/BdrLst5i8Fu2
	R6GXPjD2XxPRffcnBI549YGzcFwwd6KrR45J5KdIxAU=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 58693CC00FE;
	Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 5189934316B; Mon, 17 Jun 2024 11:18:15 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch for nf
Date: Mon, 17 Jun 2024 11:18:14 +0200
Message-Id: <20240617091815.610343-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Please apply the next patch to the nf tree, which fixes a suspicious=20
rcu_dereference_protected() call.

- The patch fixing the race between namespace cleanup and gc in ipset lef=
t=20
  out checking the pernet exit phase when calling rcu_dereference_protect=
ed(),
  which thus resulted the suspicious RCU usage warning.

Best regards,
Jozsef

The following changes since commit 9bb49a1f0354a2ed2854af40d7051188b9b858=
37:

  netfilter: ipset: Fix race between namespace cleanup and gc in the list=
:set type (2024-06-04 09:23:46 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 0eb942092ce49

for you to fetch changes up to 0eb942092ce49307042e4603917f1e126ca50394:

  netfilter: ipset: Fix suspicious rcu_dereference_protected() (2024-06-1=
4 12:20:33 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix suspicious rcu_dereference_protected()

 net/netfilter/ipset/ip_set_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)
