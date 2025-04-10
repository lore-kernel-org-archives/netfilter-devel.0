Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F773267F70;
	Thu, 10 Apr 2025 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744279403; cv=none; b=Je9/2pIFLhU4EpxUGDHeI7L/+QxKBEdK7cGsgWQgJCpRrr4SSah4Qa38gXmu5cfritarHVElxdduTbNC/iV+i+uJ3MZs/ozm/g1nJo7fOgmLNg3OA9rMwGBgeDCVvYvuiMTrfRs8+sVfVFtQx2RSWK+EI0b1L7u388XqNt+Hymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744279403; c=relaxed/simple;
	bh=lmppQfbdrQUGQjfQF8ivePB/2k4sgLFbvW5qYbiK03A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KN9ZkxiUANTnajhBDMpXjv+rVR5Ww+D5VBz5l19OFxpWqD1NCJTEsEdKOkg7upnRWCWfqZ3iWgz8YAf7M3LHDTQyH7fxn5VVamV9Y0JvaqLKBA+BO5dONFg/pCdmt3lxPeosaFykp8RyLDEoYdkjuDssHu7gstZrbJLZJV4v9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Uta5NtAj; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Uta5NtAj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Jo0rD
	BCUe7dubutz5qYlyihW1Ld3IGN6iN2C5WAGgvg=; b=Uta5NtAjXZSSn6RDFkBTB
	hlBqqHRksDOPTSeJ8PEE36y7YJ5NypKkHU2FU//kJlqIyj4hoPacbwgZN8g0gRj2
	PJC9PhZDl+73TXoKZXE/0tgl1aFxBcpVjgDRls9isv6ZwKckcC/CoNfri9jQZK7k
	ZoTxr8GG6F+LbcPgQu2ExI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wAnhDEzl_dnH5BEFg--.53412S4;
	Thu, 10 Apr 2025 18:02:28 +0800 (CST)
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
Date: Thu, 10 Apr 2025 18:02:27 +0800
Message-Id: <20250410100227.83156-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250409094206.GB17911@breakpoint.cc>
References: <20250409094206.GB17911@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnhDEzl_dnH5BEFg--.53412S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4rKFyfZw1fGFWftw47Arb_yoW8tF4rpw
	4rt39rJw1DJrs0y3WUX3sFyFsYv3yfAa1Y9Fn8GF95u3ZrKr15Cr45tFyfXryvkr1xKF1S
	yw4j9ry5Aa10yFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUhF4_UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKAwqU2f2zrGtbwACsz

Florian Westphal <fw@strlen.de> wrote:
> net.netfilter.nf_conntrack_max
> is replaced by init_net.nf_conntrack_max in your patch.
>
> But not net.nf_conntrack_max, so they are now different and not
> related at all anymore except that the latter overrides the former
> even in init_net.
>
> I'm not sure this is sane.  And it needs an update to
> Documentation/networking/nf_conntrack-sysctl.rst

Yes, it needs an update to
Documentation/networking/nf_conntrack-sysctl.rst.

in different netns,
net.netfilter.nf_conntrack_max = init_net.ct.sysctl_max;
the global (ancestral) limit,
net.nf_conntrack_max = nf_conntrack_max = max_factor * nf_conntrack_htable_size;

> in any case.
>
> Also:
>
> -       if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
> +       if (net->ct.sysctl_max && unlikely(ct_count > min(nf_conntrack_max, net->ct.sysctl_max))) {
>
>
> ... can't be right, this allows a 0 setting in the netns.
> So, setting 0 in non-init-net must be disallowed.

Yes, setting 0 in non-init-net must be disallowed.

Should be used:
unsigned int net_ct_sysctl_max = max(min(nf_conntrack_max, net->ct.sysctl_max), 0);
if (nf_conntrack_max && unlikely(ct_count > net_ct_sysctl_max)) {

min(nf_conntrack_max, net->ct.sysctl_max) is the upper limit of ct_count
At the same time, when net->ct.sysctl_max == 0, the original intention is no limit,
but it can be limited by nf_conntrack_max in different netns.

> I suggest to remove nf_conntrack_max as a global variable,
> make net.nf_conntrack_max use init_net.nf_conntrack_max too internally,
> so in the init_net both sysctls remain the same.
>
> Then, change __nf_conntrack_alloc() to do:
>
> unsigned int nf_conntrack_max = min(net->ct.sysctl_max, &init_net.ct.sysctl_max);
>
> and leave the if-condition as is, i.e.:
>
> if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) { ...

Yes, each netns can pick an arbitrary value (but not 0, this ability needs to
be removed).

Should be used:
unsigned int nf_conntrack_max = max(min(net->ct.sysctl_max, init_net.ct.sysctl_max, 0);

This also needs an update to Documentation/networking/nf_conntrack-sysctl.rst
to explain the restrictions.

