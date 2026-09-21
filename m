Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791EE3B2D39;
	Tue, 22 Sep 2026 05:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056581; cv=none; b=CWdBc52/9YzE1E04pPAxVDTntae1UAtjtUG+0NkOH+/Krn4y0E0g8LkFmiXL9Xj+A6TdjNNliOqAJ214P+Dbv9Y/ygXaF6iyH5nPR/fkNGrtQFcxVBrOxMpjmf0Q8vL5PTc1bRbNdS49aXmbunJ+AZ4Nb/s52UUja1enwQjLMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056581; c=relaxed/simple;
	bh=kf0iRS48tiQYMW8S4ekeCnUPBauVHkdddyakPW46MII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxxscergc6ylMqTC+G7LQGJTYK92HX6jijoAJMlgh9DVRXDwU5X9zWQY+toPKrNlsXarx+VCKtxaCO+PXtl8dNmdcYSuE3gE7/CvuEBwsMPWo7IVmYyZ7AHwijuuCZJOhBKpfZg3SU5Cz5k2ZCK2ZGOjJYrhfrigIkE2obIh1NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=TAmaUoP5; arc=none smtp.client-ip=111.22.67.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="TAmaUoP5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=TAmaUoP5PszCElD2Yl9SAohU7zB3aPQKrZ5/1Gn3Mr6kOwUMPXREm2vwToGaPOo92otz9+hoObSkn
	 /qC42Iu/kc/zkpoJDlVPiIPSthXc8hbcKiihxvjNhmEnF5VLhHWxn+LYn8MNEgEqPDOrfhpEwE4a+a
	 +4Zvs0bq7NPEQfNQ=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16ab217c1f00-276c7;
	Tue, 22 Sep 2026 13:53:05 +0800 (CST)
X-RM-TRANSID:2ee16ab217c1f00-276c7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.102])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16ab217b4b34-a692a;
	Tue, 22 Sep 2026 13:53:05 +0800 (CST)
X-RM-TRANSID:2ee16ab217b4b34-a692a
From: lvjunyu <lvjunyu@cmss.chinamobile.com>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kuba@kernel.org,
	lvjunyu <lvjunyu@cmss.chinamobile.com>
Subject: Re: [PATCH] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets
Date: Mon, 21 Sep 2026 21:01:51 +0800
Message-ID: <20260921130151.686386-1-lvjunyu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <178997694260.2160803.768338135360205258@kernel.org>
References: <178997694260.2160803.768338135360205258@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thank you for the review.  Both High issues are legitimate.

1. Incomplete fix: nf_csum_update() indeed takes the pseudo-header
   branch for CHECKSUM_PARTIAL, applying the address delta with the
   wrong sign.  My test environment had delta=0 (masqueraded address
   equals the original), so this was not exposed.  The same applies
   to IPv6 via inet_proto_csum_replace16().

2. Wrong discriminator: skb->encapsulation cannot distinguish the LCO
   state (complete checksum, needs fixup) from the seed/offload state
   (pseudo-header seed, must not touch).  SCTP-over-UDP would be a
   false positive; L2TP-over-UDP a false negative.

I have prepared a v2 that:
  - Uses the offload target (csum_start + csum_offset != &hdr->check)
    to distinguish LCO from seed/offload state
  - Temporarily flips ip_summed to CHECKSUM_NONE so both the address
    and port updates use the csum_replace*() path
  - Updates the comment to describe both CHECKSUM_PARTIAL states

v2 will be submitted as a new thread shortly.



