Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C554189B9;
	Thu, 24 Sep 2026 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790273975; cv=none; b=fUFc41VzxK57xeq2t+bT/oW+JNFoyCoGVefqQwbeB0CIszD4P0kKlwiiY8OPWWjw4e/fgcryAUP1Aa0CthiN7dTw7tyI6Ayd35TS/JnT70O8palR1IC1IwlDXCHi7v2pxt3SdsACYMCk9NFjLbYp1Pft+9HH3z/XkC1HTp6rABY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790273975; c=relaxed/simple;
	bh=fEWkivyW0Xg+5tCDpe7BSCpy7UchQrT2KM9SpIlvTdY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QHfa6yTXIbUmwgfOem69OjgaQnGOBqItfcQj/dFt9gD3zAdUJHE78H+CP7D+G3rZ6q9awA7SI6hfT4manwqkWNvSnr1E0W/pTgGmKgpGEBKLjqDUZbJRXR9YS70q7b+zV0MZAE7t6vY/WqyqQxuUhf779znRuSIJXGTMkMlusY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=none smtp.mailfrom=orbyte.nwl.cc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orbyte.nwl.cc
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <n0-1@orbyte.nwl.cc>)
	id 1x9o2V-000000001mT-2KKw;
	Thu, 24 Sep 2026 20:19:23 +0200
Date: Thu, 24 Sep 2026 20:19:23 +0200
From: Phil Sutter <phil@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] New mirrors to public git.netfilter.org repositories
Message-ID: <arVpqySeeTQ7ZA06@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents git repository mirrors at
repo.or.cz.

Due to a recent surge in automated AI agent traffic, git.netfilter.org
has been experiencing increased load. To keep things running smoothly
for everyone, we've set up off-site mirrors of our most active
repositories as an alternative way to retrieve our git trees.

- https://repo.or.cz/conntrack-tools.git
- https://repo.or.cz/ipset.git
- https://repo.or.cz/iptables.git
- https://repo.or.cz/libmnl.git
- https://repo.or.cz/libnetfilter_acct.git
- https://repo.or.cz/libnetfilter_conntrack.git
- https://repo.or.cz/libnetfilter_cthelper.git
- https://repo.or.cz/libnetfilter_cttimeout.git
- https://repo.or.cz/libnetfilter_log.git
- https://repo.or.cz/libnetfilter_queue.git
- https://repo.or.cz/libnfnetlink.git
- https://repo.or.cz/libnftnl.git
- https://repo.or.cz/nfacct.git
- https://repo.or.cz/nftables.git
- https://repo.or.cz/ulogd.git
- https://repo.or.cz/ulogd2.git

These links are also listed on netfilter.org:

https://www.netfilter.org/mirrors.html#git

Happy firewalling!
