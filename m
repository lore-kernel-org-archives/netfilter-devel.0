Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2D928A3F9;
	Thu, 10 Apr 2025 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744290383; cv=none; b=I//7b9CnbrpAZLYdolOUcf44PoxbIh9Cb5a8PWuZtz07PVm81BJL3Gi0vTgBIdj0HN57p68Mhtj/sCxn8vV5xDsRPu7+nUD+Ssl8nQfp784Zy8T8Pz64nbKTgxzcd96WVFgj314aiGGF9qpFK00T9ONstuFRtP5hDLHmC+j2sK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744290383; c=relaxed/simple;
	bh=ilprkmVkg8ekcBXt5oGjKzpnFWff2QMcG+fxHM5EKFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tiGZP24Xq9rz+aGlWaUMrxIVVNflwoo7FOcdwObkgK9Nf/adJdZMmX3REki8F3lTi89QTZ3cdr7Ze1Dh2O/+SyeDCXNP6ET6zaZVsoDz2916MmrKa+WEIvJjqC+cDBqaGMQZqyEp11dZiZmYpI7a573BKLElyy5oJoy+UTTdn60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SWPdHzjl; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SWPdHzjl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Mc3TK
	Zgj1s8VPSM+/5mLbg/ZOiw9QDL0vilLiiDX2cU=; b=SWPdHzjlkMepb+REWSLFC
	a1rCViDwG4s0Ladwh/9/hN67EiNME78FO4obnaUqxcTnvbABeoj9/o1suoNTB914
	uhRq+KqzJxDuAEyAtVSmM6ggs1Zib52eQXmzPAwYpk+snUb6jDrKV/+cNLIIUgO1
	D/NsDmxrpyIv7xul45e2N4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAn7ZYbwvdn1ZBmFg--.18419S4;
	Thu, 10 Apr 2025 21:05:33 +0800 (CST)
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
Date: Thu, 10 Apr 2025 21:05:31 +0800
Message-Id: <20250410130531.17824-1-xiafei_xupt@163.com>
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
X-CM-TRANSID:_____wAn7ZYbwvdn1ZBmFg--.18419S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw47Ww43AFykuF4UZF1xuFg_yoW8Ar15pr
	1fJr17Jw1UJr4UtF1UJw4UJr1UJw4rJw1jyF1DJry8Zr1j9ry7Gr1UJr18Jry2yry8Gr18
	JF4UXryUJa15JrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUhF4_UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMQIrU2f3kNmpPwADsH

Florian Westphal <fw@strlen.de> wrote:
> I suggest to remove nf_conntrack_max as a global variable,
> make net.nf_conntrack_max use init_net.nf_conntrack_max too internally,
> so in the init_net both sysctls remain the same.

The nf_conntrack_max global variable is a system calculated
value and should not be removed.
nf_conntrack_max = max_factor * nf_conntrack_htable_size;

> When a new conntrack is allocated, then:
>
> If the limit in the init_net is lower than the netns, then
> that limit applies, so it provides upper cap.
>
> If the limit in the init_net is higher, the lower pernet limit
> is applied.
>
> If the init_net has 0 setting, no limit is applied.

If the init_net has 0 setting, it should depend on the
limit of other netns.

The netns Limit Behavior:
+------------------------+--------------------+-----------------------+
| init_net.ct.sysctl_max | net->ct.sysctl_max | netns Limit Behavior  |
+------------------------+--------------------+-----------------------+
| 0                      | 0                  | No limit              |
+------------------------+--------------------+-----------------------+
| 0                      | Non-zero           | net->ct.sysctl_max    |
+------------------------+--------------------+-----------------------+
| Non-zero               | 0                  | init_net.ct.sysctl_max|
+------------------------+--------------------+-----------------------+
| Non-zero               | Non-zero           | min                   |
+------------------------+--------------------+-----------------------+

net_ct_sysctl_max = likely(a && b) ? min(a, b) : max(a, b);
or
net_ct_sysctl_max = unlikely(a == 0 || b == 0) ? max(a, b) : min(a, b);

if (net_ct_sysctl_max && unlikely(ct_count > net_ct_sysctl_max)) { ...

