Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A14218AE
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782743991; cv=none; b=JWYtJ8cJroTabsP9ItCc1eh9qGZjCExnS9kjA1ZT/7uf7tVkNtWtdvzNX8XViH9sJMKpQH44zgXmpqWV00BmtUSEgTBRLGnrqR+5Qso6eO83i+VSIbvAAI2g/ZZcwHsr8BeZLhYfr9FKWrs05bzkTX5fYDkF6dkfzR/6uSzSiYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782743991; c=relaxed/simple;
	bh=8iOOPC3tvSXN1gPOZAZ46resUuJl2e54i8kyl3SPXZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D6thlnrztTQqksbhtHlIzu3o4s2Ilu6YfIOpocG9PZmQ1VghS73kPz6idsQ2pys8kxxrkHxmOrl0cUhlfX2bc40o+9GbGj3HlMkXgoVPKuoq1WHItkcTWF0U6ewePoCnEJ99+8WIE+n2jDsuQJBjhrQthYcHVfVgiPnA5zg1xKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gDuNkA3v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gDuNkA3v"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5F0DA60588;
	Mon, 29 Jun 2026 16:39:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782743980;
	bh=4I0gLooVVwTSguRVVxXvfJgqhQfWSKNT/UxtAA8zLGI=;
	h=From:To:Cc:Subject:Date:From;
	b=gDuNkA3vN3zXZfDgi0ioU1866/rSBQTNKuFaqG6q8VdXPk080i1Iiu5Eq2QyeEYZ3
	 sF9np8Lvmm03l2SWkmOwM4zR3MNRjjC//wxmazJVmbjQImSaZqeHbvc1A/JRvkeS5q
	 CP6jPxk6WDrLRtiRx2b0AMAHc0d6G01blo6e1zgLtxCJLPKSG/mwRJVRetof1kLi7+
	 VsGn6gSutsgNVSU1ybrOKFU2eRIlOwGgvCzq8BFpftQeoIBTEdgy8uQOR/Yyffhw4I
	 DLpazcLwosM/MjtQuKQYanmH48Js+DOc1VB2v9R+3grB36RFCZv/s6sAkkyX6TlFQ6
	 qdChlHV2dsVFA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: chzhengyang2023@lzu.edu.cn,
	lorenzo@kernel.org
Subject: [PATCH nf 0/3] flowtable fixes for ipip tunnels
Date: Mon, 29 Jun 2026 16:39:33 +0200
Message-ID: <20260629143936.61239-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains fixes for the flowtable ipip support:

Patch #1 updates nf_flow_tunnel_ip{6}ip{6}_push() to use the dst_entry
         in this direction to calculate headroom and set iph->frag_off.
	 Apparently, nft_flow_tunnel_update_route() sets the right
	 dst_entry in this direction, but datapath uses the other direction.

Patch #2 adds a function to bail out early on any attempt to hardware
	 offload a flow entry which is not supported. Currently, ->num_tun
	 has no drivers supporting this.

Patch #3 makes dst_entry available for all xmit modes which is required
	 to reach the dst_entry when pushing the ipip header (see related
	 patch #1). Based on patch from Rein Wein.

This series is passing nft_flowtable.sh selftest here, including Ren Wei's
patch:

  [nf,v3,2/2] selftests: netfilter: add bridge tunnel flowtable regression
  https://patchwork.ozlabs.org/project/netfilter-devel/patch/5b8a9e87ff7b47401612bb0e0fc841d8bfdd333d.1782092221.git.chzhengyang2023@lzu.edu.cn/

which should be also be taken upstream.

Pablo Neira Ayuso (3):
  netfilter: flowtable: use dst in this direction when pushing IPIP header
  netfilter: flowtable: IPIP tunnel hardware offload is not yet support
  netfilter: flowtable: support IPIP tunnel with direct xmit

 include/net/netfilter/nf_flow_table.h |  4 ++--
 net/netfilter/nf_flow_table_core.c    | 15 +++++++++++----
 net/netfilter/nf_flow_table_ip.c      | 21 ++++++++++++---------
 net/netfilter/nf_flow_table_offload.c | 17 +++++++++++++++++
 4 files changed, 42 insertions(+), 15 deletions(-)

-- 
2.47.3

