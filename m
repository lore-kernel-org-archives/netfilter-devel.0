Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B2E1FE45C;
	Tue,  8 Apr 2025 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744100282; cv=none; b=MVb0V1+2BDnziwyFi4L1wLpYMCeT69dlbLWpA60JjhaflFiBDP6RblTtBLSAQcvR3gNAtjHEcRGlaoBczq5S5WPpFpryCSLZgPDvmNihkrFuLLxaeTysScEHTW8ljIEcIAuxEtmV568ib8AFfLyb6xKZo3/DYj0nI3fPrkrqtSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744100282; c=relaxed/simple;
	bh=z7C9+Aw9Lnh/zalZF4spiWpABhbIENKNGZqrSXIAjgo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYEcJ9u/pPt5vrZxT5K0eatseSvPNim2W5yWOVQDe+u6lsjBJtso/u4FVkrknjAimc0ybEZftvKtXrGFLXwP/gOeRxv1AAXNql282WgXqXExzN48f4v7POggIeLrK8BoySJ7A8XOH3DQ8YVAt8VpzTf7DB1tY879IO8gWz/rIn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mww3B8Jj; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mww3B8Jj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NbkKe
	gcA71YkI2H7dpP2G2+hQQJI+Zb1D4aPq7daL3U=; b=mww3B8JjD3DUBROqLEOsa
	y8/AkAmBfI7ip2WaPfbtmPa20YhgTpVLB/7vwO8/pgPXvmH++AWkjzd0cJvby+uh
	qBtmwuhxIFCnx2LKp866PSIDK5qMm7TuQDLOggu0XiDjUgiyTopYKakAqQlwPWTq
	e7RfAe3Tnq4ev+3grFBRew=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAXLdSI2_RnL8PbEw--.43400S4;
	Tue, 08 Apr 2025 16:17:14 +0800 (CST)
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
Subject: Re: [PATCH] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Tue,  8 Apr 2025 16:17:12 +0800
Message-Id: <20250408081712.54037-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250407101352.GA10818@breakpoint.cc>
References: <20250407101352.GA10818@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXLdSI2_RnL8PbEw--.43400S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryfCw4xXw13Xw1xCr43trb_yoWDGrcEqr
	Wqgry8Gw4Uu3ZxXan3t3Wxu3yUKay0yF4kAw47Zr4Sq3Z3tr97GFs09r1rZ3yxJw4DGrnI
	krn8JF129rnIvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUjEfO7UUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMQwpU2f02DVkxAAAsZ

On Monday 2025-04-07 12:13, Florian Westphal wrote:
>lvxiafei <xiafei_xupt@163.com> wrote:
>> The modification of nf_conntrack_max in one netns
>> should not affect the value in another one.
>
>nf_conntrack_max can only be changed in init_net.
>
>Given the check isn't removed:
>   /* Don't allow non-init_net ns to alter global sysctls */
>   if (!net_eq(&init_net, net)) {
>       table[NF_SYSCTL_CT_MAX].mode = 0444;
>
>... this patch seems untested?
>
>But, removing this check would allow any netns to consume
>arbitrary amount of kernel memory.
>
>How do you prevent this?

Yes, this check needs to be deleted
All netns share the original nf_conntrack_max. The nf_conntrack_max
limit does not limit the total ct_count of all netns. When it is changed
to a netns-level parameter, the default value is the same as the original
default value (=max_factor*nf_conntrack_htable_size), which is a global
(ancestral) limit, and kernel memory consumption is not affected.

