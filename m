Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0AA279342;
	Fri, 11 Apr 2025 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344615; cv=none; b=pDzf8y4sDcbXOD5ZcaGO1fQ1jbjc9IGytiozCwA1uF5cT0oF0Wke8q7xkAZoBU0jfRt88qnTj4iDJ/aNOUmizJ8szA0H/B1bk6lkYtbHD1/f2dFQEyhoWu5wO8fEGCan73v7okbndbcxsswZWAwiwWSmdnrp3T7BuRxiM+m7qHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344615; c=relaxed/simple;
	bh=orXBmWlZ1fH8MEXCRUQQCdOBQD0uXtGGwxXUdYizSlE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VMhqwuZh5BEuQmuITnLGqdbKDqgT8r5cVCDseylpc6JHgiWrzT2f55U2D6UxjMa27pSmIzmfcrn/7FfquwEVfQZbajCpCZyxu7BA5aZDNYn3NENa0KUZCDX9frB9/gMeSK5l/6cz6QKHlYRursFKdwpYGGovc5BdgHa6cVXRuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AdUP8zbl; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AdUP8zbl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=orXBm
	WlZ1fH8MEXCRUQQCdOBQD0uXtGGwxXUdYizSlE=; b=AdUP8zbl4zCWA6q9vfwrm
	JTvtUzZA3crHApBWMUFPai/dn8RKSDFi2ZxSyd14ln6vmzBqBxAfVF9lQAIBtcwz
	BCrqhkjMo90ew1oorNGqs+FEwqVz41CZohAfPTXboEQLaB8gKN683XX8Kam1yET2
	2bfZCwH+Py+JaOu1XcokgU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wC39kzklfhnwaejFg--.48165S4;
	Fri, 11 Apr 2025 12:09:09 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: fw@strlen.de
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	xiafei_xupt@163.com
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Fri, 11 Apr 2025 12:09:07 +0800
Message-Id: <20250411040907.87007-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250410141655.GA20644@breakpoint.cc>
References: <20250410141655.GA20644@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC39kzklfhnwaejFg--.48165S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRRpBfUUUUU
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBgsU2f4kzRVGwAAs5

Florian Westphal <fw@strlen.de> wrote:

> > You can make an initial patch that replaces all occurences of
> > nf_conntrack_max with cnet->sysctl_conntrack_max
>
> Something like this:
> ...

Agreed, I can submit the changes later.
First of all, a patch should do one thing clearly,
which is convenient for maintainers to review.

