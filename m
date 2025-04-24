Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFAA18DF8D;
	Thu, 24 Apr 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529321; cv=none; b=vALVRQLvpeEy2P8nNvBiwg8Jwv3SBPA4piquegBxYFmgIqdoJUNLJFVbm5Cjwr7AZKfNj+mMq0l6v3iStqWj8lWCJg0/C7/4/isB0XFjCYSXUl+B0GSI4n3UUEqosG8fIWPnas4R+hK/ZzmWzjcUPco9J3zIfNwsrZGhi3Nt+9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529321; c=relaxed/simple;
	bh=zYo6ldFzV+pxopFMuB7Jhdf5olFy2pgZELSZ+s4jhgw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=X4bMoqjOasGHixKj+VK2ErVt4+WKMWOO8IBm8PTOUXOUdOv5Mpcx8cFmwoOgNQCBPIiQhKw829vLc/g/9Nn+EkFjD8++jHV5Bejh6EOkqs5qf4fJl1VLjupBMybWs5Vm+b3GLKWDd1TgcOOqAf6cGv1rmY5mDclCSTyXH+dgkkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QAIHxtr1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A83UEY2L; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QAIHxtr1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A83UEY2L"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 661B360713; Thu, 24 Apr 2025 23:15:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529310;
	bh=mJkeIJqWPn6GBMQVyjt9xFAzf3OtGBlIj9YYw3V21AU=;
	h=From:To:Cc:Subject:Date:From;
	b=QAIHxtr1FiUPr6NSkr6Z79CASfNns2ra+BfvpdyHCTsrqQXrxafLfztohf2q+IbO5
	 jTi8UMs26c+aE4Fhx5jGxnTQo/p/qyRBPkPoNNT+Bl17b3UUp6eh1rrioQZzBgvdGp
	 DWc3Oxj1wJmegpDLvDYIMYnAX/CptHsoQGr+3GC2lO/6y8CIsndQWgy56eHIDpKC5Z
	 njCnTvyh4mKInb8wPnY5sOVPDbtQzj06FYZFI7JVyTtfWWo80j6wHi6ceKyQNJ3N4y
	 TFHh8abi0Zn5DGsuDwqSmDwBIwmwDOo0c62C8+qXgw2m7jisi/l+mWhj7XKpg4cPY6
	 /GBlVIJE9GhuA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 209F76070A;
	Thu, 24 Apr 2025 23:15:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529308;
	bh=mJkeIJqWPn6GBMQVyjt9xFAzf3OtGBlIj9YYw3V21AU=;
	h=From:To:Cc:Subject:Date:From;
	b=A83UEY2LbdZ42SUSKQ1vPp18+xyzVBip5MZ0RlEefRXhCVSuAmJCnVYtEbuLLMrWP
	 8pxVdx4aTO0Fr6682DDm6cHD4ikU8E8SUk6z+MWdBaFojCPcd8//NZm4wWOpzDsjiH
	 8ie69+Vf9Tq6tgpEiBFJuzBdOPAcP+SMxfS4HGrinPd9IKoAjBS+64Lce54FDa/fPU
	 e0W/6HvDamc6fzZOYF9WSlJ1yKG2ysXcuEyyivreJ7LVZtanaQ4+GLQ60oKxN3PF3w
	 CqjZ6Yaw3xLY7NIl/OfrlQaqM/UqRemQayyZIxqI92cS0rTyD/kw0EorpLDtTjixJE
	 XYX+VLjrWGHpg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next,v2 0/7] Netfilter updates for net-next
Date: Thu, 24 Apr 2025 23:14:48 +0200
Message-Id: <20250424211455.242482-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v2: including fixes from Florian to address selftest issues
    and a fix for set element count and type.

-o-

Hi,

The following batch contains Netfilter updates for net-next:

1) Replace msecs_to_jiffies() by secs_to_jiffies(), from Easwar Hariharan.

2) Allow to compile xt_cgroup with cgroupsv2 support only,
   from Michal Koutny.

3) Prepare for sock_cgroup_classid() removal by wrapping it around
   ifdef, also from Michal Koutny.

4) Disable xtables legacy with PREEMPT_RT, from Sebastian Andrzej Siewior
   and Florian Westphal.

5) Remove redundant pointer fetch on conntrack template, from Xuanqiang Luo.

6) Re-format one block in the tproxy documentation for consistency,
   from Chen Linxuan.

7) Expose set element count and type via netlink attributes,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-04-24

Thanks.

----------------------------------------------------------------

The following changes since commit bef4f1156b74721b7d111114538659031119b6f2:

  net: phy: marvell-88q2xxx: Enable temperature sensor for mv88q211x (2025-04-24 13:19:51 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-04-24

for you to fetch changes up to 67587b4843ea66166d7fd4d785951734014e5a2c:

  netfilter: nf_tables: export set count and backend name to userspace (2025-04-24 22:05:41 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-24

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

Pablo Neira Ayuso (1):
      netfilter: Exclude LEGACY TABLES on PREEMPT_RT.

Xuanqiang Luo (1):
      netfilter: conntrack: Remove redundant NFCT_ALIGN call

 Documentation/networking/tproxy.rst          |  4 ++--
 include/uapi/linux/netfilter/nf_tables.h     |  4 ++++
 net/Kconfig                                  | 10 ++++++++++
 net/bridge/netfilter/Kconfig                 |  8 ++++----
 net/ipv4/inet_diag.c                         |  2 +-
 net/ipv4/netfilter/Kconfig                   | 15 ++++++++-------
 net/ipv6/netfilter/Kconfig                   | 13 +++++++------
 net/netfilter/Kconfig                        |  2 +-
 net/netfilter/nf_conntrack_core.c            |  4 +---
 net/netfilter/nf_tables_api.c                | 26 ++++++++++++++++++++++++++
 net/netfilter/x_tables.c                     | 16 +++++++++++-----
 net/netfilter/xt_IDLETIMER.c                 | 12 ++++++------
 net/netfilter/xt_TCPOPTSTRIP.c               |  4 ++--
 net/netfilter/xt_cgroup.c                    | 26 ++++++++++++++++++++++++++
 net/netfilter/xt_mark.c                      |  2 +-
 tools/testing/selftests/net/config           | 11 +++++++++++
 tools/testing/selftests/net/netfilter/config |  5 +++++
 17 files changed, 126 insertions(+), 38 deletions(-)
