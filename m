Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2A01F60A;
	Fri, 20 Sep 2024 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726827110; cv=none; b=kOqiUNyMeyvJcbRRhhwILmEY1BQbERMe2zygfraqo/7YYsygqaiY4RR3TVTkUoMs4Wt9pBdqXKHjliKGg49iBp/iEy90DwzFtBQCi3vgW6k/gId/hLQa1tRUTkle4aVaOYfeZ27dAwKVNltq2OitNxLFVEXNHgAyOTM4vIELAq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726827110; c=relaxed/simple;
	bh=ulAoXO+hBjXHkD2BJC1plB0VA1QJHPDMHah5ZYwi9Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UnpDwJ1LG12A7xGerzAQdMSP6f9oDKBc9Zx7SIxEUiVyxxQ1u6a5/I+mhag0ma4YOULfgRR8aXGqTT0FLSx2awFOuX7ZFRG7fA4o2lkIcT+1TWZ06jFk/9v88+zSjre94UR69e5OU6dN2/46ClzgvAAKjMz6ae6PS9I/fkMxiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1srac6-0002is-2E; Fri, 20 Sep 2024 12:11:46 +0200
Date: Fri, 20 Sep 2024 12:11:46 +0200
From: Florian Westphal <fw@strlen.de>
To: stable@vger.kernel.org
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: stable request: netfilter:  make cgroupsv2 matching work with
 namespaces
Message-ID: <20240920101146.GA10413@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

Hello,

please consider picking up:
7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
and its followup fix,
7052622fccb1 ("netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()")

It should cherry-pick fine for 6.1 and later.
I'm not sure a 5.15 backport is worth it, as its not a crash fix and
noone has reported this problem so far with a 5.15 kernel.
