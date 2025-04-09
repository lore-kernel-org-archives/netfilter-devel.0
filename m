Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C28C4CB5B;
	Wed,  9 Apr 2025 04:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744172155; cv=none; b=Qi11dBg30RiBZu78fZew8HMiDKJtKptFb5ahp6e56EyGF9IgMwioRjBTdKQfoE7iZaZ+rnM30qhaV1oA9wJnM0jT2oIH78shjp+lJK3Ms+VffK+zyTmUIAntYUVtr5nSa+sBpAGx4FJUFMhMKBqZbMNgEpP6VV8aNcWTXP5HIKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744172155; c=relaxed/simple;
	bh=p6IjPj4yUpfSxJ63tPlYIL+14asNe/Fb6vAtkS0nHWg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M5dPA7TS9O81ExkbnHYZqBgWCWXwPho4XmypQGwEAjWOWcbQ5tRGqi5V9J9N+kZoVqSPlMDXLN5lBDR+SkJXaKQasuv/s7Lz5BBnaTVVftBNFYDFGZ7r78UPdPEBPOTXXycezTTaRTpYwuce+YEPa5eGq73qDn0t/PKvou9REx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EshB33Gp; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EshB33Gp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=p6IjP
	j4yUpfSxJ63tPlYIL+14asNe/Fb6vAtkS0nHWg=; b=EshB33GpT27uXc6FIqmnR
	tOsbpZDL1BJ246oNBs8nE5I3xR3JAzCB8lbHq3U+CZpoSNQVZJ+cXoV+F8r9sNUL
	ciooqhhzmiV8LBRGtT2kP2NbCQMqqZCPf9/F1dfjFmaGEJawC3ui1R0OEvcQbbOR
	x3f2/S9a7g3p92rHCfsdX8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wA3Htgn9PVn6X_ZEw--.22678S4;
	Wed, 09 Apr 2025 12:14:34 +0800 (CST)
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
Subject: Re: [PATCH V2] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Wed,  9 Apr 2025 12:14:30 +0800
Message-Id: <20250409041431.62307-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250408132854.GA5425@breakpoint.cc>
References: <20250408132854.GA5425@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3Htgn9PVn6X_ZEw--.22678S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRROJ5UUUUU
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKAcpU2f1QVIjIgACsX

On 2025-04-08 13:28 Florian Westphal <fw@strlen.de> wrote:
> That was one of the suggestions that I see how one could have
> tunable pernet variable without allowing netns2 go haywire.

Yes, After net.netfilter.nf_conntrack_max is set in different
netns, it should be designed to not be allowed to be larger
than the global (ancestor) limit when working.

