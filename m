Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1B52D8387;
	Thu, 19 Mar 2026 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773913121; cv=none; b=Wdcahw+rt+DVC6U5mgYMIxcGyTZ8LpUAHXPnaWUp6e4jguNjA8gYKMSbQ0tyi4zJoF6xHrFrdthilPalWkDGLSGL96jfL2QXA/mSUd0wOVLnAs+wA8x9aotZqk6iYrpTkd5W2cjwlB43+eS1HEiTxsUA9qfjMlSo3Isinu7kCcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773913121; c=relaxed/simple;
	bh=31LK8NCeT9pZAzvqjCRETgZxFTk3AtpuJpNPq0z0hDE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YI7y7SE+BCpC9Yy/caYLoZj80tmIHgpSjgr95BSyU6A/i+bVwDPEPZJq0e9rEWCkLXS33sDw8Vzzf0iqLHBgh6RLNHM0Vk/DjL28nY9LLnaR8pCx+Kk1sk5EVUelbHBesgxu6ohnRJii9Mq7yDxz1j7oT4AbRyEDCjfqDWxF7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D3D2606E1; Thu, 19 Mar 2026 10:38:38 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/3] netfilter: updates for net
Date: Thu, 19 Mar 2026 10:38:31 +0100
Message-ID: <20260319093834.19933-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Fix UaF when netfilter bpf link goes away while nfnetlink dumps
   current hook list, we have to wait until rcu readers are gone.

2) Fix UaF when flowtable fails to register all devices, similar
   bug as 1). From Pablo Neira Ayuso.

3) nfnetlink_osf fails to properly validate option length fields.
   From Weiming Shi.

Please, pull these changes from:
The following changes since commit 7c46bd845d89ad4772573cfe0f2a56b93db75cc7:

  Merge tag 'wireless-2026-03-18' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2026-03-18 19:25:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-03-19

for you to fetch changes up to dbdfaae9609629a9569362e3b8f33d0a20fd783c:

  nfnetlink_osf: validate individual option lengths in fingerprints (2026-03-19 10:27:07 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-03-19

----------------------------------------------------------------
Florian Westphal (1):
  netfilter: bpf: defer hook memory release until rcu readers are done

Pablo Neira Ayuso (1):
  netfilter: nf_tables: release flowtable after rcu grace period on error

Weiming Shi (1):
  nfnetlink_osf: validate individual option lengths in fingerprints

 net/netfilter/nf_bpf_link.c   |  2 +-
 net/netfilter/nf_tables_api.c |  1 +
 net/netfilter/nfnetlink_osf.c | 13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.52.0
