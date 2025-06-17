Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392F293B53
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157363; cv=none; b=KBqUWmFgNU2b9T0OwAoaqZ7u+okE3FROOVjSRfrQCBZdL6dA6Q8ChLKnyq6xLmPQW/SAmxkhhuz92ZMgJUKGhkk0dnC47EDMV/JYSIrGGX6FryfeQF/51hLsrfq/dwHAdn1AuUrFmpO0tiIuKtrcPlrAwa5K2gy63jxHtCf4m+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157363; c=relaxed/simple;
	bh=OrkTgfftHQgEYekruDisPcE1SxxEkafgUgbn1EO1Rio=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QuIb7nXz15OmYPnfIQPdTlgCdQix3oqFnsx+kR47QIb5UBsA4zPAitUFV1t15F7dNZI04LOBZO+hxVNp/5VuGagqi6av+aKZFV/X+mcGJehb3P20XPHAVllZw0h4GhWxLtyDCAqsvo1r+GhLk/QhO+7SInuFWzdc2ycgOA010/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 06A2845FFA
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 12:49:13 +0200 (CEST)
From: Christoph Heiss <c.heiss@proxmox.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools v2 0/2] conntrack: introduce --labelmap option to specify connlabel.conf path
Date: Tue, 17 Jun 2025 12:48:32 +0200
Message-ID: <20250617104837.939280-1-c.heiss@proxmox.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enables specifying a path to a connlabel.conf to load instead of the
default one at /etc/xtables/connlabel.conf.

nfct_labelmap_new() already allows supplying a custom path to load
labels from, so it just needs to be passed in there.

First patch is preparatory only; to make --labelmap
position-independent.

v1: https://lore.kernel.org/netfilter-devel/20250613102742.409820-1-c.heiss@proxmox.com/

Changes v1 -> v2:
  * introduced preparatory patch moving label merging after arg parsing
  * removed redundant `if` around free() call
  * abort if --labelmap is specified multiple times

Christoph Heiss (2):
  conntrack: move label parsing to after argument parsing
  conntrack: introduce --labelmap option to specify connlabel.conf path

 conntrack.8         |   5 ++
 include/conntrack.h |   2 +-
 src/conntrack.c     | 124 +++++++++++++++++++++++++++++---------------
 3 files changed, 88 insertions(+), 43 deletions(-)

-- 
2.49.0


