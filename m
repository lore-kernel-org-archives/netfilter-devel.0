Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B861326159B;
	Tue,  8 Apr 2025 08:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744101796; cv=none; b=NWmIGNjd8K6itpVjl4AvO7sIoGl7fsh78dU6jdOFVwQQZiL+tvgiLKUz9R8nqCoZveG+qdhuFJEoAwnpCBbN/P6UlyVEP3GjPajNtxMYPguqkIerFI9fd08w9YSExVo5h6cstHPkhNSmY1eaJcmUd7TY4SnISP5H8QTh4V/1kRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744101796; c=relaxed/simple;
	bh=QTCjrxQ/e5rfDTMmD+U3jR19pQGVrX4IP/gtSGx0nDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TMrECA51/BmAocUw7iAUF7Io9R942h/64cyQJgww9L9clpS9SXc77rwfabFjxOvy6qRXeVIZfpPjfKMz/U+Lps2OtA9sx2na1Yeb7GUWIM1HiXIcp4/UNgwUb+lis1ZrZV0ET6R07QkL4T+4H/SSahlo32y0Ypu2Vhu33B/YvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Rk5vQxf1; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Rk5vQxf1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QTCjr
	xQ/e5rfDTMmD+U3jR19pQGVrX4IP/gtSGx0nDY=; b=Rk5vQxf1dDZh6DHjYtXHf
	iLtwJ0LiRu5o2kqSfDBuShs5nnDJ4wSOcpSY7GIhTwsi17ryX5GoQ0xLK9LzMST5
	dEHUHp6uAJDidE2vZRaCwdueFZB0fLLDD5tjkbjHevtt8O0PRTB6XbRfd0VbPmLK
	2trqy3IK3oJTY9YGPEZfYo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCHlTrc3fRnuKo+FA--.30056S4;
	Tue, 08 Apr 2025 16:27:11 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: ej@inai.de
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
	pablo@netfilter.org,
	xiafei_xupt@163.com
Subject: Re: [PATCH] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Tue,  8 Apr 2025 16:27:08 +0800
Message-Id: <20250408082708.56208-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <66ror6q2-7pq2-os23-rq8r-8426ppr6pnps@vanv.qr>
References: <66ror6q2-7pq2-os23-rq8r-8426ppr6pnps@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHlTrc3fRnuKo+FA--.30056S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr4DGw1kAr13Jr47uw47XFb_yoWfCrb_ZF
	ZrXFnFkw1jvrs7Jry5ta1xZa93KFW8Ar1UA3yrtwsIkr1fXw15GFn2grW3ZF4UGr4ruF15
	u3WSgw4kurWfujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU9NVDUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBMpU2f03Noc4AAAso

On Mon, 7 Apr 2025 12:56:33
Jan Engelhardt <ej@inai.de> wrote:
> By inheriting an implicit limit from the parent namespace somehow.
> For example, even if you set the kernel.pid_max sysctl in the initial
> namespace to something like 9999, subordinate namespace have
> kernel.pid_max=4million again, but nevertheless are unable to use
> more than 9999 PIDs. Or so documentation the documentation
> from commit d385c8bceb14665e935419334aa3d3fac2f10456 tells me
> (I did not try to create so many processes by myself).
>
> A similar logic would have to be applied for netfilter sysctls
> if they are made modifiable in subordinate namespaces.

The patch is to use nf_conntrack_max to more flexibly limit the
ct_count in different netns, which may be greater than the parent
namespace, belonging to the global (ancestral) limit, and there
is no implicit limit inherited from the parent namespace

