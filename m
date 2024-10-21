Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13F4199E9D;
	Mon, 21 Oct 2024 09:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503945; cv=none; b=hYUuUoCfR9hWL1F/k4kgRllMNJcCPC//qF5niUALD/H4kdS9+pslhG4CI/476h+EmTNMpbmMNTbNvO6DGVLdc10qLHsDVtIeFhl9pWA9lJ2f1QetpCNEEk2TD3lSroeOLSMFV96olxUkTSBViM3mkwAAGdQlirYhar4TSstsExA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503945; c=relaxed/simple;
	bh=bsuomyKkcsdQyL3/0slJ0YBalreYwaoNGDT48Yv2awE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=e6DwZYF9GrEwt/QbHWzdKMjYewE4VTPDdhmsc92TtJhbnW6a7o51pMr0qfobDet57H/LV5uvxtOAU0rbmjop94Vt/u0JPDrSLQ8T9850AibIkMAtiqgN46Vo9s1RC1o+VBFALmx8sUJCIE9VSBv4DXI++WX4dvoGe4GtExMV1pY=
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
Subject: [PATCH net 0/2] Netfilter fixes for net (v2)
Date: Mon, 21 Oct 2024 11:45:34 +0200
Message-Id: <20241021094536.81487-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a v2 including a extended PR with one more fix.

-o-

Hi,

This patchset contains Netfilter fixes for net:

1) syzkaller managed to triger UaF due to missing reference on netns in
   bpf infrastructure, from Florian Westphal.

2) Fix incorrect conversion from NFPROTO_UNSPEC to NFPROTO_{IPV4,IPV6}
   in the following xtables targets: MARK and NFLOG. Moreover, add
   missing

I have my half share in this mistake, I did not take the necessary time
to review this: For several years I have been struggling to keep working
on Netfilter, juggling a myriad of side consulting projects to stop
burning my own savings.

I have extended the iptables-tests.py test infrastructure to improve the
coverage of ip6tables and detect similar problems in the future.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-21

Thanks.

----------------------------------------------------------------

The following changes since commit cb560795c8c2ceca1d36a95f0d1b2eafc4074e37:

  Merge branch 'mlx5-misc-fixes-2024-10-15' (2024-10-17 12:14:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-10-21

for you to fetch changes up to 306ed1728e8438caed30332e1ab46b28c25fe3d8:

  netfilter: xtables: fix typo causing some targets not to load on IPv6 (2024-10-21 11:31:26 +0200)

----------------------------------------------------------------
netfilter pull request 24-10-21

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: bpf: must hold reference on net namespace

Pablo Neira Ayuso (1):
      netfilter: xtables: fix typo causing some targets not to load on IPv6

 net/netfilter/nf_bpf_link.c | 4 ++++
 net/netfilter/xt_NFLOG.c    | 2 +-
 net/netfilter/xt_TRACE.c    | 1 +
 net/netfilter/xt_mark.c     | 2 +-
 4 files changed, 7 insertions(+), 2 deletions(-)
