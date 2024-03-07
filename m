Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E102746AF;
	Thu,  7 Mar 2024 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777757; cv=none; b=n4eoV5hJQPowV3wTIjqL7Uaitl3dkw91lY8RVacJSco1oEbVBlL3WZOtVosqaPhRSOGTgyEB3Xdd3+pW6CLj39bwfuT3td4U+F47ZONUQ8SjAgDFZ4Mjetj3q/19PgLW1KmGz0F1gPHFrl5wCpIYXWul/7PE+qk0M+2a26XhbdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777757; c=relaxed/simple;
	bh=FZqcn1dA7f+3ZLxYDvVxdA8KDkW0btHWz03tuAEgcsA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g0qybvEerLPqHJMMqVe6mFYVddiYnIWNCu2kP7AGu+3lT9OD8vXg2AaI3CoGct8wbxfH8uIX2Dgs1mSgqJOfA6KfQptLy4iDY2xd+tmiPb/tsXsOEFROhYseGIAVBBWuNkB1RVqty3J1raJNLih43JF7sZnuWCiBTVuV07aReis=
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
Subject: [PATCH net 0/5] Netfilter fixes for net
Date: Thu,  7 Mar 2024 03:15:40 +0100
Message-Id: <20240307021545.149386-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains fixes for net:

Patch #1 disallows anonymous sets with timeout, except for dynamic sets.
         Anonymous sets with timeouts using the pipapo set backend makes
         no sense from userspace perspective.

Patch #2 rejects constant sets with timeout which has no practical usecase.
         This kind of set, once bound, contains elements that expire but
         no new elements can be added.

Patch #3 restores custom conntrack expectations with NFPROTO_INET,
         from Florian Westphal.

Patch #4 marks rhashtable anonymous set with timeout as dead from the
         commit path to avoid that async GC collects these elements. Rules
         that refers to the anonymous set get released with no mutex held
         from the commit path.

Patch #5 fixes a UBSAN shift overflow in H.323 conntrack helper,
         from Lena Wang.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-03-07

Thanks.

----------------------------------------------------------------

The following changes since commit c055fc00c07be1f0df7375ab0036cebd1106ed38:

  net/rds: fix WARNING in rds_conn_connect_if_down (2024-03-06 11:58:42 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-03-07

for you to fetch changes up to 767146637efc528b5e3d31297df115e85a2fd362:

  netfilter: nf_conntrack_h323: Add protection for bmp length out of range (2024-03-07 03:10:35 +0100)

----------------------------------------------------------------
netfilter pull request 24-03-07

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_ct: fix l3num expectations with inet pseudo family

Lena Wang (1):
      netfilter: nf_conntrack_h323: Add protection for bmp length out of range

Pablo Neira Ayuso (3):
      netfilter: nf_tables: disallow anonymous set with timeout flag
      netfilter: nf_tables: reject constant set with timeout
      netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout

 net/netfilter/nf_conntrack_h323_asn1.c |  4 ++++
 net/netfilter/nf_tables_api.c          |  7 +++++++
 net/netfilter/nft_ct.c                 | 11 +++++------
 3 files changed, 16 insertions(+), 6 deletions(-)
