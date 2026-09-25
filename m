Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427F54582E7;
	Fri, 25 Sep 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324613; cv=none; b=RDEr50g0M36y+yCfjwplM8y5nSGE8n/YEzQ4RXCyRdTpf3b0aJcQxwjsLDV26665RtlU+SDduHNmicF+BpTZrqGFXwf+ZS9xMUyRZDlWBbg0RGn7ZvbS/yMmW57mRpSxjQpMnrxo5zJtWE5OAiGiNk90MtF5tUqUdT2pLt179Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324613; c=relaxed/simple;
	bh=+Ts13b74M3XgxNYsIYO9QRi2dZT6XjAWTChb9MYezwE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NDwYSsdObSeEY168cDNddbu6toLBQzZZIb5d3dcOi7xBx0gjuPzKbOFr2Zq/MBbVrmWV5S1gRSb6PpAgLjFRijyvUdb4hGLKomqdMnvmeLrJzyHKwOPh6GZYofi5UqmavdBOyG8sXpWYp9WUuNvQPMHnc0y3lo2BpcNX6cTiIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wMJGuyoO; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wMJGuyoO"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 17F46C13989;
	Fri, 25 Sep 2026 08:24:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 524BE6073B;
	Fri, 25 Sep 2026 08:23:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1B71C103294AF;
	Fri, 25 Sep 2026 10:23:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790324609; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=zzIL5W2Ye25GZnPKQdg462bHYeceCuodqwBjt0Xld3w=;
	b=wMJGuyoOSDtbRG4/I+0B3E29cEvt+ytywbYZgeDeeCJiUqVtug2bCwsrMuy2/IrqYzusfe
	tzEQTAApUEKBW9drzt15BGyutDHR36QcZ/vbTc6NX4NShbVIOWlWu65wLaix29ntH0+Hru
	X2n4ZfCqN8ve6UFKDN1WMAmzp5Qo2IMOR2Hc3jAzEP4o+0zJ7T3APlp0vTkIE+0jEdGpwE
	2mLBwCMM3AQTLsDhjjAVaDSQzEnrKXuJpJWKdd+3Gh8lsx2bt6oqUJZxL09r74n7awcfui
	r7zJL5GS6W+f+/z9421jdqLnlPSP1kaYTRDlJ+TRzntOU/NxeP6whsMoXeNyHw==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 5.10.y 0/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 10:23:24 +0200
Message-Id: <20260925-cve-2026-52988-5-10-v1-0-19be752e722b@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBCF4auQWTukrUxDvYphAcOA4wJNiwRDu
 LtFlt9L3r9BkqiS4FZsEGXRpK8pw14K4Ec7jYLaZ4MzzpvgCHkRPIDkQl0joTU4EFfXrvXBc4D
 8fEcZdP1X70ClNeUXmnNPn+4pPB9J2PcfoOqnrH8AAAA=
X-Change-ID: 20260925-cve-2026-52988-5-10-f5c43ba696c9
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
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
base-commit: 1797d8bf8d0c2e74defad605d14e3553d43a3caf
change-id: 20260925-cve-2026-52988-5-10-f5c43ba696c9

Best regards,
--  
Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

