Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC291C695;
	Wed,  1 Apr 2026 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039816; cv=none; b=tfoOO6dmIsAAIeCBGyNO8Typ3/w9g+dFJiB7rsqJbxGFpg97AxZ7RX/2K+qakp3KqoFdmhPCMo8RvXsgDbywpzHmL1MwqBKeBu2HoEaPhGT7/lFUhuoMIlf4y/CX/xZ0YJ5Ja3YAKhMpUsbWtHdMUx8bUNVksVzESvfgnUUqyME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039816; c=relaxed/simple;
	bh=1HOx6BUSEq2OFADcmPatZWH6VbebSuyevjBF2o3Zkyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGsFRsiCg+ylBVLwTsx07sqFGQyPPT87qAqtJc/noMB9UeQN48heYZ+/u5y+y3bdBcSWWJ0z71pSq1kWPmRFRiwiEIbf29RngXac6YbZ6g8Ao5rK0szma1SnCi+r8+4Pnvol+zWockaZXA247TtLD2jSitugqbeDxWuUmtM0BbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lRcjEbGn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lRcjEbGn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ACF5F60272;
	Wed,  1 Apr 2026 12:36:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039811;
	bh=FsHrFEwnqHPKqzYwwTu9EJWsb+O/RwvszyzvJg61j6w=;
	h=From:To:Cc:Subject:Date:From;
	b=lRcjEbGnKBWEQUl8kpMDzl9F7fTTzZQhbgIOchMLtv0Tr8oA8dtjr9D3pILFbUnTY
	 OEcI6EWYl7VeukAkEYvX5qFwUuyQQBQAnP8WVolr/xsrG0QAz/GKEk9T3J+94G+86K
	 zM5nAZFLVAdHupg/rMp0xKt6d3q+MCcm5Dqjcx+mwI6KdN5scE+reVcYBRdsmNcl5n
	 df3xptqrO9Dcr9JViY/760YyGR2f4QRZOoSe1K2XGT5UJ18PnohLGhnKE3lhD3EC7I
	 EOhHiz87FD/kORs+Blp1PrNBZIERMlDgRZ9Ai1xrtq6ZlH4G/LMSsxlAlaBT3hzm8B
	 ehXRO4vkuWQMw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/10] Netfilter fixes for net
Date: Wed,  1 Apr 2026 12:36:36 +0200
Message-ID: <20260401103646.1015423-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net. Note that most
of the bugs fixed here are >5 years old.  The large PR is not due to an
increase in regressions.

1) Flowtable hardware offload support in IPv6 can lead to out-of-bounds
   when populating the rule action array when combined with double-tagged
   vlan. Bump the maximum number of actions from 16 to 24 and check that
   such limit is never reached, otherwise bail out.  This bugs stems from
   the original flowtable hardware offload support.

2) nfnetlink_log does not include the netlink header size of the trailing
   NLMSG_DONE message when calculating the skb size. From Florian Westphal.

3) Reject names in xt_cgroup and xt_rateest extensions which are not
   nul-terminated. Also from Florian.

4) Use nla_strcmp in ipset lookup by set name, since IPSET_ATTR_NAME and
   IPSET_ATTR_NAMEREF are of NLA_STRING type. From Florian Westphal.

5) When unregistering conntrack helpers, pass the helper that is going
   away so the expectation cleanup is done accordingly, otherwise UaF is
   possible when accessing expectation that refer to the helper that is
   gone. From Qi Tang.

6) Zero expectation NAT fields to address leaking kernel memory through
   the expectation netlink dump when unset. Also from Qi Tang.

7) Use the master conntrack helper when creating expectations via
   ctnetlink, ignore the suggested helper through CTA_EXPECT_HELP_NAME.
   This allows to address a possible read of kernel memory off the
   expectation object boundary.

8) Fix incorrect release of the hash bucket logic in ipset when the
   bucket is empty, leading to shrinking the hash bucket to size 0
   which deals to out-of-bound write in next element additions.
   From Yifan Wu.

9) Allow the use of x_tables extensions that explicitly declare
   NFPROTO_ARP support only. This is to avoid an incorrect hook number
   validation due to non-overlapping arp and inet hook number
   definitions.

10) Reject immediate NF_QUEUE verdict in nf_tables. The userspace
    nft tool always uses the nft_queue expression for queueing.
    This ensures this verdict cannot be used for the arp family,
    which does supported this.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-01

Thanks.

----------------------------------------------------------------

The following changes since commit dc9e9d61e301c087bcd990dbf2fa18ad3e2e1429:

  Merge branch 'net-enetc-add-more-checks-to-enetc_set_rxfh' (2026-03-27 20:56:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-01

for you to fetch changes up to da107398cbd4bbdb6bffecb2ce86d5c9384f4cec:

  netfilter: nf_tables: reject immediate NF_QUEUE verdict (2026-04-01 11:55:30 +0200)

----------------------------------------------------------------
netfilter pull request 26-04-01

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: nfnetlink_log: account for netlink header size
      netfilter: x_tables: ensure names are nul-terminated
      netfilter: ipset: use nla_strcmp for IPSET_ATTR_NAME attr

Pablo Neira Ayuso (4):
      netfilter: flowtable: strictly check for maximum number of actions
      netfilter: ctnetlink: ignore explicit helper on new expectations
      netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP
      netfilter: nf_tables: reject immediate NF_QUEUE verdict

Qi Tang (2):
      netfilter: nf_conntrack_helper: pass helper to expect cleanup
      netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent

Yifan Wu (1):
      netfilter: ipset: drop logically empty buckets in mtype_del

 include/linux/netfilter/ipset/ip_set.h |   2 +-
 net/netfilter/ipset/ip_set_core.c      |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h  |   2 +-
 net/netfilter/ipset/ip_set_list_set.c  |   4 +-
 net/netfilter/nf_conntrack_helper.c    |   2 +-
 net/netfilter/nf_conntrack_netlink.c   |  60 +++-------
 net/netfilter/nf_flow_table_offload.c  | 196 ++++++++++++++++++++++-----------
 net/netfilter/nf_tables_api.c          |   7 +-
 net/netfilter/nfnetlink_log.c          |   2 +-
 net/netfilter/x_tables.c               |  23 ++++
 net/netfilter/xt_cgroup.c              |   6 +
 net/netfilter/xt_rateest.c             |   5 +
 12 files changed, 192 insertions(+), 121 deletions(-)
