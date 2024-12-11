Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151F21C07D8;
	Wed, 11 Dec 2024 23:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733958103; cv=none; b=stuUsO1PQVRGpl+4ZaJHYRFs2Ec2m5rXiBKGtnDRCl5dcK2tyEbuop/mGEeeFiNvR6ybLzjdpYw2pnI8qRMcUuGcOCOVF8/qI+Ra0XKdvpAt0YBLqWeZZ3k/c0fAnrLbXRDXm6mlMSUDk6Uc5q0YQXrsCL3VYNfg9K0fUA+haxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733958103; c=relaxed/simple;
	bh=42T/xrKErMOh83l9sTZL+EWwQ1rbLEDjNUpsmsm/yNY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lCOupSJ7/z7bSgQbLpBNw6Y9ixSfnlb3ywThPJDclmHZ4lVobOGFzKQnpW2qWs/r0tPgkLjUXw68cAsGrtE5VPQgeH327SyZV8oKuCjHyhQWw/Iltzu01hMFrZqEbq5oqxNmFWjx5VmGwi5MARZfobfw2+6lRl/u8ac1oL2+OwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	phil@netfilter.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu, 12 Dec 2024 00:01:27 +0100
Message-Id: <20241211230130.176937-1-pablo@netfilter.org>
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

1) Fix bogus test reports in rpath.sh selftest by adding permanent
   neighbor entries, from Phil Sutter.

2) Lockdep reports possible ABBA deadlock in xt_IDLETIMER, fix it by
   removing sysfs out of the mutex section, also from Phil Sutter.

3) It is illegal to release basechain via RCU callback, for several
   reasons. Keep it simple and safe by calling synchronize_rcu() instead.
   This is a partially reverting a botched recent attempt of me to fix
   this basechain release path on netdevice removal.
   From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-12-11

Thanks.

----------------------------------------------------------------

The following changes since commit 31f1b55d5d7e531cd827419e5d71c19f24de161c:

  net :mana :Request a V2 response version for MANA_QUERY_GF_STAT (2024-12-05 12:02:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-12-11

for you to fetch changes up to b04df3da1b5c6f6dc7cdccc37941740c078c4043:

  netfilter: nf_tables: do not defer rule destruction via call_rcu (2024-12-11 23:27:50 +0100)

----------------------------------------------------------------
netfilter pull request 24-12-11

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: do not defer rule destruction via call_rcu

Phil Sutter (2):
      selftests: netfilter: Stabilize rpath.sh
      netfilter: IDLETIMER: Fix for possible ABBA deadlock

 include/net/netfilter/nf_tables.h              |  4 --
 net/netfilter/nf_tables_api.c                  | 32 ++++++++--------
 net/netfilter/xt_IDLETIMER.c                   | 52 ++++++++++++++------------
 tools/testing/selftests/net/netfilter/rpath.sh | 18 ++++++++-
 4 files changed, 59 insertions(+), 47 deletions(-)
