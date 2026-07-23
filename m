Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F3F397699
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829000; cv=none; b=UZcbn+wLSgr9R3x2/UTz7p1ejNpRtoeLqZOvCKgt/IaKjTab5BcsINHA5AlS0LNBLnW/WM/+dgnsfQIdyL255vdsFd6lgWqIPUtk3+kZhf5RPsdrQRRWYFhO14E0xfEylbuQIZC/RmFvklEO0QlSvj9UHNdethhwKZ/OOzmAhrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829000; c=relaxed/simple;
	bh=OqrMbh8nSpBdmcGZPGHE54DXurRimc8N3/lXSj77G0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+rBGo8Xu678jH5eWz1SpYoM8bMrQuXt5ltQv/hQBNfbxRCgNI+imlxlZ+id68n2qZnpumSp9SlTXTZCHvcc6RUQQ1/1DPfz/3Js2w88NjJyAAGHbGh6fUgGcxBD2MHXbkEq3ekJ58fzxqMyOkxWYUssqcvsvYxbngc5JPrgmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ez2ajjH0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ez2ajjH0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4D8A060191;
	Thu, 23 Jul 2026 19:49:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784828995;
	bh=R03flsYlIp89jrGAcHMeb7WMYI5mWlMUxy6CK2sBz0c=;
	h=From:To:Cc:Subject:Date:From;
	b=ez2ajjH0IGLDF+m3vk1AIYup4Mg5x8h3VXzg5OMmg1lbI+sQB7iLkfLv9Fc4BpdO1
	 txJ1XSXDB5iHso4Kle8F28W7WCpBEsp4LCgpgSNeKO1KxGT2TtpQouG99zam1xQQoX
	 KMUdJUHiahHXPVvoupFUP/7jR9cqU5TxE49SFMy33HBsB9l2l4Uj2pJKiONubi72Bx
	 c/TwbWIhgs8GvVkUSuNhhHOIjSG4zP+n8FRDmvtC7iNnF2qCP/nWcfgwKe8iZNkkSc
	 puBaVKOuwl63I6XLtucJXTA5XfppM+U9fDMlx4Hvyzqxf1yZWjXHzuBhboXPY5l6yu
	 eAeR3PbHzcH9w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next 0/4] flowtable: pass dst_entry from ipip tunnel
Date: Thu, 23 Jul 2026 19:49:48 +0200
Message-ID: <20260723174952.329650-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is revisiting the existing approach to avoid a double route lookup
and avoid a late failure to obtain the ipip route leading to an
incomplete forward path.

This is complementary work to Lorenzo's recent updates for .fill_forward_path
for ipip and ip6ip6 to make a more exhaustive route lookup.

Pablo Neira Ayuso (4):
  netfilter: flowtable: consolidate net_device field in nft_forward_info struct
  netfilter: flowtable: consolidate flowtable device check
  net: pass dst via net_device_path in dev_fill_forward_path()
  netfilter: flowtable: release tunnel route on error when building
    forward path

 include/linux/netdevice.h          |  1 +
 net/core/dev.c                     | 45 +++++++++++---
 net/ipv4/ipip.c                    |  2 +-
 net/ipv6/ip6_tunnel.c              |  2 +-
 net/netfilter/nf_flow_table_path.c | 95 ++++++++++--------------------
 5 files changed, 71 insertions(+), 74 deletions(-)

-- 
2.47.3

