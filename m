Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A0F36403B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274262; cv=none; b=RGwqSMIPi4zfq5OPaupmcCGjzBB4W+3STBnCR6W9b5OU3bzjRpcK89H6L2MGaKguFXtqxrJZs8ZCWLuPxm4xHuWJbgaOXQfvZiSNpBMQb3iKEAsm1XOXFlRpyqN++1NqTPXiajrmHTNoBWvQOHJHILlylci3CyZnjMTqiNMbxPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274262; c=relaxed/simple;
	bh=VBmWw4K90l56etN30cLzQrR5qMRXpdUUw0kfS9vRVKI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FcsQtMnQRDlvZovPeEKeXBcNesGwd10KGdJiWuH9QJ6k02RHPEC8f2tzU0vinqM09Z1+VgwqTngw4ry7Ns/JsppfDsJMBBRNSOqDWtulaA+R49Hjm4zeKo5VA2IP5HSksdF/7ot73l2AUwCLqSOHAKkKRldV/vLnm7dhxAnPDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Tti836hJ; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Tti836hJ"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gC1gw3Rvwz3sb8r;
	Fri,  8 May 2026 22:59:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1778273946;
	 x=1780088347; bh=oGb96l/S8WijJSk1sUQGzB7IrwGLZO5aEkXTV3YzVDE=; b=
	Tti836hJ3EuHs3+lA5M67HiM5ylQTJzUuxrKq/X/D/h+WOOwQfmrFToeWzU+jsLI
	AMWLXC9gki6vYt93C8OtBPEE0h9CM81oy4TEVLqGor7j+uh14MRyxzba7TDTN2CQ
	0zSECxzTpvpmCoM7rJ6cCf0Cn6UXjKa+BtzdcdTJJEM=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id FxK_9KEdxti3; Fri,  8 May 2026 22:59:06 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C131D.nat.pool.telekom.hu [37.76.19.29])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gC1gr5MkSz3sb9B;
	Fri,  8 May 2026 22:59:04 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id E6D55141C70; Fri,  8 May 2026 22:59:03 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v6 0/8] netfilter: ipset fixes
Date: Fri,  8 May 2026 22:58:55 +0200
Message-Id: <20260508205903.10238-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 1%
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Here follows the new revision of the fixes for the current list
of ipset related issues. If sashiko won't find any issues in=20
the patches themselves, then please consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (8):
  netfilter: ipset: fix a potential dump-destroy race
  netfilter: ipset: Fix data race between add and list header in all
    hash types
  netfilter: ipset: Fix data race between add and dump in all hash types
  netfilter: ipset: annotate "pos" for concurrent readers/writers
  netfilter: ipset: Don't use test_bit() in lockless RCU readers
  netfilter: ipset: fix potential torn read in reuse/forceadd cases
  netfilter: ipset: skip gc when resize is in progress
  netfilter: ipset: fix order of usage counters

 net/netfilter/ipset/ip_set_core.c     |  5 +-
 net/netfilter/ipset/ip_set_hash_gen.h | 82 ++++++++++++++++++---------
 2 files changed, 58 insertions(+), 29 deletions(-)

--=20
2.39.5

