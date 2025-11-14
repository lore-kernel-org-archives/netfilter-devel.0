Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF2D1BD9C9
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 12:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123793; cv=none; b=XBAT54029MahTOLBS4Cq1C5fUw0yHBpwu+qXJnjjmmgpfCBX51rJMhNzaH+f1cAJTsjuNzuk8Fk/O0JETRIo2BTBOqcIg+EzcuPBcedNrgjRcg8roTvfjhQ8a+uI+AMjJCwwUaWP0UZr/GMElh/PjvoOMTKp22ORiRI5Zyr38JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123793; c=relaxed/simple;
	bh=pYFS1w5LqSKiBpHE0JjLQrQpSHXEGR4KHD20HgaVFvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YOAjY2QzVkd9IacsVTZ8cTMDWKBcY7fGx3hWx6V1RBX/zYwVVpI8h/2i09gBrUn2v+0xsRhwvNFasUCcilp0NawTsBZMNULnRvJN6PZjoc59PvAd1qyFn/JSpxRvUMuganvcek480HfwoO6jNZtWxMWMhoUx5syd4KuBehbbrnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i6c41msX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i6c41msX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763123790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lQ2USXoE4NiSdUEtifEbQeH6RF51pkvHHbzeKKFsOLk=;
	b=i6c41msXK3gN0iqVyHNlwo7oOsPnNWq2gmdYm3SlsULske/gScFFAgO5HdRIUleVZ/xn/v
	kSm6MusAAfWwhxzch+OQJsjVJy4SMphQGHUqnIQzvPIQqPfACU5UCt2la03lGNriZpkn8g
	eferlL1vyomGUjs8xYUmekqbIN2khTI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-KJXWNvNoNw6uS43y9rSUqg-1; Fri,
 14 Nov 2025 07:36:27 -0500
X-MC-Unique: KJXWNvNoNw6uS43y9rSUqg-1
X-Mimecast-MFC-AGG-ID: KJXWNvNoNw6uS43y9rSUqg_1763123786
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C36518AB42A;
	Fri, 14 Nov 2025 12:36:25 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.52])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43910180049F;
	Fri, 14 Nov 2025 12:36:21 +0000 (UTC)
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
Subject: [PATCH v7 0/2] audit: improve NETFILTER_PKT records
Date: Fri, 14 Nov 2025 09:36:15 -0300
Message-ID: <cover.1763122537.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 net/netfilter/nft_log.c  |  58 +-------------
 net/netfilter/xt_AUDIT.c |  58 +-------------
 4 files changed, 169 insertions(+), 114 deletions(-)

-- 
2.51.1

