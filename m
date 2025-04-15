Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388612DFA41
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731919; cv=none; b=YWTpMAyQWa5q1msL2qa4wl4LEbrbZYFsi4NurB9VYN1A68G79g2fYk7RBJB07t/hYZ6rd6n649mgCrnOD9kiioesY8EUvwEADq3n1Dfch7xKu4ZDDAXjG4YLmyVGmB7NacNax/bGG9bD1Ln3Cl+un0iR3WB9mL71EXt5LI4rT6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731919; c=relaxed/simple;
	bh=UhlupsiS/Feh/BKzmRy0voOQZ5HKkmyPdf5rnf016A0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=awnwMamrfqNIXL+Sj33MCpJoAGCj5wQ5gfxztsuXpa0Nj05GwzixGHT2fM/gWm+IYXTyvt0KtEY4EiuRpsMTmsPmyOqef07geCmPQmnIUWdefN0KPHcUpC75bU6l8QbRZ9BJPJXAQohyppI7r8aRBaJ29XuDPd3UFUV+DAAO2aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WZw+R10k; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WZw+R10k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O9iuVW7QtDs5HM7adDohTy4UxSO7eRB3nypJTJ1cp5Y=; b=WZw+R10kcqP1jHfG4h7pvGOOe/
	FrZhdU5+fKetCsH4RmKq2JhEHBxOdlz2htgVPsDl3Q1Uz47dsuQHJuLLn6WSZMeDYSyASwevuyFaQ
	JCaVOQJOPOUU8aBbUADGyOd/8p17nZPzAZRORBivH1llpLYkU718s5osyriRuD8ZnSpm6+WF93mVx
	6naXJRsHdTjrTZJZ6hQ3frgqLOlmpshCUwO+iCJPkkmR3pYt8cZgSY1X+3GkVCB/xGhuuaM8lrtPD
	6MUluv3cEV1S7MwXCqlwmMfTKJp7cVpCKaC7upjsDBR1y/aeMqVg6NCF5Sexdci9067pRvKje0ENE
	WkQikjqg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iTL-0000000050c-3uzf;
	Tue, 15 Apr 2025 17:45:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Date: Tue, 15 Apr 2025 17:44:28 +0200
Message-ID: <20250415154440.22371-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v5:
- First part split into separate series (applied and present in Linus'
  git already).
- Add nft_hook_find_ops_rcu() in patch 2 already to reduce size of patch
  5.
- New patch 4 to reduce size of patch 5.
- New patch 6 preparing for patch 7 which in turn combines identical
  changes to both flowtables and netdev chains.

Patches 1-5 prepare for and implement nf_hook_ops lists in nft_hook
objects. This is crucial for wildcard interface specs and convenient
with dynamic netdev hook registration upon NETDEV_REGISTER events.

Patches 6-9 leverage the new infrastructure to correctly handle
NETDEV_REGISTER and NETDEV_CHANGENAME events.

Patch 10 prepares the code for non-NUL-terminated interface names passed
by user space which resemble prefixes to match on. As a side-effect,
hook allocation code becomes tolerant to non-matching interface specs.

The final two patches implement netlink notifications for netdev
add/remove events and add a kselftest.

Phil Sutter (12):
  netfilter: nf_tables: Introduce functions freeing nft_hook objects
  netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
  netfilter: nf_tables: Introduce nft_register_flowtable_ops()
  netfilter: nf_tables: Pass nf_hook_ops to
    nft_unregister_flowtable_hook()
  netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
  netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
  netfilter: nf_tables: Respect NETDEV_REGISTER events
  netfilter: nf_tables: Wrap netdev notifiers
  netfilter: nf_tables: Handle NETDEV_CHANGENAME events
  netfilter: nf_tables: Support wildcard netdev hook specs
  netfilter: nf_tables: Add notications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/linux/netfilter.h                     |   3 +
 include/net/netfilter/nf_tables.h             |  12 +-
 include/uapi/linux/netfilter/nf_tables.h      |  10 +
 net/netfilter/nf_tables_api.c                 | 394 ++++++++++++++----
 net/netfilter/nf_tables_offload.c             |  51 ++-
 net/netfilter/nft_chain_filter.c              |  95 ++++-
 net/netfilter/nft_flow_offload.c              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 151 +++++++
 9 files changed, 587 insertions(+), 132 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.49.0

