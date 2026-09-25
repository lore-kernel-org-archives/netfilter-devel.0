Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D613CDBB1;
	Fri, 25 Sep 2026 08:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790323322; cv=none; b=PhNPZDB9kmkRf+4IyPtOsqUg3Be+ttTiAWd/i2TqNd0FEr+PtU9aPXQdVWJEHzEr3/maSj9JOjwCusoNiZRNm3/zUSDZl5NQhvvxIOJu9M0C5fuQRw7+d/ENn/www027DeAUDGds3Lr0Xf4aApHeR1jTUlE3CQ+oudQfHh5slos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790323322; c=relaxed/simple;
	bh=FllVzV6RRWtfHUru72xNUN7jzr+OR7lC6u8440TkWAM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gYwofT5rR5FD+LlWL+1SWtx9BmuYPkYIeGNMVN9iq3R5RDT9+BNl3uNQowssMH9T6PUivNA1Iiua95PDAD+gJ8dmPUGrR7mqHKjrHfspfy2Tk40XmFJQoyHA++0F8mpYta86dZcxAIeYTiCAvHyrY8vItt3q9YMgYSiCpsEsRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TArSRYjz; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TArSRYjz"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 3EC6DC13986;
	Fri, 25 Sep 2026 08:02:45 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 71ADA6073B;
	Fri, 25 Sep 2026 08:01:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A50B31032958A;
	Fri, 25 Sep 2026 10:01:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790323312; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=kzBndwiBxN+4U8zl++0XCjr0MB23RZ/rwExmVNCnUlM=;
	b=TArSRYjz2y+GqhSbsERc0wwPYG8kFPKULpwEFTe72enkSlJ+xa6Wc6MEhoCNdyys8zfYhx
	B14qNwc7FkrJyf1dGoJRCBmwyI+It6f1VojokVl7HT+tbLgdViAhBLI+eQY8oslk5GP1fs
	YzArF+xuTkqV/ogTIYoeHf6q7bJQygNpDDI/ebLhLRKAx3qZ5i5XrJUhOZyy0LXRQF4NaR
	Kr/FlpaqvFjj6LwDSeRvmHwjmFtresHHq9bbUGjb003ksj3E1Ydy3m/4t3jEx1tw7hTpfX
	404zGR67zdJb0OX/bdmGBgcjBEjrRG+kg+tHrDDdpcUnYKe67XKYL9YF2TuOug==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 6.12.y 0/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 10:01:42 +0200
Message-Id: <20260925-cve-2026-52988-6-12-v1-0-d14d787d2cb5@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3ZJu0rD+irGg5RF1wOaFomG8
 O4WPX6TzL8gazLNOFYLks6W7TEW+F2FeLuMVyXri8GOgxNuKM5KG6hhaVsK5Jl83x32g4g6FZT
 nM+lg71/1hFB7rj84//f86u4apy2Jdf0CS8ueEH8AAAA=
X-Change-ID: 20260925-cve-2026-52988-6-12-1db43f99e0e9
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
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
base-commit: e2acc2211022246c77740d5df08265cc27eedcc5
change-id: 20260925-cve-2026-52988-6-12-1db43f99e0e9

Best regards,
--  
Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

