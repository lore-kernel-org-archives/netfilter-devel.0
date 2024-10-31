Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30A2199EB4;
	Thu, 31 Oct 2024 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368886; cv=none; b=qV0YUj4inppcVtCqciJky9OrttMTR0Li7QMgVh+kukjvndh4M8NukmXrO45iQS+/8ecAarl9dkBn0n5g5FMKJBlZ5qiuYXNb5uZA+SOCtDkzxPaGMPV03xaEVSrokNrGHP6iVerg8a/f5Au6N1xt77aBQqBKcSRlUS6NJqrn2wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368886; c=relaxed/simple;
	bh=tfXDb+GCUP3rBMJ5V0fONdt5PvVF5GuLaJAzsjaywlI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eb9Cb2uuLXiOFDWP0BYWyjYd1orcxj7JOhEx+fetfw1gMXlPlrvU0IWsT7uqbOjHSNGmzMNovakdGotAJpy3cqvRaA8tTOhphJmNOFJjFFHLFIA1ta1dgCSbcheTcarIFVbSQGwowgh+8+EGEuh6jCFCvn35dDLlp8pn7HpNEtE=
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
Date: Thu, 31 Oct 2024 11:01:13 +0100
Message-Id: <20241031100117.152995-1-pablo@netfilter.org>
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

1) Remove unused parameters in conntrack_dump_flush.c used by
   selftests, from Liu Jing.

2) Fix possible UaF when removing xtables module via getsockopt()
   interface, from Dong Chenchen.

3) Fix potential crash in nf_send_reset6() reported by syzkaller.
   From Eric Dumazet

4) Validate offset and length before calling skb_checksum()
   in nft_payload, otherwise hitting BUG() is possible.

Please, apply,
Thanks.

Dong Chenchen (1):
  netfilter: Fix use-after-free in get_info()

Eric Dumazet (1):
  netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()

Liu Jing (1):
  selftests: netfilter: remove unused parameter

Pablo Neira Ayuso (1):
  netfilter: nft_payload: sanitize offset and length before calling
    skb_checksum()

 net/ipv6/netfilter/nf_reject_ipv6.c               | 15 +++++++--------
 net/netfilter/nft_payload.c                       |  3 +++
 net/netfilter/x_tables.c                          |  2 +-
 .../net/netfilter/conntrack_dump_flush.c          |  6 +++---
 4 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.30.2

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-31

Thanks.

----------------------------------------------------------------

The following changes since commit c05c62850a8f035a267151dd86ea3daf887e28b8:

  Merge tag 'wireless-2024-10-29' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2024-10-29 18:57:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-10-31

for you to fetch changes up to d5953d680f7e96208c29ce4139a0e38de87a57fe:

  netfilter: nft_payload: sanitize offset and length before calling skb_checksum() (2024-10-31 10:54:49 +0100)

----------------------------------------------------------------
netfilter pull request 24-10-31

----------------------------------------------------------------
Dong Chenchen (1):
      netfilter: Fix use-after-free in get_info()

Eric Dumazet (1):
      netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()

Liu Jing (1):
      selftests: netfilter: remove unused parameter

Pablo Neira Ayuso (1):
      netfilter: nft_payload: sanitize offset and length before calling skb_checksum()

 net/ipv6/netfilter/nf_reject_ipv6.c                       | 15 +++++++--------
 net/netfilter/nft_payload.c                               |  3 +++
 net/netfilter/x_tables.c                                  |  2 +-
 .../selftests/net/netfilter/conntrack_dump_flush.c        |  6 +++---
 4 files changed, 14 insertions(+), 12 deletions(-)
