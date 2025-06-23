Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53BD2367A8
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 09:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671004; cv=none; b=gS8k+ZpwuJmdPXkSYDp4AMw2AnzaVb2F6/LVGhpIIrcp8NfU+TcwAsKTygjSvgkkM1gWDfRglSp1u/1US3LPKex9aa7Q+IAQoAvsDl6XffxHSW4kLa2dWrzt3hfnMu1ZQhOqwh/MdyDB+b4xdSq2QQWxnuAOLvwEtEVAPd3MwEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671004; c=relaxed/simple;
	bh=dUQj6E7GEHovskFfeMnPFjp/0hFxyvTXS526pAIHvtI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qNS3Y34Zf0hBW46qcRRetJCXRN6KqRLLZHB1A2JsMPCIiEOWb4jRkVLkb+bT4n58U9gC7h0TnShGSu0CsHiHZmUjSe0o4BZ7o60URwx5dq/q6DbYt8EYLIrWvQF8cyWqyX4sDOek+2e1YsoLeHzLTrxxHSdZFur0pXCxYifa6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 0EBA7461DB
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 11:29:54 +0200 (CEST)
From: Christoph Heiss <c.heiss@proxmox.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools v3 0/2] conntrack: introduce --labelmap option to specify connlabel.conf path
Date: Mon, 23 Jun 2025 11:29:26 +0200
Message-ID: <20250623092948.200330-1-c.heiss@proxmox.com>
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
v2: https://lore.kernel.org/netfilter-devel/20250617104837.939280-1-c.heiss@proxmox.com/

Changes v2 -> v3:
  * addressed minor cosmetic nits, no functional changes

Changes v1 -> v2:
  * introduced preparatory patch moving label merging after arg parsing
  * removed redundant `if` around free() call
  * abort if --labelmap is specified multiple times

Christoph Heiss (2):
  conntrack: move label parsing to after argument parsing
  conntrack: introduce --labelmap option to specify connlabel.conf path

 conntrack.8         |   5 ++
 include/conntrack.h |   2 +-
 src/conntrack.c     | 126 +++++++++++++++++++++++++++++---------------
 3 files changed, 90 insertions(+), 43 deletions(-)

-- 
2.49.0


