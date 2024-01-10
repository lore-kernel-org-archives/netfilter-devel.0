Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817B650256
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U+76ZNxu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FJVEIdIwAf17Ay4Ph7xgUYVupoCu42vrpy/zwglnfcU=; b=U+76ZNxuEOq3lwp04Zt5n9D5J2
	GXhVXlzqX0TnV0VQCjvckI97jXV5EC+t2svSxNwGoWlq70HDY+zkrmMCn0FwbnU57cO6Hli71CrU5
	K5q/zVuALVMEbico/Twgd6qKIsLsrNlt2ZZ5uSgp2PIwkN/LICjZYmzd2CCfjst2tGyF+A/HEEoB5
	MS5kgiYAdPbNHz2VlXhUpGEJ5GiHgO6i4eEBDBXZF+cs0LXG1Wtlf1L21eO66tHQXyxwQnpHXuvbP
	0KnsCDkIFuwL3Cq11mncOfwkik3D8kplZyen2muK3mVx/G81Y8+FC7Z5EyIEXGFlEUvxlDZjt9g9m
	8abvmJfA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNhGV-000000005WA-3PIw;
	Wed, 10 Jan 2024 23:41:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 0/3] iptables-save: Avoid /etc/protocols lookups
Date: Wed, 10 Jan 2024 23:41:33 +0100
Message-ID: <20240110224136.11211-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V1 was a tad too simple: The revert is fine, but the (now) third patch
changes iptables-save output and thus potentially breaks test cases. To
avoid that, add patch 2 which enables "dccp" and "ipcomp" protocol names
in output. Apart from that, a single shell test case expected '-p gre'
in the dump. Replace the actually printed '-p 47' using sed in there.

Phil Sutter (3):
  Revert "xshared: Print protocol numbers if --numeric was given"
  libxtables: Add dccp and ipcomp to xtables_chain_protos
  iptables-save: Avoid /etc/protocols lookups

 .../shell/testcases/ip6tables/0002-verbose-output_0    | 10 +++++-----
 .../testcases/ipt-restore/0011-noflush-empty-line_0    |  2 +-
 .../tests/shell/testcases/ipt-save/0001load-dumps_0    |  1 +
 .../shell/testcases/iptables/0002-verbose-output_0     |  4 ++--
 iptables/xshared.c                                     |  8 ++++----
 libxtables/xtables.c                                   |  2 ++
 6 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.43.0
