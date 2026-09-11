Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8EF469822;
	Fri, 11 Sep 2026 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116295; cv=none; b=jiyxvIfyW4bzJk83v+9uDpwzUSbIOYAgLHxtX+aQfovqYOq2wfMcW6zJkUZKlLKImDgJiLpwmNTaYYVwdXavMn6iiF6n/boQeXGkHXnuFVtTqE69iEQmB4pCRKOfe7U4QBwYiHeUufZIUPz2IMrCtpeSmxwG35NCN+LIxufGy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116295; c=relaxed/simple;
	bh=zRzcU964LZWEASYl1MNmuq07iuC6MSz83mUby5AP0Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aa4YCSLsrBpyWcSVyUxfDzqc34gRmQ5TBstiOIb462UApkHTm7aNpo5VdQ3GaOLT2nBjDerBZJkfBP2Rh1oen+5bJvmXOqQpBdxca5b7xHv6PHvgWpH2uLTR8F35UwqAlYkTyzOwGOWqRKkeF8R7IxqYyRSuVWVoArNhydriUts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dvMpwJra; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dvMpwJra"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116283;
	bh=snsXlGtiY7F7hdfz883GLVxAEjUikbIz5e0P7GuET6k=;
	h=From:To:Cc:Subject:Date:From;
	b=dvMpwJra+tufpBLOT8k1gssK9wHvJIvdPz/Ua/sijX60/e3bJH/ociJ4Dm9Sos6aM
	 zADrhliF7XCC1o2+V3EyP/NrgFA5xcZUXLjfI60zDtSYELEg5Uy0zOyHZwG4VPyzBD
	 Bjmt9Sr1nt/CD97yRFhq/Ox9Cj1cjioSz4746OOWm/QikvqxXMFd68tHIVJjHI6i7/
	 uvXio6FQ9tVAR7bA+VblWUrHSMJ0Drwj0P69gfmEhbhD1brfTwHR0IDq+wwUo7+o5z
	 K8dRP247NEQGIaVtYbRhqzPCKnli7LMyOckhc0Mc7RA61Aaz6fJjFBSpDM/7chuPdT
	 W8Vn022G2hqPw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 903C26017D;
	Fri, 11 Sep 2026 10:44:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 0/8] Netfilter updates for net-next
Date: Fri, 11 Sep 2026 10:44:29 +0200
Message-ID: <20260911084437.1838161-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next:

1) No need to hold spinlock when ct seqadj is NULL, from Fernando F. Mancera.

2) A series of patches to use GFP_KERNEL_ACCOUNT in x_tables matches
   and targets, nfnetlink, nf_tables, synproxy, sysctl, nat and conncount
   for better integration with memcg. This will surely need more follow
   ups but this gfp flag has been used in this tree over the time anyway.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-09-11

Thanks.

----------------------------------------------------------------

The following changes since commit 348ea4642f56ab3dc93621c8e3ab0ccd0e5f1782:

  selftests: net: add ctl_file_write() helper (2026-09-10 18:46:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-09-11

for you to fetch changes up to 0e28586ee444ae85513c09a7a211483c540df9f5:

  netfilter: conncount: use GFP_KERNEL_ACCOUNT (2026-09-11 10:31:09 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-11

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: seqadj: do not take ct lock if seqadj is NULL

Pablo Neira Ayuso (7):
      netfilter: x_tables: use GFP_KERNEL_ACCOUNT in match/target
      netfilter: nfnetlink: use GFP_KERNEL_ACCOUNT
      netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
      netfilter: synproxy: use GFP_KERNEL_ACCOUNT
      netfilter: sysctl: use GFP_KERNEL_ACCOUNT
      netfilter: nat: use GFP_KERNEL_ACCOUNT
      netfilter: conncount: use GFP_KERNEL_ACCOUNT

 net/netfilter/nf_conncount.c            |  2 +-
 net/netfilter/nf_conntrack_ovs.c        |  2 +-
 net/netfilter/nf_conntrack_seqadj.c     | 11 +++++------
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nf_hooks_lwtunnel.c       |  2 +-
 net/netfilter/nf_log.c                  |  2 +-
 net/netfilter/nf_nat_core.c             |  5 +++--
 net/netfilter/nf_synproxy_core.c        |  2 +-
 net/netfilter/nfnetlink_acct.c          |  2 +-
 net/netfilter/nfnetlink_cthelper.c      |  3 ++-
 net/netfilter/nfnetlink_cttimeout.c     |  8 +++++---
 net/netfilter/nfnetlink_osf.c           |  2 +-
 net/netfilter/nft_ct.c                  |  5 +++--
 net/netfilter/nft_set_pipapo.c          |  6 +++---
 net/netfilter/xt_CT.c                   |  6 +++---
 net/netfilter/xt_IDLETIMER.c            |  8 ++++----
 net/netfilter/xt_LED.c                  |  5 +++--
 net/netfilter/xt_RATEEST.c              |  2 +-
 net/netfilter/xt_TEE.c                  |  2 +-
 net/netfilter/xt_hashlimit.c            |  4 ++--
 net/netfilter/xt_limit.c                |  2 +-
 net/netfilter/xt_quota.c                |  2 +-
 net/netfilter/xt_recent.c               |  3 ++-
 net/netfilter/xt_statistic.c            |  2 +-
 net/netfilter/xt_string.c               |  2 +-
 25 files changed, 49 insertions(+), 43 deletions(-)
