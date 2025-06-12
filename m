Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F962512DD
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735266; cv=none; b=q2flsmCRuBffyE8W+Ha6Z7n+YUton7G8lou1zEvbY8cMwqAqbPUwAwD+Vvf16EwlP9eoRuH1RXeUVbZ3hqpxts13vj+yWMPCU/R12veFgZsl9hO0tZH69H0pRVl6XU/uEtYyEX9l4OwRIpQrRlTB/rpTcjnGsnoD795jLbuh8Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735266; c=relaxed/simple;
	bh=7QX2Tv8UfqWuyz/F5500TefisF0YesiGJIr5YRXT9UI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rtTDZiWsbXtoUnAJCMNxOGZTpyI3fF5NN/MG/Rv4GW+x405Sx+1eKXYBJ4a0qR+Onp40EFKm8UXL59/ANk2Jkaq8tWzTyJjjB62hc91nAqhSutDBuoKB8GgkWhurv5EdKIrdEJSKwktEIpT9Npge6Mh8JkjE4xSBP+P5DHP/99U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FTzJwac8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FTzJwac8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+OLECkmAF0n64s0dpfChnbxrWAB5Ue2g2WDQ5boe0mI=; b=FTzJwac8W1/eqbO+A5iNRS2xJM
	Z/VZnZnH0FaclDc8xZeLgY0m8NhZklPOyAaQcmn19Pv7DkmUyD4N0qciXHC3NuCW72dXUbDQMa/oR
	AwYzEx6SXRVXhw2+ZuQfD9ahKkRRFG+scQMIlC1/7IwnvGmWbFSc1Y2foXJowtcrcKC7psbWIcBVm
	ggjRMQk16oZ7pOFBsYtKkTf0ZWwtk/TiMzOq/MJYSGTCxSx18/PHe8IHFrZZMWohHBpDJH5mg1Qyn
	P1gszAQrOf8I4yPpOsBVAEyVydbmpYTVFdEmK9tc7/q+xTi8rO2iiwXEIPHz60Pp4fcU53NgZiw8h
	h0Lhb9qA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPi4T-000000000rr-3sJ9;
	Thu, 12 Jun 2025 15:34:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/3] netfilter: nf_tables: Report found devices when creating a netdev hook
Date: Thu, 12 Jun 2025 15:34:13 +0200
Message-ID: <20250612133416.18133-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, NEWDEV/DELDEV notifications were emitted for new/renamed
devices added to a chain or flowtable only. For user space to fully
comprehend which interfaces a hook binds to, these notifications have to
be sent for matching devices at hook creation time, too.

This series extends the notify list to support messages for varying
groups so it may be reused by the NFNLGRP_NFT_DEV messages (patch 1),
adjusts the device_notify routines to support enqueueing the message
instead of sending it right away (patch 2) and finally adds extra notify
calls to nf_tables_commit() (patch 3).

Phil Sutter (3):
  netfilter: nf_tables: commit_notify: Support varying groups
  netfilter: nf_tables: Support enqueueing device notifications
  netfilter: nf_tables: Extend chain/flowtable notifications

 include/net/netfilter/nf_tables.h |   3 +-
 net/netfilter/nf_tables_api.c     | 160 ++++++++++++++++++++++++++----
 net/netfilter/nft_chain_filter.c  |   2 +-
 3 files changed, 144 insertions(+), 21 deletions(-)

-- 
2.49.0

