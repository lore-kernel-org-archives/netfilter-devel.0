Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C43093C0;
	Wed, 27 Aug 2025 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756301951; cv=none; b=qGctbV8N9Va+f4yZdA8NkQKm4QV1BSpx5X02LwWSY+obFDu6EaWbd2ba2JOfF6WYbc71Du1m7UYzW+22vzvWt2HS2O6yJT8V7vOnZi9zAKDyQCTXsBJBEzDc2mYxm87nlJUbT+tBiVAhPYFxgz0BD7XEJ4OpOrvxpaoUSHPZv14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756301951; c=relaxed/simple;
	bh=3Q2kRlc96gcNGoExacx8KLAjSvyCTJ8CTML984nNk1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iQSAI1+fR9vS7Lu4NrYOBCZ230NQgxsJoHVqy/zRnwzIVfI+9kFh+7/tMLlsnECCCuKK3wb9meiRJ9aprl1v8jzU16/Lfqu/EnQ6VPUrGGG34YyBSGAgScfoouk9kZwvaWXaYqGpDI+774cjPbx3hxpYYsJBCdsQIgKZ/IKKelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A878460288; Wed, 27 Aug 2025 15:39:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/2] netfilter updates for net
Date: Wed, 27 Aug 2025 15:38:58 +0200
Message-ID: <20250827133900.16552-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Remove bogus WARN_ON in br_netfilter that came in 6.8.
   This is now more prominent due to
   2d72afb34065 ("netfilter: nf_conntrack: fix crash due to removal of
   uninitialised entry"). From Wang Liang.

2) Better error reporting when a helper module clashes with
   an existing helper name: -EEXIST makes modprobe believe that the
   module is already loaded, so error message is elided.
   from Phil Sutter.

Please, pull these changes from:
The following changes since commit 9448ccd853368582efa9db05db344f8bb9dffe0f:

  net: hv_netvsc: fix loss of early receive events from host during channel open. (2025-08-26 18:15:19 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-08-27

for you to fetch changes up to 54416fd76770bd04fc3c501810e8d673550bab26:

  netfilter: conntrack: helper: Replace -EEXIST by -EBUSY (2025-08-27 11:53:38 +0200)

----------------------------------------------------------------
netfilter pull request nf-25-08-27

----------------------------------------------------------------

Phil Sutter (1):
  netfilter: conntrack: helper: Replace -EEXIST by -EBUSY

Wang Liang (1):
  netfilter: br_netfilter: do not check confirmed bit in
    br_nf_local_in() after confirm

 net/bridge/br_netfilter_hooks.c     | 3 ---
 net/netfilter/nf_conntrack_helper.c | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

-- 
2.49.1

