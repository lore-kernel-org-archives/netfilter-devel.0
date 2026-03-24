Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9693D5246
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365548; cv=none; b=W5mOcjIbsV+TPgMpQy3rTz7v8JT21LeyuQ7ifuCEE+FkS7zWf000/lacCkzQKf6c+UXv9cHepldZ4HNBL6QhgfoM/zdZ6j/DWS49/7qr8GiysFauNgtCfjJw5skzjwOh3rSZpuWqxJChHuseYV3M/FR4vkbGfMRzvkUO9na5om4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365548; c=relaxed/simple;
	bh=6HhVUYhmyMTvcAMswOM3dLmuCaP1Ju8W9ZRentoH7XA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s7mTj7n3bKfYBOP2cRzNEd89Nl2rHl4WuNhZBFa+f2k7obZlErF3AtQ86FLF0Wp4Pc2/BamL2/8bScuEeq92joX3pK059Mh4aYDvPyHj73pjrcds2PfMvfE70qXvHQDlEtfcSr4KieFVsiRDahNpt3pfaPhVFhkEGIMD7t4liS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUzNkpBI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUzNkpBI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774365544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CSqalb9riJujooqwq7rgCHpq/1IqNcmhKMRp2FBzELY=;
	b=DUzNkpBIauuMdzVH0+aYwNorIO/KgrWhap7Z7bBCe8/M7AGQ6fNAcYXHbU5ozC5TpchYaO
	LYrdFvAYGaAoc9g8xkJ11mRzN7CqoKzZbwWv1jel44cCrICxtPtfZbV/7E/em2AujqtyPC
	J9yEIj3JBYoi4o7Z6V5nXqiGAm7UhPU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-vuqiLqJEN7aqlqKNrZsWVw-1; Tue,
 24 Mar 2026 11:19:01 -0400
X-MC-Unique: vuqiLqJEN7aqlqKNrZsWVw-1
X-Mimecast-MFC-AGG-ID: vuqiLqJEN7aqlqKNrZsWVw_1774365538
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4E511955EAC;
	Tue, 24 Mar 2026 15:18:57 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.192])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F104180075C;
	Tue, 24 Mar 2026 15:18:51 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Frederic Weisbecker <frederic@kernel.org>,
	Chen Ridong <chenridong@huawei.com>,
	Phil Auld <pauld@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	sheviks <sheviks@gmail.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 0/2] ipvs: Fix incorrect use of HK_TYPE_KTHREAD housekeeping cpumask
Date: Tue, 24 Mar 2026 11:18:25 -0400
Message-ID: <20260324151827.2006656-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for preferred
affinity management"), the HK_TYPE_KTHREAD housekeeping cpumask may no
longer be correct in showing the actual CPU affinity of kthreads that
have no predefined CPU affinity. As the ipvs networking code is still
using HK_TYPE_KTHREAD, we need to make HK_TYPE_KTHREAD reflect the
reality.

This patch series makes HK_TYPE_KTHREAD an alias of HK_TYPE_DOMAIN
and uses RCU to protect access to the HK_TYPE_KTHREAD housekeeping
cpumask.

Waiman Long (2):
  sched/isolation: Make HK_TYPE_KTHREAD an alias of HK_TYPE_DOMAIN
  ipvs: Guard access of HK_TYPE_KTHREAD cpumask with RCU

 include/linux/sched/isolation.h |  6 +++++-
 include/net/ip_vs.h             | 20 ++++++++++++++++----
 net/netfilter/ipvs/ip_vs_ctl.c  | 13 ++++++++-----
 3 files changed, 29 insertions(+), 10 deletions(-)

-- 
2.53.0

