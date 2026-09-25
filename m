Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2C041836E
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345494; cv=none; b=JVqbfaHehWYpqPxc15Bb30iXLkLpNByX58M7hSD5Y4fm8nm6SOK3HcDy217FfuBEPd6DrEOclbfvwvHgSqDQEVv+KeVIixST3ViSf06DDCUtMw1DakrN3PJyd9ey6/n3Ut1sZ4OK7XOwMKROzaTyLqt1NiY4ZzwEjcBzRPCMiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345494; c=relaxed/simple;
	bh=dndpdC1BFf2YzxpLiKezMO4GTZISkuWDrKJcbkUpd/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o61N/KGUaJZev34f8pa1J5pBba1ZpOhk6fko+TIaDbdUkTYLbSjS1jDvXg1f7ONN5Rz1lcFCbTt0Kvdjes+M/HupzF2JHnJVmHbeZOEHENjR6W3++g41gsGyxUWFoNcKxSy6XnSB0SoaLv08rhinnRIRu2BrzDyEky0mAEK+r3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com; spf=pass smtp.mailfrom=agilebits.com; dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b=uE2R0+c1; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b="uE2R0+c1"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfd70b08cso110490285a.2
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1790345491; x=1790950291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J3Lllhowz5xAm041vYg/0uhyYfJTfX7BTIf91ZP5MNU=;
        b=uE2R0+c1d0HLIki2Xoh4xJsjMAYRdFM9de9SkPZDS/HH10hgHz17ckVXxqPEsT7WpO
         TJENKPEVEBcJAilbP47sjLvNkL5TPZtyiKE+gjJF1hyE37bsx6EgFj80yGt0TifVUUmA
         pfPD4PXZ0F8a/NfcNoGjpY75+Yj7O/B62Us1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345491; x=1790950291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J3Lllhowz5xAm041vYg/0uhyYfJTfX7BTIf91ZP5MNU=;
        b=kw3fNSKqJayYmR5vtrfgymyH1oFMVC707dqCwWiIC9ljSUYpKJ6EEtfQDnJh9AmSVK
         fkXn/iylzK+uuQJENIvz18tUV927RSRY22HA+0Nkb0KC9J3pZwJPjNYtRX1kpX1wwY9H
         GzYiHO0DEnYo0yx3fDKNysekPpieG7gGvG9Zuz/Z4Lcx+ru7z9b+OqRnvojb2BkOTH2M
         1VbgbYEfKOOoJInBxtn+miT8dhAnlgAPqJFKfbdXJzF5B4DJVnJXavK1iEfCTfWl3S0E
         qxQ+4aFD0tHQQlqohTPaJgtX+qPraWLs4Rln8jcywGdYVRfAX8LjjuP2iAOQTIH8ruQw
         je1w==
X-Forwarded-Encrypted: i=1; AKwUvBzDeEZKEaJj9EdnnPIUN/8dknsgchL8nL1e+UoZlyWUuh2/SugZfLxP4CAaoNa0wjp2PDQ+X33yrP09b0vIHOU=@vger.kernel.org
X-Gm-Message-State: AFuF++mPgovcJ7uvcgqIu5WuKakesJ9hBp0EoooGzFM/vUtg0s6/0/L/
	1DCb7K17JQrLB3QGc2u6T2P3hNhUNurAKYBaDQyZX49kwvj2I/MSwVK2167+kRbYH/4=
X-Gm-Gg: AYBFou01bYxZHE9wzHr8uRUQnlvZbycWiDlBzOEY4uBW0nXnd/wQmSgSF4nV6LgP11G
	S1dZkVADG1ARofZbcWNpcOJB4YuosM1dpqksTkbxwAroiMpf3VR6toqqXacLa4i2AMeTXprlggO
	mqQ3BXCwsLafuECxWVkfC7K3e7viVew5tLwAF7gipE2wonC+9RN4138T3xgE/e2Hc++8BdOGOTd
	7GLw9Y6+ao7amCMAVoYQIssTzL7oTMSm/3T0E4r7P9io3epasnnJJBQET6kiUDByfZ+QW90NWdr
	pzGiMYdGmhDsAURGSeIrNzxHzWmH4qh80Ppq/pmUDtNNIraFUmPa4wjdquEq0zGr08dTqI+fzGa
	+gIOy8PBy5iEXmgehQaxicVw1HzEIs49eFsqm2kNY8kXx8FNtpilokqT1bgDd36fZe9MQHwwrWp
	qDlh0AIiYNHHfaaIgYpvJaG2KyToCN4AfgGnngYuvbjzufah05q+PfyNF0fb7vT5Q9A7j/hqoKW
	zq+bQyspia2JdqYC+j935NtVG+wshXsgCT5+VBa
X-Received: by 2002:a05:620a:3706:b0:939:6de8:43de with SMTP id af79cd13be357-93c475124cbmr376847185a.50.1790345490729;
        Fri, 25 Sep 2026 07:11:30 -0700 (PDT)
Received: from localhost ([2600:4041:59c3:300:7917:c7f6:28c6:182b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c4493ec1csm187075685a.30.2026.09.25.07.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 07:11:30 -0700 (PDT)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Willy Tarreau <w@1wt.eu>,
	Keith Hoodlet <keith.hoodlet@1password.com>,
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH nf 0/2] ipvs: keep templates and cport 0 conns away from packet lookups
Date: Fri, 25 Sep 2026 10:11:13 -0400
Message-ID: <20260925141115.16126-1-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A template received over the unauthenticated sync protocol with a
nonzero cport is matched by data packets in ip_vs_conn_in_get() and
the protocol state machine runs on it. Patch 1 rejects sync records
with inconsistent cport and IP_VS_CONN_F_NO_CPORT combinations on
the backup.

Patch 2 requires a nonzero cp->cport in ip_vs_conn_out_get() so that
templates and connections still waiting for their cport cannot be
matched through the out hook.

The companion patch "ipvs: filter some flags received in the backup
server" rejects template records carrying IP_VS_CONN_F_NO_CPORT.

Axel Mierczuk (2):
  ipvs: validate cport in received sync records
  ipvs: skip cport 0 connections in ip_vs_conn_out_get()

 net/netfilter/ipvs/ip_vs_conn.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

-- 
2.43.0

