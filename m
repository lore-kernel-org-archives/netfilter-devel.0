Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8A22A7EE;
	Thu, 17 Apr 2025 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744885744; cv=none; b=OOGmsqJAEhbWLBfhvaXLvBormJltYDhFzyNfZJJ9xBRUK1f+lbUzJGW4g+GFDwZnZfhZTEQZILet7AdAWfD4nuDytJZUX0odZUvKSllRCDkBa+ftOp34DMHrQz1zjr+JhHA56oRV4CTbJ6ifPKkkWFwWfZOI+OlojYZhc5rJn/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744885744; c=relaxed/simple;
	bh=7jxHShpFm6Z2VAWyLlL/XiprNJLm2BAfjnRhNB4Oi/8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p7z2AP0v2HzG837su80zgLtsHK89MM9zalw10ZppVGgNHQd2l/xE94NJJ0J+X8WsySTJfMASy8R0eQNT8Y1cZB9ANKXK550gn/F78sivWWEfSCln9Ldd7gCulbW9J2fw3AZavaEtx76rIJaA4coiny1HUtxgVtJQLFjSdZNvSAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QCCNCawh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d4ku+ecg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QCCNCawh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d4ku+ecg"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3FE4A60A2E; Thu, 17 Apr 2025 12:28:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744885734;
	bh=qNWEyvplqwgTuMjOyvtyC6xpXitih0oSumB2e1UiNTE=;
	h=From:To:Cc:Subject:Date:From;
	b=QCCNCawhzGUVUkE3l9GMEjmQc+ST2upVxHWkvCwLZMhXX/L8P/ECk+k7vdrIWLPb5
	 BVpJxzz4D8iZL22O1AbHP+sPmBrIKA0V6NqbdgzV9+c6iZvR04jDgh0YtlcVrAm/RJ
	 pXYd9N3xHJstILgKrKmVTrL1qhvSgCC+I/rJ8zQY1NN0aZ9X9ZdETpP9xX8JmoHAdf
	 QEapUn/2Wn7odY887lCDeCrYsyXuVnP4w4O7Suq+kgE+MXUc/KYA7Rt/DcIaaoX0ns
	 LkB4aRqqXR/SIvsCCjRHfhmpK2flh4Gv4HlpiK5E7sh1n/X1E73U7uqH5mOJKNFW71
	 O5+4LKkS4HyKg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5F4B9607D7;
	Thu, 17 Apr 2025 12:28:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744885731;
	bh=qNWEyvplqwgTuMjOyvtyC6xpXitih0oSumB2e1UiNTE=;
	h=From:To:Cc:Subject:Date:From;
	b=d4ku+ecgFyW9rZCH6wao/vHJorEF0bts2NnvYWB0Zp3jBkuVZPyVkh1TceOObQJYw
	 Td8e7OyNKzjlYqkJrRcA2we4GaysgOg3LTkUk7yd2GaVPaVsSV6oW14XAlgA0Gg6KB
	 PXJSFK3pRfOshcyup9MQTXKFj+DgIcRXNcLXv2e0PpylKAWV5PkC2LkdZ3W+OKE8hZ
	 H5vrtPEOifv/BBt3efxRq2P1GmDNa6xLv/aPkG0qn1fl0ypWtNGEH3iAyDqW/qxs+u
	 tL7Y+tEOwgGOhYhrraDC52emwEuyPl47CsCDgSzUBRrsXfhZHFCq46NxIY0L7ofOsS
	 1d/KX9p84TMUQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/1] Netfilter fix for net
Date: Thu, 17 Apr 2025 12:28:46 +0200
Message-Id: <20250417102847.16640-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains one Netfilter fix for net:

1) conntrack offload bit is erroneously unset in a race scenario,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-04-17

Thanks.

----------------------------------------------------------------

The following changes since commit 747fb8413aaa36e4c988d45c4fe20d4c2b0778cd:

  netlink: specs: ovs_vport: align with C codegen capabilities (2025-04-14 14:05:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-04-17

for you to fetch changes up to d2d31ea8cd80b9830cdab624e94f9d41178fc99d:

  netfilter: conntrack: fix erronous removal of offload bit (2025-04-17 11:14:22 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-17

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix erronous removal of offload bit

 net/netfilter/nf_flow_table_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
