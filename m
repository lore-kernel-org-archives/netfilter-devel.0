Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDA923D7DF
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542125; cv=none; b=Bz5S7g5jeJxN/iJ2DKSLxOCuM2FEYeRkf4TAfH+b9031+GtL1HwH7XGKXp2C6hv0F0f1UwD4rdUKG1QE67nUp7JtAqlwD0xPKDxbsQsVBea30fmRj7/nMvjKMiYgij2aMfN+iviQuBTnrHGDS/in7l9v/zm7Zyg8Hgh2ET+az28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542125; c=relaxed/simple;
	bh=V77jMp/Yy7CBr/msUD4IARMyyKnPFhHfrLN3dpPZ8GQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OabFirAODMiA2ciEHY8/jWGi2fvi6lePvhF7PghzDrVaxH5vKEfj9T+1OQ1RYWDYZQmyK+TJloeP6LPHTvsZuG9OTC98qQ1pTOtpOjHmP+TUoYcfE5YxELMDkpPuoXBb5Tpv849FucihD8deVVzvdYQE0Cv/yMLhu+JxdMYdkMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=J07L7MAI; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="J07L7MAI"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gN2gs242Bz7s86S;
	Sat, 23 May 2026 15:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1779542119;
	 x=1781356520; bh=OgfzX1Z3hDaCPYLAdwWTpiwv29jFLh/hdYiymR++wIY=; b=
	J07L7MAIO5LBykXORpKHKfKbEnRLHGnQSESKy3iy/yUmiliqKCIjNE+C1e44bGb/
	+P1QqOtfN9XzZQ39E7bkC9g0bgOg7ZXWQk9edO5VkeWzL6bXabwZWt915G5dTY7Z
	tJHMtCYygyP3bjN0xS8Z/kqiphIVDO7zVpFjHmLzp0Y=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id zkr5S67AXpDO; Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gN2gq2Wcfz7s86D;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 3DBA8140B31; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] netfilter: ipset fixes, second batch
Date: Sat, 23 May 2026 15:15:13 +0200
Message-Id: <20260523131519.99953-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 0%
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Here follows the second batch of the ipset fixes, waiting for
the comments of sashiko.

Best regards,
Jozsef

Jozsef Kadlecsik (6):
  netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash
    types
  netfilter: ipset: Don't use test_bit() in lockless RCU readers in
    bitmap types
  netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
  netfilter: ipset: skip gc when resize is in progress
  netfilter: ipset: fix potential torn read in reuse/forceadd cases
  netfilter: ipset: add comment how cidr bookkeeping is working

 net/netfilter/ipset/ip_set_bitmap_gen.h |  7 ++-
 net/netfilter/ipset/ip_set_core.c       |  4 +-
 net/netfilter/ipset/ip_set_hash_gen.h   | 63 +++++++++++++++++++------
 3 files changed, 56 insertions(+), 18 deletions(-)

--=20
2.39.5

