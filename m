Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069B63BADB2;
	Thu, 16 Apr 2026 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345304; cv=none; b=mCDGLSCtOkZrVR1B3uZUvrJWkKU18jL83QkH7bFptNBYvtFF75gIttptJYhL/YEb3wj3cUZIXIsqyulzn4+YW4x78PwaDIF/LyHPTJNJBYx+kcHipcm5YkBSwHuYnfRcKa6RFPYlSIpAvNCKmJAn+qK77yiNgfDBuStz4OShEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345304; c=relaxed/simple;
	bh=MEkI7aITToFM51ZvKPF33ezO4om+Qb5bLtE2lW0njQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CGbKDZvrGXsDQ/QmPRLSQXrhVpMxK0qgwcri0wk0uGIQoh4ySxzPnQZyjZvesQzXSpHg8yS8jboY0+g24TKMC/BCk+KonDQSweniXsbDPSxHgV6YNqS51l7BUDpN6C4RPrYAKVc/IAjozTCeyhmDIXhNXJGhsAxOT6LuKHxosHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L0JqJq9a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L0JqJq9a"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18E1B60177;
	Thu, 16 Apr 2026 15:14:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345299;
	bh=9cPyt+zpIE+QtwPwtxpfK53WRIAEHMmlGYQFCYycX/E=;
	h=From:To:Cc:Subject:Date:From;
	b=L0JqJq9ap32ma4Xgyi8zIdyK1MwFu18hwN20RnlOtZl7yw/gL+s72BNPzTL2auI4V
	 7OWwpJqcoMz78SAOOqYnT00S2X1/Fafam7qfN96sxALtNKhT965q8DsMAoGXMyXFM9
	 i2h2rYR3fbzDn0GrMDj45Hr7QewSkXQq+LvZzOvE625mtGDj4Wj7b6X9Co9VqxX/Fn
	 Lj+4JlqaAtr9i/zp+mV7Yhi9eqO3JzxBnGhf/6f/ffO/dlaALEftlpfdVwoMqzZPhh
	 5GfUVZkR6+RtghRskPCeHyK658LizaWTNzkd0kOLgart+5mF0V9zy1rP8La/er2tFk
	 oW0w4Y+PgtidA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v2 00/11] Netfilter/IPVS fixes for net
Date: Thu, 16 Apr 2026 15:14:42 +0200
Message-ID: <20260416131453.308611-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: Keep back patches that have lengthy feedback by AI, they might
    need more work.

-o-

Hi,

The following patchset contains Netfilter/IPVS fixes for net: Mostly
addressing very old bugs in the SIP conntrack helper string parser,
unsafe arp_tables match support with legacy IEEE1394, restrict xt_realm
to IPv4 and incorrect use of RCU lists in nat core and nftables. This
batch also includes one IPVS MTU fix.

1) Fix arp_tables match with IEEE1394 ARP payload, allowing to
   reach bytes off the skb boundary, note that matching on the
   target address is deliberately ignored, patch from Weiming Shi.

2) Reject unsafe nfnetlink_osf configurations from control plane,
   this is addressing a possible division by zero, from Xiang Mei.

3) nft_osf actually only supports IPv4, restrict it.

4) Possible null-ptr-deref in nfnetlink_osf, check__in_dev_get_rcu
   return NULL, from Kito Xu.

5) Remove unsafe use of sprintf to fix possible buffer overflow
   in the SIP NAT helper, from Florian Westphal.

6) Restrict xt_mac, xt_owner and xt_physdev to inet families only;
   xt_realm is only for ipv4, otherwise null-pointer-deref is possible.

7) Use kfree_rcu() in nat core to release hooks, this can be an issue
   once nfnetlink_hook gets support to dump NAT hook information,
   not currently a real issue but better fix it now.

8) Fix MTU checks in IPVS, from Yingnan Zhang.

9) Use list_del_rcu() in chain and flowtable hook unregistration,
   concurrent RCU reader could be walking over the hook list,
   from Florian Westphal

10) Add list_splice_rcu(), this is required to fix unsafe
    splice to RCU protected hook list. Reviewed by Paul McKenney.

11) Use list_splice_rcu() to splice new chain and flowtable hooks.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-16

Thanks.

----------------------------------------------------------------

The following changes since commit 2dddb34dd0d07b01fa770eca89480a4da4f13153:

  net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers (2026-04-12 15:22:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-16

for you to fetch changes up to 985f517db19a734d4267e003438b5d6995669aff:

  netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase (2026-04-16 14:53:52 +0200)

----------------------------------------------------------------
netfilter pull request 26-04-16

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: remove sprintf usage
      netfilter: nf_tables: use list_del_rcu for netlink hooks

Kito Xu (veritas501) (1):
      netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl

Pablo Neira Ayuso (5):
      netfilter: nft_osf: restrict it to ipv4
      netfilter: xtables: restrict several matches to inet family
      netfilter: nat: use kfree_rcu to release ops
      rculist: add list_splice_rcu() for private lists
      netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Weiming Shi (1):
      netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()

Xiang Mei (1):
      netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO

Yingnan Zhang (1):
      ipvs: fix MTU check for GSO packets in tunnel mode

 include/linux/rculist.h           | 29 ++++++++++++++++++++++
 net/ipv4/netfilter/arp_tables.c   | 14 ++++++++---
 net/ipv4/netfilter/iptable_nat.c  |  2 +-
 net/ipv6/netfilter/ip6table_nat.c |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c   | 19 +++++++++++---
 net/netfilter/nf_nat_amanda.c     |  2 +-
 net/netfilter/nf_nat_core.c       | 10 +++++---
 net/netfilter/nf_nat_sip.c        | 33 ++++++++++++++-----------
 net/netfilter/nf_tables_api.c     | 52 +++++++++++++++++----------------------
 net/netfilter/nfnetlink_osf.c     |  7 ++++++
 net/netfilter/nft_osf.c           |  6 ++++-
 net/netfilter/xt_mac.c            | 34 ++++++++++++++++---------
 net/netfilter/xt_owner.c          | 37 +++++++++++++++++++---------
 net/netfilter/xt_physdev.c        | 29 ++++++++++++++--------
 net/netfilter/xt_realm.c          |  2 +-
 15 files changed, 184 insertions(+), 94 deletions(-)
