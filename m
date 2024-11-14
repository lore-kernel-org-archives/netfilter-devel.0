Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EAB1F9EC7;
	Thu, 14 Nov 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731589514; cv=none; b=iuxUB/QlbZLf76321SjBL0ZGLg0pnMNHA2R9tDMc0X+I+YobUbW+RjSBJ9tc9gSXZjrAmRBhkNA7VA0pftn5Q8E4xvMe5t/MYq1LXfBRp5rI1Y93+u0tFP367zXUOHASYhlQWLj4gUdm2F3eJI8fD65+Uq/1RvbIV/swD5KukBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731589514; c=relaxed/simple;
	bh=e5D2qOgFKSBwHV7XhRukm34CjjDqrco4rYeRnDSVQ3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=acNvmARs0B9KkmdfIyZ+m+TkLGRmU6/ZhNrZBiuZ+NipNHQC/nprrG3fbi3v0J4g1V5W5pWhBl6KyA2DiyTi/ovo6xVOei++yvjIAvlON8FkhEu8IgHQUrLIEmP6ZD0IMChaPHGkmMMRljoT+jAoQldRgYgffWH8bpUtAXQk404=
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
Date: Thu, 14 Nov 2024 13:57:20 +0100
Message-Id: <20241114125723.82229-1-pablo@netfilter.org>
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

1) Update .gitignore in selftest to skip conntrack_reverse_clash,
   from Li Zhijian.

2) Fix conntrack_dump_flush return values, from Guan Jing.

3) syzbot found that ipset's bitmap type does not properly checks for
   bitmap's first ip, from Jeongjun Park.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-14

Thanks.

----------------------------------------------------------------

The following changes since commit 50ae879de107ca2fe2ca99180f6ba95770f32a62:

  Merge tag 'nf-24-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2024-10-31 12:13:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-11-14

for you to fetch changes up to 35f56c554eb1b56b77b3cf197a6b00922d49033d:

  netfilter: ipset: add missing range check in bitmap_ip_uadt (2024-11-14 13:47:26 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-14

----------------------------------------------------------------
Jeongjun Park (1):
      netfilter: ipset: add missing range check in bitmap_ip_uadt

Li Zhijian (1):
      selftests: netfilter: Add missing gitignore file

guanjing (1):
      selftests: netfilter: Fix missing return values in conntrack_dump_flush

 net/netfilter/ipset/ip_set_bitmap_ip.c                       | 7 ++-----
 tools/testing/selftests/net/netfilter/.gitignore             | 1 +
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.c | 6 ++++++
 3 files changed, 9 insertions(+), 5 deletions(-)
