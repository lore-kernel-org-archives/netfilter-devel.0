Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B2A2222C4
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 13:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041033; cv=none; b=n9fPfAptlojk9oh0HdYmkZ9D3O8wggBjM6a74H2dRR2Ze0ACfOtFqSKSDgmQu7IEMiH4v90rxTICuTMMf8qY3j9D+AzHqNRNTx+3kUw2xKf2rqIRNB1jReLkxTmXoai6VdtnDxjT1VmMvPumz3Y4Muy1gZfU7kdhuEe8twXcfjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041033; c=relaxed/simple;
	bh=ITUKq37G54FdMNV++QNuaG95UHtduurUTc61Vy70kTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ENSahuVovEi0nReBD/WYYDfpoMPvTNVtcI3C1v/4+t949IQSbXnk2YX8uVVvJF8ZsOGTxC1xdoC7B8b0Pyd+RrQx+TWOJKu4kXtbVlk3ZB50E5/bJ/gPUhErtFcp5r5N7HZ3C+u6qFQFptlv48GIT4xO4odyrM8w8l1t1mmHjZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X8GYThTK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8GYThTK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763041030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Iva89Jq9h47cYma4tPYPJMDkfJQ4oDC4mjQP4QFuAx4=;
	b=X8GYThTKfpa9A6SGZRPb5yy0NUPJWTCcrrbaMmxqIENJAnUZyunq8SJ6b4P1F06iKRgvJD
	15kN5zd8BSBKwzGLKiJ6AjksLBIqGANehM4CkOj3BFN5KVAIhrrW0KBI64DoCUEFhAwKa6
	crV3P8Ik7lHaNDZP2IxPxULS76V+oH0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-wJyhP-w3Nm6Zf1sDows6LQ-1; Thu,
 13 Nov 2025 08:37:07 -0500
X-MC-Unique: wJyhP-w3Nm6Zf1sDows6LQ-1
X-Mimecast-MFC-AGG-ID: wJyhP-w3Nm6Zf1sDows6LQ_1763041026
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E256118002CC;
	Thu, 13 Nov 2025 13:37:05 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.76])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 483E319540E8;
	Thu, 13 Nov 2025 13:37:00 +0000 (UTC)
From: Ricardo Robaina <rrobaina@redhat.com>
To: audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: paul@paul-moore.com,
	eparis@redhat.com,
	fw@strlen.de,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH v6 0/2] audit: improve NETFILTER_PKT records
Date: Thu, 13 Nov 2025 10:36:54 -0300
Message-ID: <cover.1762978910.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Currently, NETFILTER_PKT records lack source and destination
port information, which is often valuable for troubleshooting.
This patch series adds ports numbers, to NETFILTER_PKT records.

The first patch refactors netfilter-related code, by moving
duplicated code to audit.c, by creating audit_log_nf_skb()
helper function.
The second one, improves the NETFILTER_PKT records, by 
including source and destination ports for protocols of
interest.

Ricardo Robaina (2):
  audit: add audit_log_nf_skb helper function
  audit: include source and destination ports to NETFILTER_PKT

 include/linux/audit.h    |   8 ++
 kernel/audit.c           | 159 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  |  57 +-------------
 net/netfilter/xt_AUDIT.c |  57 +-------------
 4 files changed, 169 insertions(+), 112 deletions(-)

-- 
2.51.1

