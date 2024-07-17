Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1DA4688;
	Wed, 17 Jul 2024 21:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253152; cv=none; b=TABTmG3VA4hU//6XsFBK5gSvfDkqvT1TbCW111RAyt4vbqh7oGiHXKyvtrAnXlddVBrn/8I59Kzg1eK38pjc6/Ae4UsWRS7IRRbcociG1tJpU9VcKBb6Xcd4GR9H6wHIwtptA+PhNzYXEHFMQ8NNvmfiXwoKB37coImFeaPQc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253152; c=relaxed/simple;
	bh=o0r2F8MGADtwb3HqdZ0hBA7CkYpCqyqtQ0hmIWgrjWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IiMY/A5IEUeNcp55FXDBztnQpoQ7I4w1mUFytrPRej6hvvSqom6rstWPz/I/milvivwTPt03b+UnDJbUstRRXEyFmiiu15yi3KMA1kTr04RJOwQnLML5Ob/4PEltX3/PqTrrgXB33EY0X/NwX32vuXupQQjj+glxkL4O4ZscvtU=
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
	fw@strlen.de
Subject: [PATCH net 0/4] Netfilter/IPVS fixes for net
Date: Wed, 17 Jul 2024 23:52:10 +0200
Message-Id: <20240717215214.225394-1-pablo@netfilter.org>
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

1) Call nf_expect_get_id() to delete expectation by ID. By trial and
   error it is possible to leak the LSB of the expectation address on
   x86_64. This bug is a leftover when converting the existing code
   to use nf_expect_get_id().

2) Incorrect initialization in pipapo set backend leads to packet
   mismatches. From Florian Westphal.

3) Extend netfilter's selftests to cover for the pipapo set backend,
   also from Florian.

4) Fix sparse warning in IPVS when adding service, from Chen Hanxiao.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-07-17

Thanks.

----------------------------------------------------------------

The following changes since commit 0e03c643dc9389e61fa484562dae58c8d6e96d63:

  eth: fbnic: fix s390 build. (2024-07-17 06:25:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-07-17

for you to fetch changes up to cbd070a4ae62f119058973f6d2c984e325bce6e7:

  ipvs: properly dereference pe in ip_vs_add_service (2024-07-17 23:38:17 +0200)

----------------------------------------------------------------
netfilter pull request 24-07-17

----------------------------------------------------------------
Chen Hanxiao (1):
      ipvs: properly dereference pe in ip_vs_add_service

Florian Westphal (2):
      netfilter: nf_set_pipapo: fix initial map fill
      selftests: netfilter: add test case for recent mismatch bug

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: use helper function to calculate expect ID

 net/netfilter/ipvs/ip_vs_ctl.c                     | 10 +--
 net/netfilter/nf_conntrack_netlink.c               |  3 +-
 net/netfilter/nft_set_pipapo.c                     |  4 +-
 net/netfilter/nft_set_pipapo.h                     | 21 ++++++
 net/netfilter/nft_set_pipapo_avx2.c                | 10 +--
 .../selftests/net/netfilter/nft_concat_range.sh    | 76 +++++++++++++++++++++-
 6 files changed, 111 insertions(+), 13 deletions(-)
