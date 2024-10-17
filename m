Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012D21D45F2;
	Thu, 17 Oct 2024 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168470; cv=none; b=lIUwOz9dD1CBN66PYaKOqDJDyaAFWUBqqbHrdO/mXUq9XbnK/xgTgyaPTpu/aDeo3MaH0JNWnqeD+P90T3UFrJqR+qjvgiGZpeP1jGw8LUDlyNqPQD2q1ePsSZU2Z+Y6wkm2Sf6j4zkRFCEdTy2splE1CeOLtPXKZCbRq2OthRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168470; c=relaxed/simple;
	bh=MI/nGAMTlHCGsfC1UVFQYemnR3etMCmIbTMSTV9TBuk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FLIXimriB4oVvNFXnVTYIsDWurssbaXnnxatc2HUihPjxWfvRAWcEYkqvneW8BtHVFUDRh1/uEnWyZ36QJ6xJXE+I/m/Yvvuti8I9fJuvEFLmokUq8grkQ5jsW6ctNq6PR9uzlzcWUiNHLbD7pxWUXu6HUyparr2F52VIzyhZvU=
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
Subject: [PATCH net 0/1] Netfilter fixes for net
Date: Thu, 17 Oct 2024 14:34:12 +0200
Message-Id: <20241017123413.4306-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains one fix:

syzkaller managed to triger UaF due to missing reference on netns in
bpf infrastructure, from Florian Westphal.

Florian Westphal (1):
  netfilter: bpf: must hold reference on net namespace

 net/netfilter/nf_bpf_link.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.30.2

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-17

Thanks.

----------------------------------------------------------------

The following changes since commit cb560795c8c2ceca1d36a95f0d1b2eafc4074e37:

  Merge branch 'mlx5-misc-fixes-2024-10-15' (2024-10-17 12:14:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-10-17

for you to fetch changes up to 1230fe7ad3974f7bf6c78901473e039b34d4fb1f:

  netfilter: bpf: must hold reference on net namespace (2024-10-17 13:58:57 +0200)

----------------------------------------------------------------
netfilter pull request 24-10-17

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: bpf: must hold reference on net namespace

 net/netfilter/nf_bpf_link.c | 4 ++++
 1 file changed, 4 insertions(+)
