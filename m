Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8F344A401;
	Fri, 25 Sep 2026 07:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322769; cv=none; b=Hv9wRMT/w0juSG+Op0bG/qHJW/YFCvKxvHz9nPcZdoImelV8JTDruKqmAMt2Ox7Tl08EhcVVTB8XuvKFJZvozIBg+kFPLP9zG01OMK3Su9LADQ/ZRjqxMbdfRa6a8athjIQwmWRk8XbvpXlW3nF3NCuJzvCP5OxnSWgjoXgPKHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322769; c=relaxed/simple;
	bh=CgRcXQie+T69ETEa8rUNcovgYaW8VSUwbPpeXhnPCS4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JT42Ny3klqxVUujHCxTcZU7KFGuYJIlVK7PssBl5Sz4LZHdmc2jn1HlDhhG6Uxo33JLIRhyOUphLRKvQuUYWNB+f8glEHqcPEUpuIsQX8t4RdeZYmyqG2mQAinbcB1LGUf4rprXewP9GR5ECe3GcN6WEmsyFIDddek6bFTnMb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=jZUho3+V; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="jZUho3+V"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id EDA4EC13986;
	Fri, 25 Sep 2026 07:53:26 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1BEEA6073B;
	Fri, 25 Sep 2026 07:52:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5DB0C1032947E;
	Fri, 25 Sep 2026 09:52:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790322756; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=FsDCnj6jRyJlNhpK+Zm7bz+TGLpERitPmKFYbPhCRNQ=;
	b=jZUho3+V2sXORWO/87Gy1JG8gAzwqQq5Yo3cIVVeCsAmi6ouBCI8dyt+CJGY3wK58aV+4u
	KRFCXdEh4v54G19XseA7JQOHzrdWI6wFm1pFcfqXATFKey63PgCog/iMKV1D7F/aAQQRU1
	GWCao+AK0NMLQ/XB080Kf/7nr+yoIJl1k0j6ikKMjpF4wH7uqV4gxxsRlLnwhi2N/uUs4N
	ZxMU6lk0yJt7ZnWLYw24BxNEallJir7tyQ5CDhYLOSaj2Hq/WVNEAD2+OmuYlZqpCZ769J
	ciQpDnq9fRhk4bfYHlSQFykA5llS5TNFpZMLJ4JnGtMvJCPyHjlhGycyC+aEjw==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 6.18.y 0/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 09:52:22 +0200
Message-Id: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3ZJW6G2vgrhIHXR5QCmFYIhv
 LtFj98k829IHIUTrsWGyIskmcYMfSoQnrfxwST3bBhlrPKmprAwHaDaeOfIknbkA6vzxfquqnr
 k5ytyL+uv2sCW2pUftP89zd3A4X0kse9f5UWAnH8AAAA=
X-Change-ID: 20260925-cve-2026-52988-6-18-9ce03769b44f
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: miguel.gazquez@bootlin.com, thomas.petazzoni@bootlin.com, 
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, 
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
base-commit: e8694cdbd7db99fa26f6e8c80a2a337e0de29a2f
change-id: 20260925-cve-2026-52988-6-18-9ce03769b44f

Best regards,
--  
Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

