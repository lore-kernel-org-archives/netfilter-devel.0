Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DAhUXDV6"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D2B19F
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Dec 2023 01:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pUhSkziGwbT8g12jUkQEU5Cjr9agRcFA+OxFXNw6PqQ=; b=DAhUXDV6CPdL0a8Pk/u02SjvxT
	ohadSnb9RBrDUiwXre/GNX1FxDv9rT4ZF+S94HmjDnHIZginfTiw+FhB+0VsC5sQ0G027B5Kk3aT4
	hMCytqYQ+mbkurvdJrUOO/G1GeWO0L1Pj7XW/1YQ+Ck1LdBDImmEdIB2c227+q6X1GsLOY98s93lp
	Ih8x4eI/m0uBXbRqqbutpZppRnsnVWrus3G8Agx/E+c2n94BNL4xYHqHWVh6foFd57GFceufve5U2
	uZDtyTI5Z+zNHgQLDdVz8bBRLr64l5qGKl27V+I+zQ9aQ+Rl3FTaUG1tNPmDin4L4ahVceiix313M
	OD+9PDzg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r9Mir-0000Oq-D7; Sat, 02 Dec 2023 10:55:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/2] Review nft_options_check()
Date: Sat,  2 Dec 2023 11:10:32 +0100
Message-ID: <20231202101034.31571-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hard-coded list of nft options which take an argument is a
maintenance burden and also needless since the information is already
present in struct nft_options array.

After some indenting cleanup in patch 1, turn the list of options to
compare against into a loop over nft_options' elements.

Phil Sutter (2):
  main: Reduce indenting in nft_options_check()
  main: Refer to nft_options in nft_options_check()

 src/main.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

-- 
2.41.0

