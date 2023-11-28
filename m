Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lOBUMKK+"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B33FAFAA
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 13:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zeGYiVxkgOJDjuyKGD2aOHjrHMvlcaDgYCMyErvdESQ=; b=lOBUMKK+hF4U7bjs3Jl1rgxQLd
	QIo6V3n6OsIN2CCykF8MQlxkA7FURedJBbcc8DAo0Cuy2lzAEpDHrJVWgusWLZ++WOvndnH6uKJZb
	Oz/nuirM7UUrFHVTZL2vzZ2aPCra26ajAQtjvY0WHGQOX0UscnI2rCHaknLM5uSR85mhIHx+RtIvg
	LgGuCP266++gPKdM2aZ2Y8W28QLxsZMZBblUKBSGXQ3kkKyBpX9ZWuZpJYKDWNmmgibbt4pwGTNGc
	W0LFajAT78N1mWBu/FjYkrVkAHy3LZio2G3byjpGi5snHJZXGTo8/TGi1JJ5ocCJIJxUZMqcYj0zg
	c/0AJjUg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r85PF-0003yi-Fm
	for netfilter-devel@vger.kernel.org; Tue, 28 Nov 2023 22:14:09 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] libxtables: Fix two xtoptions bugs
Date: Tue, 28 Nov 2023 22:26:29 +0100
Message-ID: <20231128212631.811-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the first one is clearly a bug in my recent code deduplication
effort, the second one may be reckoned a missing feature.
XTTYPE_HOSTMASK is but used in many places and nothing claims the masks
must be contiguous.

Phil Sutter (2):
  libxtables: xtoptions: Fix for garbage access in
    xtables_options_xfrm()
  libxtables: xtoptions: Fix for non-CIDR-compatible hostmasks

 libxtables/xtoptions.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.41.0

