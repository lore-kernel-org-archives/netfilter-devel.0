Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45FB23909C
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000034; cv=none; b=AA0SGpkUKdE/xMtE7uRF/JDvF3JDW99N07r0B2ISzQAuteurxj6fpIR3575E+baLIyg5OHyInBzKhKb5qBS6W7T2yjdKdFesXtofC4mzC2hVL2ZZmWfRdzoBo9cOnpQPxYnmCSGnuZH6WVazH+ZUKpF2g//j5lCZ9e390actfPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000034; c=relaxed/simple;
	bh=V+0UQ/vdeEej7x0jfyrPwD/SZ8iXEBlUvtPkLdMIQmY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gYFqrI7AkVikuwPGGmS7orlsCA90JfxkDRD/UnvMF3dz4yzkCMQaM5vsUoF0UitnLybdv2m8NPf/32ikiiRPkUf297cbSkJalkOfD1JZHh2ddqi+WZIeOOdE0Wb4/1BX5z8EU14vbQBn6VNpfP6UCsdkitdVL81rRguPfxg7N8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Qo1lYC0+; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Qo1lYC0+"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4grdTz55tlz7s7wV;
	Thu, 02 Jul 2026 15:47:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1783000021;
	 x=1784814422; bh=wLO86Z5EC+n2+gbqecV3Eeg3ojkIOPNPICkj49ExSCg=; b=
	Qo1lYC0+l15bWTAHxmXIB8OrWPN2ZNXhA7QPpvd/qvwU14MZUspeYuUUCe4uxHk1
	eCBI9UwY1b+VUBQnDlZhpGn0w4KKGCI0qmHGCTz0+emVeSyTm8d13igWHt2sYaN1
	nDoDd+JJ0osf2kHy3KFyrzPt8aElNZMmgEsKHS54UFI=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id nQCMkUhZcobz; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4grdTx55ysz7s7wP;
	Thu, 02 Jul 2026 15:47:01 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 81418140786; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] netfilter: ipset: gc, backlog and cidr patches
Date: Thu,  2 Jul 2026 15:46:56 +0200
Message-Id: <20260702134701.207721-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Here follows three patches which addresses the gc-resize clashing
in the comment extension, the add/del backlog cleanup in the
error path and a fairly large rewriting of the cidr bookkeeping.
The two other patches could be squeezed into the next ones on
the list but I think they are a bit independent cleanups and
clarifications.

The batch does not address the issue Florian pointed out about
sashiko's complains about possible missing rcu locking and the
possible torn reads, also from sashiko reports.

Best regards,
Jozsef

Jozsef Kadlecsik (5):
  netfilter: ipset: mark the rcu locked areas properly
  netfilter: ipset: exlude gc when resize is in progress
  netfilter: ipset: cleanup the add/del backlog when resize failed
  netfilter: ipset: allocate the proper memory for the generic hash
    structure
  netfilter: ipset: rework cidr bookkeeping

 net/netfilter/ipset/ip_set_hash_gen.h        | 311 ++++++++++++-------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  12 +-
 7 files changed, 230 insertions(+), 121 deletions(-)

--=20
2.39.5

