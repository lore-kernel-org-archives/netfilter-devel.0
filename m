Received: from out-utut-a194.jellyfish.systems (out-utut-a194.jellyfish.systems [198.177.127.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B794EC659
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.177.127.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612954; cv=none; b=aDQi9vWy9GBvOPN7vdoXl/WOrWtROx5bWHyEiK+SL56F5krYFjffihtKkTflIglKbBf+mmnb0MW3qfMPRINZUy03QMnJ4TUUxbkRzbaWc+iYXK8Ajrkpx7peBK9ki+0ja9i/jqogJhuffkB9sAct8hjfiCUYgk00JLysQ+OwdRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612954; c=relaxed/simple;
	bh=GmCsQDu8Z57dznoMxRBT9nUlr6N6NETFackyEN85iWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AKXAY2Cezf2xgL8gi7grQepdGFAgnm1wxX4qOVPj73BvpfO4zbIedySgai6RFoCCMuuFY6UGgW6QP/ijVFUSaeZejGVQTKhwRnF7NwVtPza8Kpi4D+LyyQEr2gBiXJNx5VRp36I6+lLT6JoNPb5g1nV8ntI4f7wXdS2urkr2UDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=BFNTbaaT reason="key not found in DNS"; arc=none smtp.client-ip=198.177.127.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="BFNTbaaT"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htmw75yRGz6tkM;
	Mon, 28 Sep 2026 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790612938;
	bh=Jjt4tGbUn3XaVxYFqdlAHvBDWDRqdX3jcffveL7qe0E=;
	h=From:To:Cc:Subject:Date:From;
	b=BFNTbaaTscPETjOPA4VZ2mC1sX63SUvZZUOBIgDqNwT0OCD/hrC8veFTN1vvf00LC
	 ksmzzHKAFrpfPLuIrUET2RrSmLyAuZ2pWLLzVW/m2PWVyiIkFPbijb/mNCwwAdKfka
	 kI3NYaiiGSUGCRt8Tg2zd2NRyEn0319A3SH9SOkjANay8UIJshPgL1bBSB/S47oSbS
	 MibBmb6bd6kDhjSiAcdUG8YPE1tUCwMoSij1Mc6tP8WPbbwcw2K21jn40n681ockro
	 Cx0A81ics8Xu/OSW5/pII9jE/P5Bp5c1IuUVTMm6/NC/4b401bRsT0Vc2r/zR6+dCW
	 dnUGEgTgXLBVg==
From: Rahul Chandelkar <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Rahul Chandelkar <rc@rexion.ai>
Subject: [PATCH nf-next v5 0/4] netfilter: conntrack: shared port parser for helpers
Date: Mon, 28 Sep 2026 16:28:54 +0000
Message-ID: <cover.1790596690.git.rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

The IRC and Amanda conntrack helpers parse port numbers from packet
payload with simple_strtoul(), which returns unsigned long without a
range check, so a port above 65535 is truncated when it is stored in a
u16 (65537 becomes 1) and an expectation is created for a port that
never appeared in the payload.  Amanda also cuts a port field of six or
more digits down to its first five.  Both problems are present in
current nf-next.

Instead of open-coding a range check in each helper, this series moves
the sip_strtouint() parser of nf_conntrack_sip into the helper core as
nf_ct_helper_parse_uint(), adds nf_ct_helper_parse_port() on top of it,
and converts the three helpers:

  1/4 adds the two parsers
  2/4 and 3/4 fix the IRC and Amanda helpers
  4/4 removes the now duplicate parsing code from the SIP helper
      (no functional change)

Testing: allmodconfig and allyesconfig builds with W=1, sparse, an
allnoconfig build, i386 and big-endian powerpc cross-builds, and a
build of each patch in turn.  The old and new sip_parse_port() were
compared in a userspace harness built from the kernel source on three
million random inputs with no difference.  The helpers have not been
run-time tested with IRC, Amanda or SIP traffic.

Tool use: v4 and v5 were prepared with Claude Code, an AI coding
assistant, as recorded in the Assisted-by tags.  It wrote most of the
code changes and changelogs from v3 and the review feedback, and ran
the builds and tests listed above.  v4 should have carried the tags as
well; it did not, sorry about that.

Changes in v5:
  - nf_ct_helper_parse_port(): reject digit runs longer than five
    characters, so that sip_parse_port() still rejects zero-padded
    ports and 4/4 has no functional change; return -EINVAL rather
    than -1
  - add kernel-doc for both parsers, including their digit limits
  - amanda: make pbuf one byte larger so that a port field of six or
    more digits is rejected instead of being cut to its first five
    digits
  - irc: remove the dcc_port == 0 test in help(), which can no longer
    be true
  - sip: rewrap call sites that no longer fit in 80 columns
  - add Assisted-by tags
  (the first four items address the Sashiko review of v4)
v4: https://lore.kernel.org/all/20260923091608.2617604-1-rc@rexion.ai/
  - rebase onto nf-next; move sip_strtouint() into the helper core
    instead of adding a second parser, and convert nf_conntrack_sip
    (Pablo Neira Ayuso, Phil Sutter, Florian Westphal)
  - use a real name and target nf-next (Pablo Neira Ayuso)
v3: https://lore.kernel.org/all/20260503083220.630655-1-rc@rexion.ai/
  - add nf_ct_helper_parse_uint() and convert nf_conntrack_sip
    (Phil Sutter)
v2: https://lore.kernel.org/all/20260501063156.2520780-1-rc@rexion.ai/
  - add a shared nf_ct_helper_parse_port() in the helper core instead
    of open-coding range checks (Florian Westphal, Pablo Neira Ayuso)
v1: https://lore.kernel.org/all/20260430161230.3438973-1-rc@rexion.ai/

Rahul Chandelkar (4):
  netfilter: conntrack: add shared uint and port parsers for helpers
  netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
  netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
  netfilter: nf_conntrack_sip: use shared helper parsers

 include/net/netfilter/nf_conntrack_helper.h |  5 ++
 net/netfilter/nf_conntrack_amanda.c         | 13 ++-
 net/netfilter/nf_conntrack_helper.c         | 79 +++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  9 +-
 net/netfilter/nf_conntrack_sip.c            | 93 ++++++---------------
 5 files changed, 123 insertions(+), 76 deletions(-)


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.43.0

