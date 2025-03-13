Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445B14900B;
	Thu, 13 Mar 2025 09:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741859810; cv=none; b=WZtgjjmQ78Qv9Ra+kIuQEVZ7AxoMKL1ys/9eQHLKghfWESDjutfqLAoDHsg0WHboqy+cWANOctpS/leIBHQ3lFHUSh5ejzCLQWLpef9MjbvoZEgb/heyERTDHVNFIFZ0xpqtGpOToxLOb2P2k28jlQMeyeeWz4nu2IJsn7uC2B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741859810; c=relaxed/simple;
	bh=nCJM9JttCQhuM8i09sT6rLLIH4ZDegDc50g9MLprn2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D3DzZzsP+WP4elv4lgGmlsgiazuGkuyT9fiPSYN4ohAoQbCsI2/6irx/6C9fCsRDzXHf6G8xBoFrU1yP3+h2RrVjZJKoIItq7J15LQnaIFKbxd0uwq6pVwbRQpq5U8CpS89fylE3s3GwDGJwo+wXVObcepUb6s9fAXMyP2EtV2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f9hiEG2E; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LKLpI98v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f9hiEG2E";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LKLpI98v"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 82E72602A4; Thu, 13 Mar 2025 10:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859803;
	bh=vzQBH46HV+tyPy22K9hIC57UwVaCxAOhp9cJl9au10M=;
	h=From:To:Cc:Subject:Date:From;
	b=f9hiEG2EqrlBg3eN3Bqgead5r5gqv5RLjwAXrX5k2ult1doBXBnZFqNM7ZnLXeWcp
	 D3MpsHz5NsPS5WT5gke6B10TafbM+8GeVak7DpGF6e2dIg0H9YoVrrAdu+Idggx2Iw
	 9Z0i9pyOfnrC3cjgNepyjDaXNkF9qcTNorj1JNMErrMq5aMLSpjaec0chCL6D6aYT5
	 9RTa0aTQwZbJK+k4HvcgZZMKB6jGVPsK4Y4TMu276GfpjRCa+d9xDXecUOy9uBmQXq
	 2C7LxKAN9C+NVrGHt9PxhgwP+O4cA1qLTXwESdn/ApvEZqP23n4nZSFWbkBG0VLVZH
	 CQ2vrJaSJgemQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E6A3F6028B;
	Thu, 13 Mar 2025 10:56:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859801;
	bh=vzQBH46HV+tyPy22K9hIC57UwVaCxAOhp9cJl9au10M=;
	h=From:To:Cc:Subject:Date:From;
	b=LKLpI98vByM0ja3k469oQj0T02f4oOX5z60lMFRO3dpEt2N4I4hViadMmTaI5a9Jg
	 6Dc3TGHVFFYKWpvMKou/hr+gPOB3ivNhFSsPIIDYXDPNFkDU8WHrwu8XTVEkICRPFj
	 2Pp9OjA0Zd1IId3t+Sjzj47puwW3kIwOhdheMVjBPxDwIIaWxrTnTokFuvJiv2ELEs
	 L9gHH74HsK5vxZ6cMpUtQVmMY7ImizpAsTuvBDkO7iGWiArj9uXIFnReYst+d9vxCN
	 CxydR5l36100xzzPkAvNE9548m5yhEJr1Gr+FlSx9I4r38P7x9uPYH98kpGuACVyhC
	 8btoX9kB8kP1w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v20/4] Netfilter/IPVS fixes for net
Date: Thu, 13 Mar 2025 10:56:32 +0100
Message-Id: <20250313095636.2186-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 including one more fix for ipv4 option match in nft_exthdr.

-o-

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Missing initialization of cpu and jiffies32 fields in conncount,
   from Kohei Enju.

2) Skip several tests in case kernel is tainted, otherwise tests bogusly
   report failure too as they also check for tainted kernel,
   from Florian Westphal.

3) Fix a hyphothetical integer overflow in do_ip_vs_get_ctl() leading
   to bogus error logs, from Dan Carpenter.

4) Fix incorrect offset in ipv4 option match in nft_exthdr, from
   Alexey Kashavkin.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-03-13

Thanks.

----------------------------------------------------------------

The following changes since commit 77b2ab31fc65c595ca0a339f6c5b8ef3adfae5c6:

  MAINTAINERS: sfc: remove Martin Habets (2025-03-10 13:34:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-03-13

for you to fetch changes up to 6edd78af9506bb182518da7f6feebd75655d9a0e:

  netfilter: nft_exthdr: fix offset with ipv4_find_option() (2025-03-13 10:02:39 +0100)

----------------------------------------------------------------
netfilter pull request 25-03-13

----------------------------------------------------------------
Alexey Kashavkin (1):
      netfilter: nft_exthdr: fix offset with ipv4_find_option()

Dan Carpenter (1):
      ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Florian Westphal (1):
      selftests: netfilter: skip br_netfilter queue tests if kernel is tainted

Kohei Enju (1):
      netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

 net/netfilter/ipvs/ip_vs_ctl.c                              |  8 ++++----
 net/netfilter/nf_conncount.c                                |  2 ++
 net/netfilter/nft_exthdr.c                                  | 10 ++++------
 tools/testing/selftests/net/netfilter/br_netfilter.sh       |  7 +++++++
 tools/testing/selftests/net/netfilter/br_netfilter_queue.sh |  7 +++++++
 tools/testing/selftests/net/netfilter/nft_queue.sh          |  1 +
 6 files changed, 25 insertions(+), 10 deletions(-)
