Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF073A264;
	Wed, 31 Jan 2024 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741995; cv=none; b=Zwi5HYkh7I/fWsk3VQM5ZOktE3bGkvrILyc6jTAnt2bnaqU8W6ZLs+OFzxpy1vjRIepN5ijdllcnSccyxY5nkm85fskKeYhV6CQifAZtfARu50XcBGcQhAeced4otW+BHnSn+cSiBWK9MJEnLwOIVkR/q8mH30ATiiO0gfPoSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741995; c=relaxed/simple;
	bh=JSobfHDL3HfCukNSvg2IMXFxbVDY6qKy30+RqA6pwFU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IwGT+R6gWRWrZOEgL/V2VE6ipKuiY2PonqZ+0WsNHVLh7P+/fCAc6keqT5S2e86Ec/GLpf17MeYoAzoSCHbYZNHydCP7pMlNvVmk6hSUsMcviQN9o3XRdZgAI/ZKqr58e8AilKNNENi7uJuJBGu1yGpZ5AEFC0fBHANq7Wa5yns=
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
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Wed, 31 Jan 2024 23:59:37 +0100
Message-Id: <20240131225943.7536-1-pablo@netfilter.org>
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

1) TCP conntrack now only evaluates window negotiation for packets in
   the REPLY direction, from Ryan Schaefer. Otherwise SYN retransmissions
   trigger incorrect window scale negotiation. From Ryan Schaefer.

2) Restrict tunnel objects to NFPROTO_NETDEV which is where it makes sense
   to use this object type.

3) Fix conntrack pick up from the middle of SCTP_CID_SHUTDOWN_ACK packets.
   From Xin Long.

4) Another attempt from Jozsef Kadlecsik to address the slow down of the
   swap command in ipset.

5) Replace a BUG_ON by WARN_ON_ONCE in nf_log, and consolidate check for
   the case that the logger is NULL from the read side lock section.

6) Address lack of sanitization for custom expectations. Restrict layer 3
   and 4 families to what it is supported by userspace.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-01-31

Thanks.

----------------------------------------------------------------

The following changes since commit a2933a8759a62269754e54733d993b19de870e84:

  selftests: bonding: do not test arp/ns target with mode balance-alb/tlb (2024-01-25 09:50:54 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-01-31

for you to fetch changes up to 8059918a1377f2f1fff06af4f5a4ed3d5acd6bc4:

  netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations (2024-01-31 23:14:14 +0100)

----------------------------------------------------------------
netfilter pull request 24-01-31

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix performance regression in swap operation

Pablo Neira Ayuso (3):
      netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
      netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
      netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations

Ryan Schaefer (1):
      netfilter: conntrack: correct window scaling with retransmitted SYN

Xin Long (1):
      netfilter: conntrack: check SCTP_CID_SHUTDOWN_ACK for vtag setting in sctp_new

 include/linux/netfilter/ipset/ip_set.h  |  4 ++++
 include/net/netfilter/nf_tables.h       |  2 ++
 net/netfilter/ipset/ip_set_bitmap_gen.h | 14 ++++++++++---
 net/netfilter/ipset/ip_set_core.c       | 37 +++++++++++++++++++++++++--------
 net/netfilter/ipset/ip_set_hash_gen.h   | 15 ++++++++++---
 net/netfilter/ipset/ip_set_list_set.c   | 13 +++++++++---
 net/netfilter/nf_conntrack_proto_sctp.c |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c  | 10 +++++----
 net/netfilter/nf_log.c                  |  7 ++++---
 net/netfilter/nf_tables_api.c           | 14 ++++++++-----
 net/netfilter/nft_ct.c                  | 24 +++++++++++++++++++++
 net/netfilter/nft_tunnel.c              |  1 +
 12 files changed, 112 insertions(+), 31 deletions(-)
