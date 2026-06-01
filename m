Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6AA2DF144
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342264; cv=none; b=YnU6y4MRv/hafKraBC/5aSUV7Va2BYOMzp95AaTIcRzQ45X079zas6zKeaK6ZGO2nhj8tHNWuJA3vFhFzjv8O2MieEFO4qwCIBuByvGoSv++5KFY0rRSWW/9Cb48p2QULJrhgVikQqeO9zkf96mlUbhYI/7WWT0webe7QzSZ4ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342264; c=relaxed/simple;
	bh=+P3quqD9i42meK/ecwPtcncN45t50siKMK4X1aJDZAs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n2WBmGA7chaNTsmcF7aVyrgvrlI0HYmIC0YIW+5xaKmHyJ+U7m99BuEeU24TvMSf+xkKwhI+C7sVakctbzgO0V4WY7biKJud/hq4HEY3Y+Dxn/8+nALgoqkpdPg6+zA5KxGbZQoDTe+dlrYZq/JFeCOCDtJsPjPkjvKl7h8AzAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ttdzrnFO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JV5XNet5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ttdzrnFO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JV5XNet5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ttdzrnFO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JV5XNet5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ttdzrnFO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JV5XNet5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7EA2D67229;
	Mon,  1 Jun 2026 19:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OFTa7o/jGmuTqULVsMVkAqM75gizoeySVByTgwRXuso=;
	b=ttdzrnFOc+ewnZJWG+4NhQyd1TKIZXIR2wIsfSREA1Xy5MtZ3XQBtlh2kZ5GoWpt+ByHlB
	rvszzxvh++EPc3pN5gV2JrRsQcXH8BjNce/l9CiRWA1wariNmAjc040EUltgpu6xgPFPcp
	qh2oUq5FgNJ5nIs1T+0yKmVBTQ+fnEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OFTa7o/jGmuTqULVsMVkAqM75gizoeySVByTgwRXuso=;
	b=JV5XNet55g0lQ/RRCLKmMboeGX679YstIbQfb/X0WFjDZs9hWUkrWTWWk5Kjm8KAd2bZgP
	h/DnDwtaLeAU2LAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ttdzrnFO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JV5XNet5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OFTa7o/jGmuTqULVsMVkAqM75gizoeySVByTgwRXuso=;
	b=ttdzrnFOc+ewnZJWG+4NhQyd1TKIZXIR2wIsfSREA1Xy5MtZ3XQBtlh2kZ5GoWpt+ByHlB
	rvszzxvh++EPc3pN5gV2JrRsQcXH8BjNce/l9CiRWA1wariNmAjc040EUltgpu6xgPFPcp
	qh2oUq5FgNJ5nIs1T+0yKmVBTQ+fnEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OFTa7o/jGmuTqULVsMVkAqM75gizoeySVByTgwRXuso=;
	b=JV5XNet55g0lQ/RRCLKmMboeGX679YstIbQfb/X0WFjDZs9hWUkrWTWWk5Kjm8KAd2bZgP
	h/DnDwtaLeAU2LAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F30D779A7;
	Mon,  1 Jun 2026 19:31:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x3HjBPXdHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:01 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/9 nf-next] netfilter: replace raw warnings with
Date: Mon,  1 Jun 2026 21:30:40 +0200
Message-ID: <20260601193049.8131-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7EA2D67229
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

This patch series replaces raw WARN_ON and WARN_ON_ONCE macros with
DEBUG_NET_WARN_ON_ONCE across various netfilter subsystems.

Currently, several internal invariant checks use standard warnings on
packet processing paths or control-plane loops. If triggered, these can
trigger full system panics when panic_on_warn=1 is enabled. In most of
these cases, the condition is already handled gracefully by dropping the
packet, applying a defensive fallback, or returning a proper error code
to userspace via netlink.

By migrating to DEBUG_NET_WARN_ON_ONCE, we preserve full stack trace
diagnostic capability for developers running kernels compiled with
CONFIG_DEBUG_NET=y, while protecting production environments from system
panics.

Fernando Fernandez Mancera (9):
  netfilter: xtables: use DEBUG_NET_WARN_ON_ONCE in packet and control
    paths
  netfilter: nf_tables: use DEBUG_NET_WARN_ON_ONCE in packet and control
    paths
  netfilter: nfnetlink: use DEBUG_NET_WARN_ON_ONCE for attribute
    validation
  netfilter: conntrack: use DEBUG_NET_WARN_ON_ONCE on packet paths
  netfilter: nat: use DEBUG_NET_WARN_ON_ONCE in core and helper paths
  netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
  netfilter: bpf: use DEBUG_NET_WARN_ON_ONCE for missing BTF structures
  netfilter: flowtable: use DEBUG_NET_WARN_ON_ONCE in offload path
  netfilter: conncount: use DEBUG_NET_WARN_ON_ONCE on reaching count
    limit

 net/ipv4/netfilter/ip_tables.c          |  6 ++--
 net/ipv4/netfilter/iptable_nat.c        |  4 ++-
 net/ipv4/netfilter/nf_nat_pptp.c        | 16 +++++++---
 net/ipv4/netfilter/nf_tproxy_ipv4.c     |  2 +-
 net/ipv6/netfilter/ip6_tables.c         |  6 ++--
 net/ipv6/netfilter/ip6table_nat.c       |  4 ++-
 net/ipv6/netfilter/nf_tproxy_ipv6.c     |  2 +-
 net/netfilter/nf_bpf_link.c             |  4 ++-
 net/netfilter/nf_conncount.c            |  3 +-
 net/netfilter/nf_conntrack_core.c       |  2 +-
 net/netfilter/nf_conntrack_extend.c     |  3 +-
 net/netfilter/nf_conntrack_helper.c     |  4 ++-
 net/netfilter/nf_conntrack_ovs.c        |  2 +-
 net/netfilter/nf_conntrack_proto_icmp.c |  3 +-
 net/netfilter/nf_conntrack_seqadj.c     |  2 +-
 net/netfilter/nf_conntrack_sip.c        |  5 +++-
 net/netfilter/nf_flow_table_core.c      |  4 +--
 net/netfilter/nf_flow_table_ip.c        |  4 +--
 net/netfilter/nf_flow_table_offload.c   |  4 +--
 net/netfilter/nf_nat_core.c             | 39 +++++++++++++++++--------
 net/netfilter/nf_nat_masquerade.c       |  6 ++--
 net/netfilter/nf_nat_proto.c            | 14 +++++----
 net/netfilter/nf_nat_redirect.c         |  5 ++--
 net/netfilter/nf_tables_api.c           | 38 +++++++++++++++++-------
 net/netfilter/nf_tables_core.c          |  8 +++--
 net/netfilter/nf_tables_offload.c       |  2 +-
 net/netfilter/nf_tables_trace.c         |  6 ++--
 net/netfilter/nfnetlink.c               |  4 ++-
 net/netfilter/nfnetlink_cttimeout.c     |  3 +-
 net/netfilter/nft_ct.c                  |  2 +-
 net/netfilter/nft_ct_fast.c             |  2 +-
 net/netfilter/nft_exthdr.c              |  2 +-
 net/netfilter/nft_fib.c                 |  2 +-
 net/netfilter/nft_inner.c               |  2 +-
 net/netfilter/nft_lookup.c              |  2 +-
 net/netfilter/nft_masq.c                |  2 +-
 net/netfilter/nft_meta.c                | 10 +++----
 net/netfilter/nft_payload.c             |  6 ++--
 net/netfilter/nft_redir.c               |  2 +-
 net/netfilter/nft_reject.c              |  8 +++--
 net/netfilter/nft_rt.c                  |  2 +-
 net/netfilter/nft_set_hash.c            |  2 +-
 net/netfilter/nft_set_pipapo.c          |  2 +-
 net/netfilter/nft_set_rbtree.c          |  6 ++--
 net/netfilter/nft_socket.c              |  8 +++--
 net/netfilter/nft_tunnel.c              |  2 +-
 net/netfilter/nft_xfrm.c                |  6 ++--
 net/netfilter/x_tables.c                | 12 ++++++--
 net/netfilter/xt_NETMAP.c               |  4 ---
 net/netfilter/xt_cluster.c              |  4 +--
 net/netfilter/xt_nat.c                  | 30 +++++++++----------
 net/netfilter/xt_socket.c               |  3 +-
 52 files changed, 203 insertions(+), 123 deletions(-)

-- 
2.54.0

