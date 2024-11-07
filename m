Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F1820C000;
	Thu,  7 Nov 2024 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979144; cv=none; b=o4KILB/Cey1/iiSxPUHDp1T+f4HmFLlaVjohnFnoWDk86Qtv5KzCYbjrNIinduYxcCvMht8BS8SvrASODdU2gohnenCHfrrW5Bh1sVYLAIdzRz30pwk8IMzAN6ctkpmSyHTICXjfdEk93J44DIPExLGR36QRx/EDLTB7eMA5i4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979144; c=relaxed/simple;
	bh=wrMYqELGv+wRuOrz4NLr8jRoTAHjpBXUbfibQGRPcEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rSwrFk83dwevAhVdKUYi5aBeLfzSnHKkO/a9JVF+o//o4Hxrsw8MBHJVvjlzwHLi/ecQHg07WRWrvweN1eAjxy2VBZUBwGX1waQYBT8Q1TTCZ+8TRYzvkhTyx0jlLXEq3NBVjyRdJtqCWuUnMkDMF/jAAtmN6Z2aQ2aMXvrkkt0=
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
Subject: [PATCH net 0/1] Netfilter fix for net
Date: Thu,  7 Nov 2024 12:32:11 +0100
Message-Id: <20241107113212.116634-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: including kdoc update for new fields as per Paolo.

-o-

Hi,

The following series contains a Netfilter fix:

1) Wait for rcu grace period after netdevice removal is reported via event.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-07

Thanks.

----------------------------------------------------------------

The following changes since commit 50ae879de107ca2fe2ca99180f6ba95770f32a62:

  Merge tag 'nf-24-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2024-10-31 12:13:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-11-07

for you to fetch changes up to c03d278fdf35e73dd0ec543b9b556876b9d9a8dc:

  netfilter: nf_tables: wait for rcu grace period on net_device removal (2024-11-07 12:28:47 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-07

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_tables: wait for rcu grace period on net_device removal

 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 41 ++++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 7 deletions(-)
