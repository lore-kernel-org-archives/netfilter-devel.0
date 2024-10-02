Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D152215F7C;
	Wed,  2 Oct 2024 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727900675; cv=none; b=ZlpS/BIs8YSX0rh+fE0apc3tl3c0KkrERkZVD5tr0adkkghEm8XxnTdVLY6eJ4w7D5wpE8xu6twdtJClAZ+ksMKhThlnirnjsNMZbbtqWCrKcNOljJunQov6S8XAl2EsK5jG3AFc5kzoioGNVS4mQd7crBqe6dcDyew1QT+ZytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727900675; c=relaxed/simple;
	bh=M/wS5qOlbHxG0TKdNeWXqt/qdNOUTgl5pG06WeWEOpY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NtxO+t/D0vB8XrWO1z/J4m7CRIYLmvm37J0fcu65ngAgezfG5D/VLgJnAGUVYtuxXP3PY9z7ceAyAE8yA+FnOJRcpcrL0RrnvodEyHBC0Ava4+PlKg6kplvcE6693Q1Ly25SNFx+/qVJpgYbxE2F5HfTqj3rik0q3fvx9icKv4Q=
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
Subject: [PATCH net 0/4] Netfilter fixes for net
Date: Wed,  2 Oct 2024 22:24:17 +0200
Message-Id: <20241002202421.1281311-1-pablo@netfilter.org>
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

1) Fix incorrect documentation in uapi/linux/netfilter/nf_tables.h
   regarding flowtable hooks, from Phil Sutter.

2) Fix nft_audit.sh selftests with newer nft binaries, due to different
   (valid) audit output, also from Phil.

3) Disable BH when duplicating packets via nf_dup infrastructure,
   otherwise race on nf_skb_duplicated for locally generated traffic.
   From Eric.

4) Missing return in callback of selftest C program, from zhang jiao.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-02

Thanks.

----------------------------------------------------------------

The following changes since commit aef3a58b06fa9d452ba863999ac34be1d0c65172:

  Merge tag 'nf-24-09-26' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2024-09-26 15:47:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-02

for you to fetch changes up to 10dbd23633f0433f8d13c2803d687b36a675ef60:

  selftests: netfilter: Add missing return value (2024-09-27 13:59:12 +0200)

----------------------------------------------------------------
netfilter pull request 24-10-02

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: nf_tables: prevent nf_skb_duplicated corruption

Phil Sutter (2):
      netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
      selftests: netfilter: Fix nft_audit.sh for newer nft binaries

zhang jiao (1):
      selftests: netfilter: Add missing return value

 include/uapi/linux/netfilter/nf_tables.h           |  2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c                   |  7 ++-
 net/ipv6/netfilter/nf_dup_ipv6.c                   |  7 ++-
 .../selftests/net/netfilter/conntrack_dump_flush.c |  1 +
 tools/testing/selftests/net/netfilter/nft_audit.sh | 57 +++++++++++-----------
 5 files changed, 41 insertions(+), 33 deletions(-)
