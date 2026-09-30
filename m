Received: from out-zbxj-a71.jellyfish.systems (out-zbxj-a71.jellyfish.systems [198.54.127.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB593F660F
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790762275; cv=none; b=BJ1hAzZ59PEij7v4O15IsODWlYQ3z2h/4J3gX6BkWYSSEUxAQMlwiC9u6QKq59KkAG7S1kjb9hQEBdsekWdfCLxrLrogoKDda/XEdwvVVdbDOz1QNShT6MY2i/dIiu8rQ0RSyzuQHzrsroS8JUASLwW5heVJR8fGe+LK2vZOf4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790762275; c=relaxed/simple;
	bh=HonrRP4VKvHmwihnMqRuRSHdWKMUrL+bDGzbtuJ2+BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itQhWHczDoTbaFFygeM8MYUVHmVHecP011hiLZ0AzxAPrLeUAEVTxcSUTHLyVF5duhLew+hcrZG4Tg9H4AZl9Uo34wEkMfuUjOFqNR90vN7W0gRB02QS+nced8vki5WONsN0NaZC9APzOGB+AvL/AxrZBSBHikOZp1If7HJbLHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=K23bipjF reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="K23bipjF"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hvr7s0v9fz8sWQ;
	Wed, 30 Sep 2026 09:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790762266;
	bh=dU8BthyBomAlGFd325WDwPW6okd4opYc7MCPhPgLMf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K23bipjFlNWREyivigrtGNCF/mV4XU5agX+1BSyLAA+8jJpJnJ8TGPudcOYZtj8hk
	 2BZQzl1nIOrDmVBKVSbpDv7sONhYvjQA5CRt961ZHaVk3n5ojtvVWmwJXbb1gIyETx
	 l3Zk3bR9uL6We5bbohXbLCSl8ljoSMFp5a/b1/VDL/iV6JGlNXI9xmb6bH7pm82V45
	 BM+5wCSyhxuYh+wCYvsRGC55WOg1SnGGnWFIl74MtWqPqFnGcpoV9gm1DnLl7F3C7I
	 J7rp4hk5ktWlG+eiQsytMsHXgl3VdzCmzS16xx7SaSK41ykSxJJ0FYkkJnsyM5nIGr
	 b35AGlEozPCbQ==
From: Rahul Chandelkar <rc@rexion.ai>
To: netdev-bot+sinfo@kernel.org
Cc: Rahul Chandelkar <rc@rexion.ai>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/4] netfilter: conntrack: shared port parser for helpers
Date: Wed, 30 Sep 2026 09:57:44 +0000
Message-ID: <20260930095744.3681306-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179062896069.31693.871473945227845464@kernel.org>
References: <179062896069.31693.871473945227845464@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

> - How the issue was discovered, e.g. hit in production, hit during
>   development, syzbot report, manual code inspection, LLM or static
>   analysis tool scan.

The IRC and Amanda truncation was found by manual code inspection.
The over-long Amanda field case in 3/4 was reported by the Sashiko
review of v4.

Thanks,
Rahul
