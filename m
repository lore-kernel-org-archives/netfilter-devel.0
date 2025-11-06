Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78F137932
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448004; cv=none; b=hCyeE7FbVZbifSqU8wQv9gbMMhE+tlRpyeljjciU8hi6ehYLsZSNG9phV3DoezLHYa6D/JigxJTjGpItvOeiQSGBhE0zGd7NBLqXQ/AYZDPRAU1B6M2KOvBfAdQPvJD+SqQYqyCvoKoGVc0ZSd6mssSYVX8pZERzk2sHtDweEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448004; c=relaxed/simple;
	bh=JpRqcPxnyiahrRWopQHqL/udNfz8xFLZ4IJJ1yNFRzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LzYl8j1Wzf5IM/rvdq63fgAfuVyjOSAJVGoxz4mWGz6jEYJDTgobJHSNcPG/ZnwwvhndZD1TiwVvPofLLt1i4mWEPSHw8H9hsDXMtd5pTTSwa2dDRx/CQu9r6FRpt6JDxhNYN66kwqoJLG61J95+67hrGtlh8nL9pLs02nyYLeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TCxP8CO2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCxP8CO2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762448000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jfaHKlPxHr/Mtq+6BIhwUxcOaTw79FDWo9JAt0vNPf8=;
	b=TCxP8CO2ucM7okHBPSmp0G8N4wc6nRz4wP4zD9hY/baP7FkGv8KY3vaVu5Can99joi2BOS
	+EgKI8eX9IMmuWt65oVuaDjW+sG96bJ6han3Irs6jIGMTbsfw7NHhkgtsdsxjLsCQ9gVyi
	innvtF16gqBbIdLkHtbukAixUxYur3U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-xY4CcUjtNz2QogZHgjJ15Q-1; Thu,
 06 Nov 2025 11:53:17 -0500
X-MC-Unique: xY4CcUjtNz2QogZHgjJ15Q-1
X-Mimecast-MFC-AGG-ID: xY4CcUjtNz2QogZHgjJ15Q_1762447996
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A47DA19560B3;
	Thu,  6 Nov 2025 16:53:15 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.113])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F9151800362;
	Thu,  6 Nov 2025 16:53:11 +0000 (UTC)
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
Subject: [PATCH v5 0/2] audit: improve NETFILTER_PKT records
Date: Thu,  6 Nov 2025 13:53:03 -0300
Message-ID: <cover.1762434837.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Currently, NETFILTER_PKT records lack source and destination
port information, which is often valuable for troubleshooting.
This patch series adds ports numbers, to NETFILTER_PKT records.

The first patch refactors netfilter-related code, by moving
duplicated code to audit.c, creating two helper functions:
'audit_log_packet_ip4' and 'audit_log_packet_ip6'. 
The second one, improves the NETFILTER_PKT records, by 
including source and destination ports for protocols of
interest.

Ricardo Robaina (2):
  audit: add audit_log_packet_ip4 and audit_log_packet_ip6 helper
    functions
  audit: include source and destination ports to NETFILTER_PKT

 include/linux/audit.h    |  12 +++++
 kernel/audit.c           | 114 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  |  43 ++-------------
 net/netfilter/xt_AUDIT.c |  43 ++-------------
 4 files changed, 134 insertions(+), 78 deletions(-)

-- 
2.51.1

