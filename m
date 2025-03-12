Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9691EE7A5;
	Wed, 12 Mar 2025 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821503; cv=none; b=BJe/5P7UrEFhMtsxRs6enJiKxV5VlrTnGT9yfVNc4UWfsHeL5gMDAbFiu6fmpVvJHo8qHMIHgUbogqK6Pn2Ao4leMjfwKCkRPpkAzCZo3zcqHhhjJo46ZH1cXSbmXTso/kqKO2Ubo8X2+m4/ZGw3xRDh/2XPbAQgEjs9uGqIUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821503; c=relaxed/simple;
	bh=v0PYTOr0cbAzBC5hI12USGSJO8ueh3VNH79ZTTcJTJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V5rphS9w3sS/nzkbb4Pqk3EI7GyDQNtYBHr6rloIYluV2m1aOWZjQmyKD3k5H5D758bavEDTPqoclpl8eTW9cn+U7aSj//qebWkVt3Q9bXoZsdnDzlosaAsZNUxWf3e+iEHJrr/w71zAMi0JWB+m2PraNEQ2zdIn2HoXnMYw1f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sc3vcDsE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g33+qGIa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sc3vcDsE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g33+qGIa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 82F4F60292; Thu, 13 Mar 2025 00:18:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821500;
	bh=VDnOJXy/2wICqrYLy8sX8LIWXaLINl84rvnptC7UPJM=;
	h=From:To:Cc:Subject:Date:From;
	b=sc3vcDsEDtEZPyvIssoXFthRwm3eQbGOe6OYEEzcwrWiHm1aGsaosqsng+nDLpwxr
	 joIqljTbh/HVukFLqKyW4Gz+UXXEAh4FAUAl3R4rybt89O+/HRVyzZ1dqaw1o/VjwG
	 VEb/TdQMw6JDJ3ipSr+I3tYSYi/HnBnDmYuTK7uWAzkKsTFFSZ3M3jK0BBnVY7+zob
	 ZrG1V51u6FS2ybnhFReSzYxYqR1NlDrE/0xkU6fCfIECaJGweQ/YFYG+QVgPt/ezks
	 0Mucsv80854eqgckFQgkmID5w3knxdZa7NUqSa57cs5n5b3ns6dZ9+iSz7G4ss85xY
	 RK7uVBKEiVHyQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 799216028A;
	Thu, 13 Mar 2025 00:18:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821498;
	bh=VDnOJXy/2wICqrYLy8sX8LIWXaLINl84rvnptC7UPJM=;
	h=From:To:Cc:Subject:Date:From;
	b=g33+qGIaLUu6A2oDh9TfD3EzDonJyuw8bUFpWo7fHzQkm4NzIuEr/1SW0fSkhJ+t5
	 5dqKL4eQsdUEETsn5o9DC2mGDBMskmRP0WHYTMtHsJ4Q7lYncRT2F941S+c0UakooB
	 xLSTADNAogHTD4RONH5pzFpXoRXCgGsvsYbVIbvQWtZnkmJWMzomv4ot68o6muS6X0
	 Gre+dQ2cIqvrLeDxwAKhHZTh/vQTyU8j8ChQQl0XB+89CChY1KPmcEoDze88pTRVCh
	 VWOvcJ2vfGiNmi4pEVe3QNlEeHHoNaEpdL3fqD6++Y5O6P+PWIUN0e/lCCqrrdvALk
	 6V6t47FgMZ+Tw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/3] Netfilter/IPVS fixes for net
Date: Thu, 13 Mar 2025 00:18:09 +0100
Message-Id: <20250312231812.4091-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Missing initialization of cpu and jiffies32 fields in conncount,
   from Kohei Enju.

2) Skip several tests in case kernel is tainted, otherwise tests bogusly
   report failure too as they also check for tainted kernel,
   from Florian Westphal.

3) Fix a hyphothetical integer overflow in do_ip_vs_get_ctl() leading
   to bogus error logs, from Dan Carpenter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-03-12

Thanks.

----------------------------------------------------------------

The following changes since commit 77b2ab31fc65c595ca0a339f6c5b8ef3adfae5c6:

  MAINTAINERS: sfc: remove Martin Habets (2025-03-10 13:34:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-03-12

for you to fetch changes up to 80b78c39eb86e6b55f56363b709eb817527da5aa:

  ipvs: prevent integer overflow in do_ip_vs_get_ctl() (2025-03-12 15:48:26 +0100)

----------------------------------------------------------------
netfilter pull request 25-03-12

----------------------------------------------------------------
Dan Carpenter (1):
      ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Florian Westphal (1):
      selftests: netfilter: skip br_netfilter queue tests if kernel is tainted

Kohei Enju (1):
      netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

 net/netfilter/ipvs/ip_vs_ctl.c                              | 8 ++++----
 net/netfilter/nf_conncount.c                                | 2 ++
 tools/testing/selftests/net/netfilter/br_netfilter.sh       | 7 +++++++
 tools/testing/selftests/net/netfilter/br_netfilter_queue.sh | 7 +++++++
 tools/testing/selftests/net/netfilter/nft_queue.sh          | 1 +
 5 files changed, 21 insertions(+), 4 deletions(-)
