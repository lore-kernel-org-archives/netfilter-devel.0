Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B1A3D6CCE;
	Fri, 25 Sep 2026 08:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324173; cv=none; b=IQWDWX6fJizy/yt1cjttlykJzh1Q9kV15Wu6Y2mmZ0JahRYp30GRzgQCcnKPeEiEX/Dib4m+JyHErPWCKFS5A+OVJTfmz7SiAYQj7fSr8VLCBUooLtsl1DZiIixzV6RL5dMuMDVojZT7ySup5ZEf8wLxdWYyF+2iRwZm9Ov/3XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324173; c=relaxed/simple;
	bh=tKNPfsJ9mISILplX5VTvMd+rNVJMBKard5iwZiAOBFY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Eow8dphGWN4VtGXxehQ8cesnDO5Lz8xAo990M7kmt635GS099G93PxenAW/lwEIfmmiWqWLJoyiWVfxJJlqbx4rDFkkRieAG5xItzKhrlXxP/7tDvEwn+UBGUIQRFJW7CdozP8xBEeY5t2KXprZN9FZIMhrxzYnPqGD8phg0VHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=efwBXqkK; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="efwBXqkK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 233DC4E41071;
	Fri, 25 Sep 2026 08:16:10 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DDC4F6073B;
	Fri, 25 Sep 2026 08:16:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9CEE210329139;
	Fri, 25 Sep 2026 10:16:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790324168; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=x+RDaa4Ywv949YblYO9XAtuVXj1k1GMS39cDkHKcyo8=;
	b=efwBXqkKtUYUaC+svsL2+ozQ0lAJ8mYz9WbrvauU20N+yE3LFKTQ28X6XU1vrgk7Uw/trT
	geVHw2KggL4DyCKPSoFXPvvWBQHGj3uj2Kq6Fc3WJQrW5O6itIa87odqe+cZ5DanjJFYRn
	f4hO2DbXsgm/PiT/gb9NBqhMxa4BunECOEv9doHc1B8ZKuXBhih71uKIrph067lj2AN5OI
	hiT3Jo5GLw6SzScMDrtW9AMO8ej05qCmP/uswygFMC2kNVxXjzWFUeOINpfK9hFk2MOyee
	2roZ4Y7vnIN89pRL6Rf1CNdTTrPknm/YykKJHXG2Jwmvr3atT9jWghOJu9KutA==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 6.1.y 0/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 10:15:43 +0200
Message-Id: <20260925-cve-2026-52988-6-1-v1-0-ff64026f03ff@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3ZJu0gBX8V4gLLAekDTKtEQ3
 t0ix2+S+VdECSoRl2xFkEWjPuYEe8rgp3YehbRPBht2puGS/CK0g0pu6pocWRrOBZvOmaKtKqT
 jM8ign3/0Cpfb/IvbMcd3dxf/2oPYth/DS1TofQAAAA==
X-Change-ID: 20260925-cve-2026-52988-6-1-f4320b603a77
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
 Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
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
 net/netfilter/nf_tables_api.c |  4 ++--
 2 files changed, 31 insertions(+), 2 deletions(-)
---
base-commit: 1a8763b93150b2c8f3992c27a5ce7857fee4ab0f
change-id: 20260925-cve-2026-52988-6-1-f4320b603a77

Best regards,
--  
Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

