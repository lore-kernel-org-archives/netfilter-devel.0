Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED283F39ED;
	Mon, 17 Aug 2026 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009407; cv=none; b=eaRdrsawkTVQJwFutkm0Ezn1EYktj+9r1JVeW2ZJrRQknC+OWfq/ZbLnM4vpD4ovjBeG1xQRZnb6xz9wz8ZtIAv6SPwjKWMJTfPF/lXNm92J32mRR/lm9bWYborzchg9YSGsGydJbS6e8AYqOv02NBXBLlsJBwukFXxHZ71JmjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009407; c=relaxed/simple;
	bh=MTKB7tTmUDdfywsdQFsR/u1BaseDJbxTBBfOWhLSZLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XUbqxZK48C1wd/rls/X4mA7ZWpgPchkrV4cS3Lft5VelV549CBEnc4ZMEPrgxlttER0gLcadOcVf+1/tAfFUIo9OmMZL9UXKWTXcizim29FndSG7ECHGXmQp3+oBanLJM7Et16gsOYuHUGtwhdCgZO6UWzRS3lDg+SDF1TNuI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QHcyyaRC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QHcyyaRC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009403;
	bh=4cp4h9Bw2QyzOtLYfquZKWar6kzy1eJNiOtjb54qfws=;
	h=From:To:Cc:Subject:Date:From;
	b=QHcyyaRCLuwygCNFZ83EJWX1dWumfgE/BQ1LBOyt+Gj5FAo+zo9BXOLdkZ8pFaQP9
	 umbut0b5fSWjdUv0lPcGWMkHHs0OLwszseKEP96QfVhg/c99JlN9Nh+jhpQo4sctl3
	 xLM6wolQBcnA17iJ90ph/BR4ALfeKsseeA4th9LFDkwwTrroEHbncoeWsOInLs1C/a
	 SW1TMsRdRiT+W2PAFDcj0ADlFVoKfQNpKcY+Z/2JMZ0sLp8DpVedkuS63DsG4ZCWoF
	 xEUcrPWK1Svc0fwGvfephrhMH0UcbvuhiA8GB8aAvk/E9CLvjbqv6d9C0yL/8/g0Cd
	 2xbGE5zocwyfw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 055EA6005F;
	Tue, 18 Aug 2026 01:30:02 +0200 (CEST)
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
Subject: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
Date: Tue, 18 Aug 2026 01:29:49 +0200
Message-ID: <20260817232957.1281637-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net-next,
I am targetting this tree since 7.2 has been already released.
This contains fixes for nf_tables, revisit issues with expectation
infra updates reported by sashiko, an ipset fix for deletions in the
hash:net type and tne fix for the IPVS FTP helper.

1) Validate layer 4 header mangling done via nfnetlink_queue and
   nft_payload, this is a follow up to recent similar validation
   at layer 3. From Zhiling Zou.

2) Do not allocate memory on delete operations in ipset hash:net
   type, delete operation must always succeed. From Florian Westphal.

3) Deliver nft_obj overquota packet path notification directly via
   nfnetlink, do not use the control plane batch logic.
   From Fourie Zhang.

4) Follow up to controlidate check for reinserted dead expectations,
   to cover the nf_conntrack_expect_related_pair() function too.

5) Do not expose expectation dead flag to userspace via ctnetlink.

6) Make commit set_update_list per-netns to prepare to publish
   set clone earlier.

7) Publish the set clone earlier from commit path to address set
   lookup failures during table re-creation, this is targetting
   the rbtree and pipapo set backends.

8) Fix an integer overflow in the IPVS FTP helper. A similar fix
   was already proposed for the conntrack FTP helper months ago.
   From Joas Antonio dos Santos. 

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-08-18

Thanks.

----------------------------------------------------------------

The following changes since commit e6a5d573d24cd375e09d24f136523cb3cc85c9d3:

  net: dsa: drop explicit NULL comparisons (2026-08-14 13:57:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-08-18

for you to fetch changes up to e625a9477d12baaff4025c5f9989184a907ea8fc:

  ipvs: fix integer overflow in ftp helper port/address parsing (2026-08-18 00:56:43 +0200)

----------------------------------------------------------------
netfilter pull request 26-08-18

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: ipset: remove need to allocate memory on delete operations

Fourie Zhang (1):
      netfilter: nf_tables: don't queue packet path object notifications

Joas Antonio dos Santos (1):
      ipvs: fix integer overflow in ftp helper port/address parsing

Pablo Neira Ayuso (4):
      netfilter: nf_conntrack_expect: consolidate check for insertion of dead expectation
      netfilter: ctnetlink: do not expose expectation DEAD flag
      netfilter: nf_tables: move set_update_list to nftables per-netns
      netfilter: nf_tables: call set ops .commit when building new ruleset blob

Zhiling Zou (1):
      netfilter: validate L4 headers after userspace packet writes

 include/net/netfilter/nf_tables.h            |   1 +
 net/netfilter/ipset/ip_set_hash_gen.h        | 168 +++++++++++++++++++--------
 net/netfilter/ipset/ip_set_hash_netiface.c   |   1 -
 net/netfilter/ipset/ip_set_hash_netportnet.c |   1 -
 net/netfilter/ipvs/ip_vs_ftp.c               |  10 +-
 net/netfilter/nf_conntrack_expect.c          |  11 +-
 net/netfilter/nf_conntrack_netlink.c         |   2 +-
 net/netfilter/nf_tables_api.c                | 137 +++++++++++++---------
 net/netfilter/nfnetlink_queue.c              |  72 +++++++++++-
 net/netfilter/nft_payload.c                  |  13 +++
 10 files changed, 302 insertions(+), 114 deletions(-)
