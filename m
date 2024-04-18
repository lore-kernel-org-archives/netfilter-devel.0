Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4CC3A1B6;
	Thu, 18 Apr 2024 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713402599; cv=none; b=O9YDTOtqnMmlZ6NFe8osSC4cxQQfualFJUwpeTpfuqBHj/KqMq9LDQfgdWYu8nwHrqDc3/FpjD4mJslg1zSKrpqEEC7JoV3HMimgjogAhwTZhI+e1bOTkzl5U8HWFYZj1fA6xGPS8DkScWw63dpc+ht2bky71YnOfECv1+ummfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713402599; c=relaxed/simple;
	bh=WICCEi2xmFCOQCnsxyn0bTO76ceRhP+RRNk90/t7Jcw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B4s4wpqEHedPFuMk8nfojn80NzVGMA+ughLoTRB7hgItSjMPCjbWbk0RGWv0Z9/R/Nh5DvX9DP3+p8jSZWRzS0HXXVKNCSM/DghoGuzCMvpZ7vwifwgWaXGYEuVfdSCJWeuxD6TpKwGM5irJ1cI62ybr0iGMWpWIBa0DF1QdjTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu, 18 Apr 2024 03:09:45 +0200
Message-Id: <20240418010948.3332346-1-pablo@netfilter.org>
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

Patch #1 amends a missing spot where the set iterator type is unset.
	 This is fixing a issue in the previous pull request.

Patch #2 fixes the delete set command abort path by restoring state
         of the elements. Reverse logic for the activate (abort) case
	 otherwise element state is not restored, this requires to move
	 the check for active/inactive elements to the set iterator
	 callback. From the deactivate path, toggle the next generation
	 bit and from the activate (abort) path, clear the next generation
	 bitmask.

Patch #3 skips elements already restored by delete set command from the
	 abort path in case there is a previous delete element command in
	 the batch. Check for the next generation bit just like it is done
	 via set iteration to restore maps.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-04-18

Thanks.

----------------------------------------------------------------

The following changes since commit 75ce9506ee3dc66648a7d74ab3b0acfa364d6d43:

  octeontx2-pf: fix FLOW_DIS_IS_FRAGMENT implementation (2024-04-15 10:45:03 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-04-18

for you to fetch changes up to 86a1471d7cde792941109b93b558b5dc078b9ee9:

  netfilter: nf_tables: fix memleak in map from abort path (2024-04-18 02:41:32 +0200)

----------------------------------------------------------------
netfilter pull request 24-04-18

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nf_tables: missing iterator type in lookup walk
      netfilter: nf_tables: restore set elements when delete set fails
      netfilter: nf_tables: fix memleak in map from abort path

 net/netfilter/nf_tables_api.c  | 60 +++++++++++++++++++++++++++++++++++++-----
 net/netfilter/nft_lookup.c     |  1 +
 net/netfilter/nft_set_bitmap.c |  4 +--
 net/netfilter/nft_set_hash.c   |  8 ++----
 net/netfilter/nft_set_pipapo.c |  8 +++---
 net/netfilter/nft_set_rbtree.c |  4 +--
 6 files changed, 62 insertions(+), 23 deletions(-)
