Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AAD4430;
	Mon, 14 Apr 2025 03:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744599962; cv=none; b=eBV5GtckZ7aCFIRZmBaE8YBRnAJL5BUksLvBfSKmv++vvONp8IKCrojl44RcaIujsbw7rX3sdWJb0AVSvaR1+M9UdD7rYhd8k3peXootz1a5WT+3vJgEOaRq0Y/CRvKmJfH9fnDHp9rKLb8Igo/bUG+sz4tIvH9jjLAorwM304k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744599962; c=relaxed/simple;
	bh=kpBPKwbG2d4U5uu9XwFgcdKlogwWZUs1gsJB2mzYmsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yw3qGmB5CsY5uPPNKYbJXcgDSok1WZSTGef/nobkYRFUqCYWhKwhtRauErn83xFRM1VhCmaHdU6S/lT/bcz77oukmWuAlQGkkBSz2MDK8xzZcAaHC55spNKgHxKvPYZuLl+dbF5Mq2X1U0bBkHE4yG9dh70LIzxqgF3pV1O8Yec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=npIcDJHE; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="npIcDJHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Cq4E2
	6iu20lnM9BSp9H78ESEizHTdfd4SvMACFK0RJw=; b=npIcDJHErj6f53MGj50L7
	j7PkF7DaYfLKf+ZI7MKTcE1nxmh+UIBuGdbwTHWhL/3lEja5TaXq7OiWwjFBwvBJ
	A+ScSJa02e1EpWSKXbbushuBagCZMB0vWF12huPHhq7qqqtnjN9LG4VqU0jpEL/S
	F/YALdkhJTFo2ryCHTx6c8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDHjxFYe_xn1ERKGQ--.56117S4;
	Mon, 14 Apr 2025 11:04:57 +0800 (CST)
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
Subject: Re: [PATCH V5] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Mon, 14 Apr 2025 11:04:55 +0800
Message-Id: <20250414030455.25322-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250413090755.GA5987@breakpoint.cc>
References: <20250413090755.GA5987@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHjxFYe_xn1ERKGQ--.56117S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1rKFyruFW8uw48Wry8Zrb_yoWkXFX_KF
	WUX3Wrtw1UZF1DKr1UKrnxAryqgrWUGFn7Aw1Yqr4rZrn3Z34kJrZ3WrW8X3ZrXF18trZI
	vw1kZw1UAry7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUjtCzJUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiEA4uU2f8SUINswABsM

On Sun, 13 Apr 2025 11:07:55 +0200 Florian Westphal <fw@strlen.de> wrote:
> Is there a reason you did not follow my suggstion in
> https://lore.kernel.org/netdev/20250410105352.GB6272@breakpoint.cc/
>
> to disable net->ct.sysctl_max == 0 for non init netns?

in https://lore.kernel.org/netdev/20250410105352.GB6272@breakpoint.cc/
> > min(nf_conntrack_max, net->ct.sysctl_max) is the upper limit of ct_count
> > At the same time, when net->ct.sysctl_max == 0, the original intention is no limit,
> > but it can be limited by nf_conntrack_max in different netns.
>
> Sounds good to me.

It seems that there are two ways to change it:

1. Disallow net->ct.sysctl_max == 0

2. Allow net->ct.sysctl_max == 0
the original intention is no limit, but it can be limited by init_net netns
in different netns. When init_net is modified, it will change dynamically.
    +----------------+-------------+----------------+
    | init_net netns | other netns | limit behavior |
    +----------------+-------------+----------------+
    | not 0          | 0           | init_net       |
    +----------------+-------------+----------------+

