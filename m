Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455041A265C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143725; cv=none; b=PQFaplwcX46Xe5JppcNDXQeD1VojpJVCKpNGIv7D72C016uMsD1Rs9SH250Ph0aOkjPyy2lRuGdJgO10fTBG2CPhFVSpZHGoIuv3uNr+VQ+5AH9qji9JIh9Ky1uwovrIGAFIcsVi9O1kHv0oxdDcoV2Zr1ZdB6Yx+BKLBBdovDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143725; c=relaxed/simple;
	bh=IYfCQP1vXiLZfPbmoe7mXdNsyBmYZtcUc1LfKZ8fQLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mkJtYpWkI+tQdcHoMJMd7z5VJyFEycdXQ/Vk08b3nzTkOW2d/AiBnDNR5WVD2DXvSzV4nHdNglb88FgE6AVhPWQ5Q8wLYz+RNCpoeMuLzVw4nz9iBmes0Qlr9cLu60OBqS6bAtrcp+JlFc9TtjfL2hfj93dmvy9Sx9/mfYHAPOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EQMeJn/l; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EQMeJn/l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=694+CEP3ibCw8tbtyAO03S+g0pP9dzpRAV5ZQV1VVt4=; b=EQMeJn/l7g9XWYar4Pg7spfME5
	nFjbzAXs9OXxAaSt7WnQyVeTA9qHJEC+j96zBQvVTKbLg9l8sZCYTN7DC9gVIDcLyWyzJfI9XYNnP
	dNypA99x0mpSLu4qrdAq9bTR/ohWgpRzmwy4MV7SXGuMgDA+Jm7/Ihfsi3dyCFDeHNT9qJ+m13FaR
	eHG+IOCpn6jr2eIRds+sGfJou5jz445xsM2cAJHb0ZzAWeY1rK4wwb30WLEy9hl+Vjoq0epNzz407
	kDKOwjQbI5CeaI/zsCxGpwfz0+NsRNaH74eywMQQ/xo17dAedMkixbFfON/9NvVrGyW/J/IDZyvEo
	GgdLlpdg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipl-000000004Eo-0mH1;
	Thu, 12 Sep 2024 14:22:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 00/16] Dynamic hook interface binding
Date: Thu, 12 Sep 2024 14:21:32 +0200
Message-ID: <20240912122148.12159-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2:
- Practically complete rewrite with wildcard interface spec support

The first two patches of this series are fixes to existing code but
cause conflicts if not applied in order. They may go into nf tree as
well, though only the first one is a real bug and seems to be of low
impact.

The next three patches introduce external storing of the user-supplied
interface name in nft_hook structs to decouple code from values in
->ops.dev or ->ops value in general.

Patch 6 eliminates a quirk in netdev-family chain netdev event handler,
aligns behaviour with flowtables and paves the way for following
changes.

Patches 7-10 prepare for and implement nf_hook_ops lists in nft_hook
objects. This is crucial for wildcard interface specs and convenient
with dynamic netdev hook registration upon NETDEV_REGISTER events.

Patches 11-13 leverage the new infrastructure to correctly handle
NETDEV_REGISTER and NETDEV_CHANGENAME events.

Patch 14 prepares the code for non-NUL-terminated interface names passed
by user space which resemble prefixes to match on. As a side-effect,
hook allocation code becomes tolerant to non-matching interface specs.

The final two patches implement netlink notifications for netdev
add/remove events and add a kselftest.

Phil Sutter (16):
  netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
  netfilter: nf_tables: Flowtable hook's pf value never varies
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Use stored ifname in netdev hook dumps
  netfilter: nf_tables: Compare netdev hooks based on stored name
  netfilter: nf_tables: Tolerate chains with no remaining hooks
  netfilter: nf_tables: Introduce functions freeing nft_hook objects
  netfilter: nf_tables: Introduce nft_hook_find_ops()
  netfilter: nf_tables: Introduce nft_register_flowtable_ops()
  netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
  netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
  netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
  netfilter: nf_tables: Handle NETDEV_CHANGENAME events
  netfilter: nf_tables: Support wildcard netdev hook specs
  netfilter: nf_tables: Add notications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/linux/netfilter.h                     |   2 +
 include/net/netfilter/nf_tables.h             |  11 +-
 include/uapi/linux/netfilter/nf_tables.h      |   5 +
 net/netfilter/nf_tables_api.c                 | 386 +++++++++++++-----
 net/netfilter/nf_tables_offload.c             |  51 ++-
 net/netfilter/nft_chain_filter.c              |  64 +--
 net/netfilter/nft_flow_offload.c              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 149 +++++++
 9 files changed, 508 insertions(+), 163 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.43.0

