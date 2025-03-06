Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991CA18E054;
	Thu,  6 Mar 2025 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275303; cv=none; b=QtVoYMPTjRj6wPUslaQbD3GOnd48YiTH8bRYcXZ5p/OmTnl5lTSFAElZ1GX02wNUHgS6oCY9hO/scKALN0QiX+wBUvRQAF3PuiignN0OmhKE0z/a8w9Mlvq55UMHVhqB32DfOLVAZjj1RdKgQVJurFISIzu0gBWHbvAI3SqL9tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275303; c=relaxed/simple;
	bh=SIMrxnR6CRgdLuJ43aqdD5f3kYmdlm/srJC0O33eMQE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sLPHBhgI2RCblMnOjKlZNEU2I8KUttKu+kYBbAiJ89XUhTd5mrR3uIHKkY/xxqHCZ8nMEDg8CudrVM7JgF9MDJ9WJzM9Ro6XRyhNMjjePp7AGjepnjnV6pPNeduhL9dxlL2gNNo1r7fkI/eVFqGV/UIHDOLEfKGkdbImyeUmvio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gr69QlAM; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bW5lT3xQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gr69QlAM";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bW5lT3xQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5A02D602FF; Thu,  6 Mar 2025 16:34:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275292;
	bh=ubsqguGlhFw0mjx+KC1rrow+/cN6Y0E/ZO8cgSci2rA=;
	h=From:To:Cc:Subject:Date:From;
	b=gr69QlAMOQc7KhfqJiRwFItBlCe9AvEZk9IpI9m4UmCzRYLCKYgFb7qDenT8S3OfF
	 CIPXIFcYkSsVPNdE9RkY+uD+6RDzU5jfBMb0a59T9746tLkzWSS+cUk2qlkHPmAHWD
	 pe9Ee9siKg7TfrcO2WhSsGTSu/81pyGUO7fOle7tpIZvInsvlfoBfqKamVuA5z0GLR
	 uWjwoKdZaJBmHZgKXyUtpzBkFhepAdG0js2bjwpI2AdgT10Xt76CdBZwgOQB1ZUh7c
	 hdhC+Oj0SoltifFvHWlglfPiUdfdjhqj0q3vK/sIOQfK8hvM6WLcejq4ep7roZACOb
	 NCpm20OVzD+9A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 43672602FF;
	Thu,  6 Mar 2025 16:34:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275290;
	bh=ubsqguGlhFw0mjx+KC1rrow+/cN6Y0E/ZO8cgSci2rA=;
	h=From:To:Cc:Subject:Date:From;
	b=bW5lT3xQSO/5SJGVAmMkBiuh+0xfPXX5SdiwEUTWy3N+1FNjEYvIHUXB8qGqHtkVD
	 LZ2nx5qg/HHKxNwmQ+h5VOq4PKqJgvgrv55S0f7vL+M9J8JQZSv0W8BGddGK6P8HhJ
	 ZOsvwL5635OSCws4uVjqNlYB2nGYEd4mG1COmUbXbBwaGXE6YBhVJCI1LAohDccP2w
	 NSnFFFmkgmRJdTqG3L49+o0P9lRgIVdHsLbR5CMyV3Le6N0iArjQ1a26qgyy+Ik598
	 kC8cbRDnfSxBNozMCbDp2986lseiPX4xPclKYfmIAGp+YEWMBQBlEDNBywfM8GjRqY
	 eDYwaGjM89b8w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu,  6 Mar 2025 16:34:43 +0100
Message-Id: <20250306153446.46712-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix racy non-atomic read-then-increment operation with
   PREEMPT_RT in nft_ct, from Sebastian Andrzej Siewior.

2) GC is not skipped when jiffies wrap around in nf_conncount,
   from Nicklas Bo Jensen.

3) flush_work() on nf_tables_destroy_work waits for the last queued
   instance, this could be an instance that is different from the one
   that we must wait for, then make destruction work queue.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-03-06

Thanks.

P.S: This is coming late after net-6.14-rc6, please, apply after your
pending pull request is accepted. Thanks.

----------------------------------------------------------------

The following changes since commit a466fd7e9fafd975949e5945e2f70c33a94b1a70:

  caif_virtio: fix wrong pointer check in cfv_probe() (2025-02-28 18:04:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-03-06

for you to fetch changes up to fb8286562ecfb585e26b033c5e32e6fb85efb0b3:

  netfilter: nf_tables: make destruction work queue pernet (2025-03-06 13:35:54 +0100)

----------------------------------------------------------------
netfilter pull request 25-03-06

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: make destruction work queue pernet

Nicklas Bo Jensen (1):
      netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around

Sebastian Andrzej Siewior (1):
      netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.

 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_conncount.c      |  4 ++--
 net/netfilter/nf_tables_api.c     | 24 ++++++++++++++----------
 net/netfilter/nft_compat.c        |  8 ++++----
 net/netfilter/nft_ct.c            |  6 ++++--
 5 files changed, 27 insertions(+), 19 deletions(-)
