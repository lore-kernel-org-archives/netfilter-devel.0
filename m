Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADF3233133
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2025 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630494; cv=none; b=k4mvjmkh+F83ZcIOH8QJ2FQlZw0y0KcERLYGpvZChGjLMHG1P3Z4ZZ6hjOWIWJ32GkxFkkCODzTbF5+fotBUQEhsjr0wWCNblCWS4zHAbI2hRrVNeYTTn0GSO3KaZhMeo1lfwQpe911EZpheLtr9xjRemILlIy9YcNarG7u/nWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630494; c=relaxed/simple;
	bh=/vLKvneKcXYoRlZTfrPU4Bsn5vrGSt8r+aidONeMLng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RMF6W9hzTKT8pUt3lyUl6fIb8XCzLjVfeyItJGiYcePbcUCtj0rsNv365Nrh5G8mShXokWz9Xgn8oBzNKI8xsueerEsYN1nm8bMz7R+2kA4nkj6A/M4WkiacOnLhhP6ELHksUJ9VDRrGv+6hYAAKs70SqKYidmGCEFv6jL4f4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=cRl698SE; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="cRl698SE"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 21C9A5C001A8;
	Wed,  7 May 2025 17:02:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1746630119;
	 x=1748444520; bh=S4Bqc/mh1+b8i+Fu0WaPfwKrdFxunSAGKRyWAulsSjw=; b=
	cRl698SE32lOEKL580Ztg5WXqm55hsEKsami1CPXRH9HUxuC7S6UAs+sHo4aXdah
	i1jW0qUoTy/6tL6dRmCUZje9Hsj0m+LIAPGLQUSwT5bTC1EiWm9IcrAYJulpzezn
	YjlAdjRsysdrd364xG9bvvuY8hHtYPxiLPOieSgCyUI=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id W_58wSSOXmgH; Wed,  7 May 2025 17:01:59 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 1C0B65C001A4;
	Wed,  7 May 2025 17:01:59 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 1554334316A; Wed,  7 May 2025 17:01:59 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch to fix region locking
Date: Wed,  7 May 2025 17:01:58 +0200
Message-Id: <20250507150159.3443812-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Please apply the next patch which fixes the region locking in the hash
type of sets.=20

Region locking was introduced to break up operation on the whole hashes
into smaller parts in order to avoid to keep the locking too long
continuously. That required three macros: two to calculate the start and=20
end buckets belonging to a region lock and a third one to give back the=20
region lock of a given hash bucket. The third one was incorrect which can
lead to a race condition between the internal garbage collector and addin=
g
new entries to the hash simultaneously.

The bug affects all hash types, since the region locking was introduced a=
nd
it was reported by Kota Toda <kota.toda@gmo-cybersecurity.com>.

Best regards,
Jozsef

The following changes since commit 3e52667a9c328b3d1a1ddbbb6b8fbf63a217bd=
a3:

  Merge branch 'lan78xx-phylink-prep' (2025-05-07 12:57:06 +0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf-next e2b52b09f1166fce2

for you to fetch changes up to e2b52b09f1166fce29f4888ad9b86a7cfec7ad8a:

  netfilter: ipset: fix region locking in hash types (2025-05-07 16:48:30=
 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix region locking in hash types

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
