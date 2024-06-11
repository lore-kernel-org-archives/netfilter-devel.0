Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4249150991;
	Tue, 11 Jun 2024 22:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143411; cv=none; b=fDOz6gmSXDap/kElOi89TJcdpBe84g253fBfDGAODL513zR0Bpjp1VxP2vNvpcCls8Yk4jy5285d0999XAacC5QwgRjpF6RjnGAI1lc4CbxRJcTjESx7ss/x+iQWP/9a+ef9GB0O4dC2x4NtketXtyRrtiHFGVeAIldIaJn7Iq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143411; c=relaxed/simple;
	bh=Z/32LF81Zn9UJbVOXGfYBPwKOU5DY4DOyiVLJEzR1UY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cW8KS3VsM7IQ7NiOHl8BxE3teXzzfOMQftO4DprV4S0aNpLFPMuiu0Mim5p1iNZQ4c+tY5wD8B4ZNspYkBJOCcMcNSbWA0b5DJDhPK9quG/s6ypA5uPmpQR6wtJMZkxtS2K7D66nWMC7Ni7oXC3G1NKwTEHFmUjUBs4sla/243Y=
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
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Wed, 12 Jun 2024 00:03:20 +0200
Message-Id: <20240611220323.413713-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

Patch #1 fixes insufficient sanitization of netlink attributes for the
	 inner expression which can trigger nul-pointer dereference,
	 from Davide Ornaghi.

Patch #2 address a report that there is a race condition between
         namespace cleanup and the garbage collection of the list:set
         type. This patch resolves this issue with other minor issues
	 as well, from Jozsef Kadlecsik.

Patch #3 ip6_route_me_harder() ignores flowlabel/dsfield when ip dscp
	 has been mangled, this unbreaks ip6 dscp set $v,
	 from Florian Westphal.

All of these patches address issues that are present in several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-06-11

Thanks.

----------------------------------------------------------------

The following changes since commit 36534d3c54537bf098224a32dc31397793d4594d:

  tcp: use signed arithmetic in tcp_rtx_probe0_timed_out() (2024-06-10 19:50:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-06-11

for you to fetch changes up to 6f8f132cc7bac2ac76911e47d5baa378aafda4cb:

  netfilter: Use flowlabel flow key when re-routing mangled packets (2024-06-11 18:46:04 +0200)

----------------------------------------------------------------
netfilter pull request 24-06-11

----------------------------------------------------------------
Davide Ornaghi (1):
      netfilter: nft_inner: validate mandatory meta and payload

Florian Westphal (1):
      netfilter: Use flowlabel flow key when re-routing mangled packets

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type

 net/ipv6/netfilter.c                  |  1 +
 net/netfilter/ipset/ip_set_core.c     | 81 ++++++++++++++++++++---------------
 net/netfilter/ipset/ip_set_list_set.c | 30 ++++++-------
 net/netfilter/nft_meta.c              |  3 ++
 net/netfilter/nft_payload.c           |  4 ++
 5 files changed, 68 insertions(+), 51 deletions(-)
