Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B74524A067;
	Sun, 27 Apr 2025 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745741725; cv=none; b=IXG4Bhdw7VaOLYrY46OSfR7kmfxhVsDGfKSoVFqHKMZv3wGnozT5tYa9naYAfYok7cB1aOfnJlbmElmNZtjY2h0kGN7qtYMykNG3pQTK3kRQgov3T676jF8NVi/zEaOR2dUH7LOzQoFt5MRdoHmRtFcHOfowAiQ2g89/BWMv2JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745741725; c=relaxed/simple;
	bh=Mn80SW3Km6lATD9DaG7Li6MT8pGTVqd9Ppo3rt/T/J8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nPQcAMB1GY7fwsdTDORXpzGYxH9KGcR028aLNsl9P6twQ+Rqt1RLXN1t+0tRb5MW1WIPp5DgT6v9EzeWN+3FmF48jPjV93cKUzuUxrVpLIVsfeUuYzOhadUqajwJk0UJ31cSHI5ry6gqE6ZFst+49x3eF2KZyc9DYhcttkhQ5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hWN+lRm/; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hWN+lRm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Mn80S
	W3Km6lATD9DaG7Li6MT8pGTVqd9Ppo3rt/T/J8=; b=hWN+lRm/M1Yd7f0H7CtQe
	jz7I97H5IfTJ3Jt98EUx/PY+2YI5D+Edq8MEVls8BWGpYJgBVdpJtdGVS7t/Ac8q
	gbxihVwQAyjqqdIdkrafvWnJWMHMxPMydLlhDbWNVeVBnNq1xr1VQ054DJCu2+i1
	4wBiSR/HtX4uu7wPs5BOCg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wCXGBpd5w1ok9FMCw--.42436S4;
	Sun, 27 Apr 2025 16:14:22 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: fw@strlen.de,
	xiafei_xupt@163.com
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
	pablo@netfilter.org
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Sun, 27 Apr 2025 16:14:20 +0800
Message-Id: <20250427081420.34163-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250415090834.24882-1-xiafei_xupt@163.com>
References: <20250415090834.24882-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXGBpd5w1ok9FMCw--.42436S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4rCF1fXryUJry7Cr47CFg_yoW3KrXE9F
	n2kas3t3W5Xay0gr47tr1fZw40q3y7Za48ArWFqrW7J34Svrn5XFs2kanIva1Sqay8GF4D
	tF1DGrW2vw45ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUjtrc7UUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMRo8U2gN4WSBvQABsZ

Hello!

My name is Xiafei Lv, and I sent patch v6 on April 15, 2025. As of today, it
has been nearly two weeks, and I have not received any feedback. However, the
patch has been tested successfully, and you can view the details at this link:
https://patchwork.kernel.org/project/netdevbpf/patch/20250415090834.24882-1-xiafei_xupt@163.com/

I understand that kernel development is busy, and maintainers may have many
things to deal with and may not have time to review my patch. With this in mind,
I would like to politely ask what steps I should take next? If you have any
questions about my patch or need additional information from me, please feel
free to let me know and I will cooperate as soon as possible.

Thank you very much for taking the time to deal with my request, and I look
forward to your response.

Best wishes!

Xiafei Lv

