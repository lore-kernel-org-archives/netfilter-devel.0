Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BBA213244;
	Thu, 13 Feb 2025 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739441125; cv=none; b=cjh8CRsES4j5qscElW/kqknAPNfgWPk8RTxPGKRmn0PvrFUgN/UaYuaeQaB/LcKcScjv0RN1Of8NjIfOxntYuifHwd449j5IGtjcyc0sXXvowuOKDMW+lCgueBXvBxXPp2ruLB4tENUaLIxM4cK0ebbaAnGmQct4Niaa2NvR9/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739441125; c=relaxed/simple;
	bh=knOoCyqKBam6Pf0TCdS+SFILRF2xIiNlVO7MLrcfpCI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ddA2oESHPjN5/BqXxfHwNwik+LzpLdCAZNrHTkT+keuDgpz1KG00CyGnqV57Aeag4vjUeOA+NgMvbtN+h2DtE+t28Yf99svPGXwVxSXB+OK1TgU8FkltS3p1ZzEFJr1sKtLrkHIiQ0pCmV8OlGuM+0lxULboI1jr8eIjJiysFsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nJqs8vBA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nUg2jIhN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nJqs8vBA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nUg2jIhN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F2283603AA; Thu, 13 Feb 2025 11:05:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739441115;
	bh=swm0n+eXf4Aw19LZqJrL1ixb0Ye++eEGcYlKWWhEWrU=;
	h=From:To:Cc:Subject:Date:From;
	b=nJqs8vBA00Onmi2Yp0/N1e7WgGMITiQiZWBJDixxSazGynmBE7nnkpvMZ5q+vtgFw
	 F9NkB/qo78maSJK75wl6zfO0OYAggoh6DzfKc4EmUVW+jf9E2NtjAVrDDAPjlSPqDv
	 J5+G22YkMGCyUqAcGi9OOmmt/XZG+piPwDnoPBuNdh73aB8x6XU9PsX3JB99PHK14S
	 Bw8kjevVPmE/SEaEN4Nm9+oYO7co0QP1E6rTGi1n3klol8VU6BCjwqnj1A1gK8GGEo
	 tEEHnwqOIhSozZxVhz79q156kDvaoD1JCeLmbelwuQvfKhuA1gVWlodY1W9BDhEKBr
	 wX0UiWgS0CErw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05B8C603AA;
	Thu, 13 Feb 2025 11:05:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739441113;
	bh=swm0n+eXf4Aw19LZqJrL1ixb0Ye++eEGcYlKWWhEWrU=;
	h=From:To:Cc:Subject:Date:From;
	b=nUg2jIhNLmjEXvfp88oF++rB/L4SRyAkSO2RG0h/BU8ShEyPvuBWgIMvIwrrvYdYN
	 30iAb1sRGCt7MiR7M6yeksqWFZ4K3ih6wMo40caFeOh5wmybEi/405P/9CvBaa8XDz
	 ws7VPeoiDaXiAkpfVZbeNI5sCQkce5bq5Pd+bR47welAqVNiMDpnFxhheqy9BOpuSl
	 tVnPz0ounh1G6lzBrTXyOgeZLnbfGIdIJHOeKchclvnETHQJNmYzrxQ/fFdMANPciO
	 oqpL/QwQWer+DT0eat2RMPHCRyOd07HWrV0XTaKjOJxcb1AIaouiDiDM6pp2X42gLY
	 gSI3tnTky6Mgg==
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
Date: Thu, 13 Feb 2025 11:05:01 +0100
Message-Id: <20250213100502.3983-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains one revert for:

1) Revert flowtable entry teardown cycle when skbuff exceeds mtu to
   deal with DF flag unset scenarios. This is reverts a patch coming
   in the previous merge window (available in 6.14-rc releases).

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-02-13

Thanks.

----------------------------------------------------------------

The following changes since commit e589adf5b70c07b1ab974d077046fdbf583b2f36:

  iavf: Fix a locking bug in an error path (2025-02-11 18:02:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-02-13

for you to fetch changes up to cf56aa8dd26328a9af4ffe7fb0bd8fcfa9407112:

  Revert "netfilter: flowtable: teardown flow if cached mtu is stale" (2025-02-12 10:35:20 +0100)

----------------------------------------------------------------
netfilter pull request 25-02-13

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      Revert "netfilter: flowtable: teardown flow if cached mtu is stale"

 net/netfilter/nf_flow_table_ip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
