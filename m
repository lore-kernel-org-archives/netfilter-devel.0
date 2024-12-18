Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E081FCFF4;
	Wed, 18 Dec 2024 23:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734565312; cv=none; b=AC49P4uBux0XhaLmk1Ro/fVXLi7v1gPi2XYoVNWxiDXSUahC8IwjuBlNy2RVBt88JjxUeGuapoCePywRmJmyDivFbeZs05jcTghWYwpRvPUreeQw2d0OHPitTmK0NYu1Dzj128LabBsGDDkdFTmFxXbMA+NnfxYfQCqlVLrDvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734565312; c=relaxed/simple;
	bh=uMSG5ER061vR6o17OJ5d/JzFjjqUwmyqr69/UYhN8E8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cqT6D7JLLCX2rfiTqje+YidGLiLp6bO/hplK82Q54kXe0R3hM24PH6z4/O3EMg7ycP4R37xJQX6EuZOa2OHenSAcYkno05QDpEdHHemuqm/Iw9upKUUGYLf+yd7XzEBBgQBLgnJpLjLZpabg9FlzKbK9k91xm8vMcSxEF/nK9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/2] Netfilter/IPVS fixes for net
Date: Thu, 19 Dec 2024 00:41:35 +0100
Message-Id: <20241218234137.1687288-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains two fixes for Netfilter/IPVS:

1) Possible build failure in IPVS on systems with less than 512MB
   memory due to incorrect use of clamp(), from David Laight.

2) Fix bogus lockdep nesting splat with ipset list:set type,
   from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-12-19

Thanks.

----------------------------------------------------------------

The following changes since commit 954a2b40719a21e763a1bba2f0da92347e058fce:

  rtnetlink: Try the outer netns attribute in rtnl_get_peer_net(). (2024-12-17 17:54:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-12-19

for you to fetch changes up to 70b6f46a4ed8bd56c85ffff22df91e20e8c85e33:

  netfilter: ipset: Fix for recursive locking warning (2024-12-19 00:28:47 +0100)

----------------------------------------------------------------
netfilter pull request 24-12-19

----------------------------------------------------------------
David Laight (1):
      ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems

Phil Sutter (1):
      netfilter: ipset: Fix for recursive locking warning

 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 net/netfilter/ipvs/ip_vs_conn.c       | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)
