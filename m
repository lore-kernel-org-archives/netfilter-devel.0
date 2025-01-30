Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E04DB641;
	Thu, 30 Jan 2025 11:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738236809; cv=none; b=gUtFhoj9nM5LIwpnoBM02P4eYjKkQcrmS+R79CkYy0Lb9uW1A7Q9zvUubX8qEP7k84GJJhuGry+a0BpNGvdYZnlcjC+kWgnFw2l7Tq3jwEtwdmR61VzadnnZh//rStoiRQKccHfyWBQN1XEyHhCOXvKZ2PSH6xBtoqWCSQR+SSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738236809; c=relaxed/simple;
	bh=jLA3IBOoeXy+p40PzcoOSCRIiP22DZMY8Fasb0xDk8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OY7qYLzc9FXtzQJtTy37zVaqZLdL1jpCbNBl/4O4B2VESeM0MODi6LbON3iR8CHN33Dy5JXyLbgT9AkQGpW3Y0HL5fgBKB69MwQR7Cpcx/PZ7sTjq/r8mYs+q55gm/REpKptDaw+uH5L8TFwSWaPIjbN0RpaipBnIe+FkEJRV1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QHIwtBFd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NMOA7kk/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QHIwtBFd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NMOA7kk/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0FB9160275; Thu, 30 Jan 2025 12:33:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738236799;
	bh=segXuG9+L8tG9/8q/zl27uPvles2qZ9BPEcVv0LZ83o=;
	h=From:To:Cc:Subject:Date:From;
	b=QHIwtBFdaPv5I02NgIXQJxzS27Bnyb/dVLBl60PBWz5ceAgAAWhid2pw/0qkY8x14
	 osRipammPlpVnuM8hcysj4ytznmRPF/27YL/x6XRLANSAPaf8JsHW/tGW2YQb4F90O
	 B060Qc9gynBoJ25WSco/LN0AcC0JIDrphbltnUDwwvoiwfwxY9Sud64HvWr94engFo
	 nSJmuuz9StERpZXU/+O013Cbk1e50MpyU9+XiR08MBaG/rTWuaBDModMnPkdZdrKrg
	 XgrE5TJe1noF/5HUlB9pLvHD6bT7CNzdmjKzW1Z8qcPFEWKbeXMPcdZ+b4u7ZFrkfF
	 j0XLiw/HxdFUQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1080160275;
	Thu, 30 Jan 2025 12:33:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738236797;
	bh=segXuG9+L8tG9/8q/zl27uPvles2qZ9BPEcVv0LZ83o=;
	h=From:To:Cc:Subject:Date:From;
	b=NMOA7kk/3MgZiE4vxe4W24lX3lynuzpGtWrc1dQwYK1zLccnHTVeGS1BvgqmAXIdQ
	 6/P/ov4nFrLb8iyf56M2k0UPdQ8keIt0HWazs2ZbDU32R46djIlfllHoZln3wzEhIh
	 iBXqjr+DoXqCgHBIPcN71KF9+/s9Qnouq8kHwrippyym5SfRlF50E5Uqulg9Mkf2UY
	 7hxhetCthjQXPQFE4piS84GJnXdwpJx19n+X/zZKY57OVLF2hfsjo4mC1Z3pd2PMWF
	 w9LUI5/mSw/UG8zD7pY5ZzarE+/djO0AiA1NkZlxoobq9GRUdKF+fKfxbOXyBnw3Rb
	 8Ndnn0J6NAjgg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/1] Netfilter fixes for net
Date: Thu, 30 Jan 2025 12:33:06 +0100
Message-Id: <20250130113307.2327470-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains one Netfilter fix:

1) Reject mismatching sum of field_len with set key length which allows
   to create a set without inconsistent pipapo rule width and set key
   length.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-01-30

Thanks.

----------------------------------------------------------------

The following changes since commit 0a5b8fff01bde1b9908f00004c676f2e2459333b:

  selftests: net: Adapt ethtool mq tests to fix in qdisc graft (2025-01-15 09:28:51 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-01-30

for you to fetch changes up to 1b9335a8000fb70742f7db10af314104b6ace220:

  netfilter: nf_tables: reject mismatching sum of field_len with set key length (2025-01-30 12:26:11 +0100)

----------------------------------------------------------------
netfilter pull request 25-01-30

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_tables: reject mismatching sum of field_len with set key length

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
