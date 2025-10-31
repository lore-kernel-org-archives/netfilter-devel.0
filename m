Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5443534B67B
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919206; cv=none; b=DTHyRmRyVsQwbEfnIs4H8SKccZClrDjfKekJ/7v2z8sFbmTN+m0Jkxqya+TqGxwbfC450fOvWeD+/jkiaezkRS3EFYJv4sBqA2W5znyR1ZtmmwiXZUDmGWkWs5Em95W/jJFRle0pULj38lG9zEVL/ZaoW4OIIzkT6uBUfFsreH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919206; c=relaxed/simple;
	bh=E7dbMhwqa/wgr/PLTOdQ99D8g9e5R8/J8WGoZ2queDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P3fLIUpJhZj28Bf1OoG4AcsBemAni+VFJt91tCxPdKl0+/GjqErEgOQt5Ztbjzvt1LKMQ3H8HkMPDH1AIBduYyRNjhwStBuY6NnKHCIwtslelTzds8yVe/WCbjhPkV9zwvz91Y3lfkJ4SLQ/Zgo3AxXKh7uy5se5ec5yQoNANUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jz1EOF6k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jz1EOF6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761919204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f/uCrgX+OGJ+oQaPXObOHzpwpu+AIJ0Z52pt9D9ZGSI=;
	b=Jz1EOF6kaVZ2FzapIo3PI6z8gyAfIvqGXe1q3y2d9qLwyNwU8QnSKprE/h2dvop4CP+nfL
	Zt/HnhjLMP4i62vm2SJ7zoMvdw3T+zYNXBDevMrPVGWiGQ2ziwRovwdd5e28V0Rb49SuiO
	N4fE0yOXOR/HehMbYwiJ9ogpzgmzxlE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-hHjy9suLOlGwYj9LAMm5Qg-1; Fri,
 31 Oct 2025 10:00:03 -0400
X-MC-Unique: hHjy9suLOlGwYj9LAMm5Qg-1
X-Mimecast-MFC-AGG-ID: hHjy9suLOlGwYj9LAMm5Qg_1761919201
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2A891955DC8;
	Fri, 31 Oct 2025 14:00:00 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.34])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 080F03000225;
	Fri, 31 Oct 2025 13:59:53 +0000 (UTC)
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
Subject: [PATCH v4 0/2] audit: improve NETFILTER_PKT records
Date: Fri, 31 Oct 2025 10:59:47 -0300
Message-ID: <cover.1761918165.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The first patch moves duplicated code from netfilter-related source
files to audit.c by creating two helper functions 'audit_log_packet_ip4'
and 'audit_log_packet_ip6'. The second one improves the NETFILTER_PKT
records, by including source and destination ports for protocols of
interest.

Ricardo Robaina (2):
  audit: add audit_log_packet_ip4 and audit_log_packet_ip6 helper
    functions
  audit: include source and destination ports to NETFILTER_PKT

 include/linux/audit.h    |   2 +
 kernel/audit.c           | 120 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  |  43 ++------------
 net/netfilter/xt_AUDIT.c |  43 ++------------
 4 files changed, 130 insertions(+), 78 deletions(-)

-- 
2.51.0

