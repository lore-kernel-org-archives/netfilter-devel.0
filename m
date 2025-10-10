Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587F13A265
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095129; cv=none; b=syjQXGN/YHkWdzayN/cPhVLSsck0tKAqfsWLib1AMqmZCsQnjBo9KltwLr9tpx7E5yEJUaKr1RyJPT84QJFTOXhv+sJq5Fh5tA3KBeLc0lDujkQCjYDEdXkfjkzL9RteYsAv4jRqH4awg+4p9gSzw146R4kL8mSOAPNc50PtYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095129; c=relaxed/simple;
	bh=7WbOMENKXpcoPR+v1kpoynHZUPl3/HX+ibGycu5g+0M=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=XT3vJipMILR671bom1T5LYzjulxIgYg9Ewm51XNLZPEGTof13NKMyFSPj6zgoX3T6AfZ20//7msxqS+nasQlCdB9FajFFSFWPga3ZO0TNSXxuEZJ9LZPRCKjgbWX9POs/Xtpv03PmsaQeBaFTEA/NyTzxUJu6VR7tNZDQtFAJRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=idWmbeaQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=idWmbeaQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="idWmbeaQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="idWmbeaQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D288E602AB; Fri, 10 Oct 2025 13:18:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095116;
	bh=hAf7KereexBeH8lWN6ZE0fXhn1Yz7feDafFqwXmLLbw=;
	h=From:To:Subject:Date:From;
	b=idWmbeaQfhouNvvDJ9n05SjWubaKYA4Ms/UApWfyXlYGHBrte0gtMU0GNVLhlSthY
	 Evw0HHkYab5oMFQmczwgHgveZxAwQHcDuehEDYLWXTfkf/zNWVotXEmN/E5KobOrJY
	 kZhUjXTm7FysWc6wm0gSOPYd4SGh4VQINNDNHH6sC75NOnQMeuaPparbwYNBdY+B7+
	 WDgjiZFNXbpVKTzyoFGNep3WK4IYjKnKgWnBWICHEBhga0M2MB0fc4rvdjerpwSTX6
	 RAqJwZzrXbgNaCoJuoY2wSCqQp4ORiz1YAHhFESdhTj6kNV6fKkNEwYbVGrltRPrES
	 veluYMGtQXIyQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 45173602A9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 13:18:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095116;
	bh=hAf7KereexBeH8lWN6ZE0fXhn1Yz7feDafFqwXmLLbw=;
	h=From:To:Subject:Date:From;
	b=idWmbeaQfhouNvvDJ9n05SjWubaKYA4Ms/UApWfyXlYGHBrte0gtMU0GNVLhlSthY
	 Evw0HHkYab5oMFQmczwgHgveZxAwQHcDuehEDYLWXTfkf/zNWVotXEmN/E5KobOrJY
	 kZhUjXTm7FysWc6wm0gSOPYd4SGh4VQINNDNHH6sC75NOnQMeuaPparbwYNBdY+B7+
	 WDgjiZFNXbpVKTzyoFGNep3WK4IYjKnKgWnBWICHEBhga0M2MB0fc4rvdjerpwSTX6
	 RAqJwZzrXbgNaCoJuoY2wSCqQp4ORiz1YAHhFESdhTj6kNV6fKkNEwYbVGrltRPrES
	 veluYMGtQXIyQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/5] flowtable: consolidate xmit path
Date: Fri, 10 Oct 2025 13:18:20 +0200
Message-Id: <20251010111825.6723-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series aims to consolidate direct and neigh xmit paths, the
dst_check for stale routes as well as the neighbour lookup are still
performed to detect network topology updates.

Patch #1 move the path discovery code to its own file, as more new
         topologies can be offloaded in the future. This is a
         preparation patch.

Patch #2 consolidates the neigh and direct xmit path. This patch relaxes
         too a check for neigh xmit in both directions which is needed
	 by the existing basic xfrm offload.

Patch #3 inlines vlan encapsulation to the flowtable xmit path, no
         indirection to the vlan device is required.

Patch #4 also inlines pppoe encapsulation which skips passing the
         packet to userspace pppd for encapsulation.

Patch #5 remove hw_ifidx which was introduced to make the hardware
         offload happy.

I have picked up and rebase original patches for vlan and pppoe posted
on the mailing list by wenxu.

As for IPIP support (layer 3 tunnel), this would also allow to inline
encapsulation. This needs a mtu check before encapsulation to push back
the packet to classic path if fragmentation after encapsulation is
needed.  This is not included in this series.

This adds an extra lookup by the index for the device for the neigh xmit
case from flowtable datapath, I did not collect numbers on this yet.

This is patch nft_flowtable.sh selftests.

Pablo Neira Ayuso (5):
  netfilter: flowtable: move path discovery infrastructure to its own file
  netfilter: flowtable: consolidate xmit path
  netfilter: flowtable: inline vlan encapsulation in xmit path
  netfilter: flowtable: inline pppoe encapsulation in xmit path
  netfilter: flowtable: remove hw_ifidx

 include/net/netfilter/nf_flow_table.h |   8 +-
 net/netfilter/Makefile                |   1 +
 net/netfilter/nf_flow_table_core.c    |   2 +-
 net/netfilter/nf_flow_table_ip.c      | 149 +++++++++++----
 net/netfilter/nf_flow_table_offload.c |   2 +-
 net/netfilter/nf_flow_table_path.c    | 259 ++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      | 252 -------------------------
 7 files changed, 383 insertions(+), 290 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_path.c

-- 
2.30.2

