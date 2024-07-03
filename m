Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693A017995;
	Wed,  3 Jul 2024 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720046003; cv=none; b=ayU2f5jt+x/KcQQyE16SgQjXt0gvncTLUiZO3jI3hBJHia4FAIirK/GgVq0lRbrcsaCBPCJfJEPQNLnY9BXSvlXH2Ge2ZjIrUAhs01IhPqESwC/OIsaAIKhHZXuNUzgGhy17UOFONDb3kx7Q1TZ/Nb/41ESCLwbZ3LBOc4V8eEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720046003; c=relaxed/simple;
	bh=dR9A5vI4ZF4Ju786MTEbR/AWvC8yLfcS2O8dbEjpY0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iNZPVp2t9ccXyk3y1qRZC0LHmOM7VF6zLnyqu4+dypDa7syO9/4wxV5vFIULZT+fHCp8dASHhTChHolyAhO3uFY/L2RRUGAwQKtn70GnaJwexg5CVS95yk73+ry54k2N03aDszQAyutayUzlw9TrWLbE6gZ9IKAfq8MNxTsQU9U=
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
Date: Thu,  4 Jul 2024 00:33:03 +0200
Message-Id: <20240703223304.1455-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains a oneliner patch to inconditionally flush
workqueue containing stale objects to be released, syzbot managed to
trigger UaF. Patch from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-07-04

Thanks.

----------------------------------------------------------------

The following changes since commit 8905a2c7d39b921b8a62bcf80da0f8c45ec0e764:

  Merge branch 'net-txgbe-fix-msi-and-intx-interrupts' (2024-07-02 16:07:07 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-07-04

for you to fetch changes up to 9f6958ba2e902f9820c594869bd710ba74b7c4c0:

  netfilter: nf_tables: unconditionally flush pending work before notifier (2024-07-04 00:28:27 +0200)

----------------------------------------------------------------
netfilter pull request 24-07-04

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: unconditionally flush pending work before notifier

 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
