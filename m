Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD764A8D
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790323819; cv=none; b=uzLmfmB/Sw/vBihaaFglJjH2ATR/60hHHi/qJAsCSiUq/HZ+ykvmjtnpoLLgFI2Zc5zO4VoZWHtD1OibftMHrpubmA+YxnCctx7wXTQD5l1jw+6yVRhazrOPuDdIHDrETxLssVTwjzB69AIw5NF/IQfmIprwr09FwndDuKO74qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790323819; c=relaxed/simple;
	bh=8mcXLzWBflad5+Fp/2csykBACXv0umpKgZryz2CtUvw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Rn+AxUmaDY/fvxPAHZL6iksVGc6EvUKrG81boQ44HtXsOHnoQVMrWJiS2ispcMvYjtQxmUi/+2rxn3adbsGLtn+QGP5dC3x3uE/fA8Ju7gCaRd/ddg363MmE9g2PhvhPKmCZxE2X9nyU3IXb3LXkDGHHcily0aQJPS6E7s164qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=XsagO6X6; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="XsagO6X6"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 312891A1019;
	Fri, 25 Sep 2026 08:10:13 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id EC0676073B;
	Fri, 25 Sep 2026 08:10:12 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3D7501032958A;
	Fri, 25 Sep 2026 10:10:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790323810; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=Dh9HoUjgBiabQYfjyRhexWgx2GlBcYfkLukE/KgJkzg=;
	b=XsagO6X6/c/u/HiKmojbj0gKFFmPG6znb5CKCzmG4g9Boo4+va+0GWDdrkJtn9cGqfEywf
	lffG06picFdDnw8WKY9lyAewq6CGXD6+CT5cAazwWwhyiXQrAJQgar+tp9i1H7VaJ21WMv
	tGw6Nu1BdiiidUYlSzyg4gQBzuaIE1zMvzxINAsNTJvwcti5RqB/i4J1mHb6A8Pndgf2NI
	XaR+aW6HtfLWPuxosl3E/WIxoaTfu+woIHkNqsoX/6u/XC/l76SXkG/bMcd6nRN9iU6T1g
	4kci7r46yRUIxchYjNouX+8BBx6hywjsPzbt8MBaZMIq+SvtCyIel0MhTiwkqA==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 6.6.y 0/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 10:09:40 +0200
Message-Id: <20260925-cve-2026-52988-6-6-v1-0-d5b30678ef66@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQqDMBREryKz9otGkqpXKV1o8qO/C5WklRbx7
 saWWb2B93ZEDsIRXbYj8CZRljlBlWewUz+PTOISQ5XKlK3SZDemC0irtmnIpA2V9+7WO826RhL
 XwF4+v+gdpjDFF4//Hd/Dk+3rCuI4Thxk+xB9AAAA
X-Change-ID: 20260925-cve-2026-52988-6-6-b1ffd7ad5e53
To: "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: thomas.petazzoni@bootlin.com, rcu@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Last-TLS-Session-Version: TLSv1.3

I backported an additional patch, which adds list_splice_rcu(), which is
required.

Signed-off-by: Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>
---
Pablo Neira Ayuso (2):
      rculist: add list_splice_rcu() for private lists
      netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

 include/linux/rculist.h       | 29 +++++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c |  8 ++++----
 2 files changed, 33 insertions(+), 4 deletions(-)
---
base-commit: 79643295eba17affbd16ca97f3ef04c90266b28c
change-id: 20260925-cve-2026-52988-6-6-b1ffd7ad5e53

Best regards,
--  
Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

