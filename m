Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECD718DF8D;
	Fri, 23 May 2025 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747992153; cv=none; b=CnkRksnCxC9/qqggiyzm9A6Mh/5Kvp3xsKFUqlXKdg/MB5gPxNRSMGcBmAvKztAi0RS5W8LZVhjPVSt0Sy1eTG8Y1VriQI83mAaR2OvMMKa6FAa3wIEFz4C0lJW1AGtmF+tuf1ur5nTmKA68Wa3hyprqvmpzm4t09lmDxA+mbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747992153; c=relaxed/simple;
	bh=11mX87hlq1IiTfNULkV+rW2dsQccJjtUKONwS12V25k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ozQkJZARH4Qm8n69tftQ7t3vRbnqtn14sGnqDxxOMZgM7A1U8x0ZPqlZdnfrnC859e6d/QDRvn0WWki7aY6W9+BYVumVrUw+IeQd5h6j9MVhBrK1+l1rhdrUa/0Lm0oJm2eeSHhl56CZ+TllKFhgu8O1LjmYThEKIePXA+Z0SOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FolwvLm4; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FolwvLm4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=bR
	1J39uj1vSGXynasl9DndSnDxH4yAwTdkqFXTcE/RM=; b=FolwvLm4oNVnTrnR4a
	uSltVDgxiEitRNyuWKystimQEbjL8LASpb34kEEUqcCmy+/azUW3sR8rlf74avPy
	pVMiQCtDhIjB0IFJJAzTrYv4AdpI7NqWszNb65aMmyw/6zlgw/YnhvouG/xQymEY
	VzjS/E8AvwqxFUZAC89KPdp/U=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXUaEaPjBomo+5DQ--.49546S4;
	Fri, 23 May 2025 17:21:31 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: pablo@netfilter.org
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	xiafei_xupt@163.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Fri, 23 May 2025 17:21:29 +0800
Message-Id: <20250523092129.98856-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <aC-B1aSmjDvLEisv@calendula>
References: <aC-B1aSmjDvLEisv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXUaEaPjBomo+5DQ--.49546S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF4DZw15JrWDKr1UCrW8Xrb_yoW3Kwb_uF
	Wvka1kKw1YkF12g3WDtFnxXws0gr92qFyrG3y8A3sIv34UAF1kWayDWrZ3Aw1Sgr48trnx
	u3ZIqa4a9r13ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUbrHUDUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMQxWU2gwGE+oBgABsY

On Thu, 22 May 2025 21:58:13 +0200, Pablo Neira Ayuso wrote:

> > Wether its time to disallow 0 is a different topic and not related to this patch.
> >
> > I would argue: "yes", disallow 0 -- users can still set INT_MAX if they
> >  want and that should provide enough rope to strangle yourself.

> The question is how to make it without breaking crazy people.

It seems that we need a new topic to discuss the maximum value that the system can
tolerate to ensure safety:

1. This value is a system limitation, not a user setting

2. This value should be calculated based on system resources

3. This value takes precedence over 0 and other larger values that the user sets

4. This value does not affect the value of the user setting, and 0 in the user
setting can still indicate that the user setting is unlimited, maintaining
compatibility with historical usage.

