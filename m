Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06207B3E1;
	Mon, 28 Apr 2025 22:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878396; cv=none; b=VDaTl/ww7lZapM+qqZ+5G1MJeT4mgmkF+etInBSeoTI3kDuq8a3qgH6fChk76wUowwiMOvVJp1PvQfOaTGbSvckGi2DGptdao4NqHP+S7kVY4CEvUUJD/ycHEy9gT7c3A2j00d4b/uArA7of0nhU5KAZjoUR9OFq+lZyuwMzq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878396; c=relaxed/simple;
	bh=IW9t+ogoJrKf1tGo7dCWEzFKtzb0ltwJAR/0ddCywXM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OjCQ2ukROLxmpONULBfQGcc80qD35GxvbjXJaJM526EhZ87ZaihLhFHqFocMR4dh1EMX5gD2cvh+QzV5/W2C7XSrEc3o43EWxZoRwTg0caCiVdyCSvaKmYeraioVMIHpYEd1watIosKh52u0rLxNdjqqd3qRzb64E6anbOiIf+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NIyMM2NA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eEcQRG0C; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NIyMM2NA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eEcQRG0C"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AE5D46039A; Tue, 29 Apr 2025 00:13:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878391;
	bh=GSqzb+QX46oi8M4p3sN2hC88lDcDqUr58PeyDAxq0Yc=;
	h=From:To:Cc:Subject:Date:From;
	b=NIyMM2NASr020wDuFqaXP4pgfxHwqAu7qwjlQqFt7QjN+aBc+pye7u0h55Bn9aDP6
	 FYG7DG+Ip6i8/o6TL4+YhW8kRJUeEIO0nvI9k5X1tXuK6SsDWN3qCX8Vx4f8YbOqD6
	 XgootqmdkjnIVc4FYGST57rVkzhWpgZ+xGkZ8p+Ta/wveGaRu2dkRN3a42bQnASlMC
	 DvKYYEI9sFAt2TsBe/ebgUxcVp0ZBzyVVHFDBkG+OGNzaMfwOfFdjDRpdMQBmYj7g/
	 CsYlUsot2WUqmF/ljep1vQ30MLXG6cK+CBWQ2t4keSlYLozIguxrWXesqbdSlm6YI9
	 3VuEN3251GNfg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 732766039A;
	Tue, 29 Apr 2025 00:13:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878390;
	bh=GSqzb+QX46oi8M4p3sN2hC88lDcDqUr58PeyDAxq0Yc=;
	h=From:To:Cc:Subject:Date:From;
	b=eEcQRG0CPjzPxmyTw71qNxmjzbSGY9g+Sv1PChTk/ROuXa1tWxkftbFMe18WzKMCU
	 S1WCaRIZGzRP0l8hZD1AbZs0LiHf9h0JWM8MRsucpOp4PQiZ0dFKfwcoaImY5V4gGu
	 UyrTLwTMkPV0CCUf/MZiZshViOQ6jpmw7tFumeZRd+e/HocaPTnZ4Ojb1wOSXgh5wG
	 o2J6qNbDjPxrnP0lkeFQ8aVc4vk9qlUdL7e+EkJd1JH3d+ODUrjg1wcl9GoV40dJ5v
	 /S2Xnky+U+GzDTxdWWBpkOHyhxQFUTvt9FV+la9h1NDNZZfOpzYTloIv5TEeXmcygr
	 cxarL3oJpQVpg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 0/6,v3] Netfilter updates for net-next
Date: Tue, 29 Apr 2025 00:12:48 +0200
Message-Id: <20250428221254.3853-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

1) Replace msecs_to_jiffies() by secs_to_jiffies(), from Easwar Hariharan.

2) Allow to compile xt_cgroup with cgroupsv2 support only,
   from Michal Koutny.

3) Prepare for sock_cgroup_classid() removal by wrapping it around
   ifdef, also from Michal Koutny.

4) Remove redundant pointer fetch on conntrack template, from Xuanqiang Luo.

5) Re-format one block in the tproxy documentation for consistency,
   from Chen Linxuan.

6) Expose set element count and type via netlink attributes,
   from Florian Westphal.

I have put to sleep the patch "Disable xtables legacy with PREEMPT_RT"
as suggested by Jakub Kicinski.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-04-29

Thanks.

----------------------------------------------------------------

The following changes since commit bef4f1156b74721b7d111114538659031119b6f2:

  net: phy: marvell-88q2xxx: Enable temperature sensor for mv88q211x (2025-04-24 13:19:51 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-04-29

for you to fetch changes up to 0014af802193aa3547484b5db0f1a258bad28c81:

  netfilter: nf_tables: export set count and backend name to userspace (2025-04-29 00:00:27 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-29

----------------------------------------------------------------
Chen Linxuan (1):
      docs: tproxy: fix formatting for nft code block

Easwar Hariharan (1):
      netfilter: xt_IDLETIMER: convert timeouts to secs_to_jiffies()

Florian Westphal (1):
      netfilter: nf_tables: export set count and backend name to userspace

Michal Koutný (2):
      netfilter: xt_cgroup: Make it independent from net_cls
      net: cgroup: Guard users of sock_cgroup_classid()

Xuanqiang Luo (1):
      netfilter: conntrack: Remove redundant NFCT_ALIGN call

 Documentation/networking/tproxy.rst      |  4 ++--
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/ipv4/inet_diag.c                     |  2 +-
 net/netfilter/Kconfig                    |  2 +-
 net/netfilter/nf_conntrack_core.c        |  4 +---
 net/netfilter/nf_tables_api.c            | 26 ++++++++++++++++++++++++++
 net/netfilter/xt_IDLETIMER.c             | 12 ++++++------
 net/netfilter/xt_cgroup.c                | 26 ++++++++++++++++++++++++++
 8 files changed, 67 insertions(+), 13 deletions(-)
