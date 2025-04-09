Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C068B1DE3A5;
	Wed,  9 Apr 2025 09:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190064; cv=none; b=a2NJ5KjFad1/thtOq4THT2QeigdJUK7n0POYZWfm3lzPn8NJ01jVWpefFg28jvfI0LZHr/Xgm3Q2gvI5ZVF7jEEk5zFVaZp37kkuBZRsvZWkzfj/YIq/1oHyGswHc8/nRe7aFzRsQ/jbcqa/Is+iEAViAO1mlle7Tb0Gpv9Evzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190064; c=relaxed/simple;
	bh=pidPjAxOQUC9n6C32lfwewePZ3cS4lFV9cAEdT1v+4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YrSHEgzgExUfyMP5VgtBrHcBL+RxVo46XrJxpwltCwVhSh/D6snE95otbUcm8FSHzTgKTHvfHGFFqX5/CY45oyHm8NL4jzTaUakhMjxcfsccgzLTCD57EPdJ6z0N3Am/OkNoGanJm4b3dGhdD2wnKK6lBDQ5EP+ua4bkJBYbT60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lG/4VHfL; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lG/4VHfL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=pidPj
	AxOQUC9n6C32lfwewePZ3cS4lFV9cAEdT1v+4U=; b=lG/4VHfLm/ZuH9BG9qDIM
	EcfSx2PPtF0SrMRZLuUbPDrjPSgxIsti0Szju+Uu4P5ln0WElCBX7CA7nUMrA+eG
	hVA7c8j4XVANu6TvuXctOTtFvvO6rmtiytTUXXelrD6VSAfT5jYfHPOy6HO5Yt/F
	bu5tiyQYiv5ixt729oFqxM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgCXX+owOvZnHjkdAQ--.48217S4;
	Wed, 09 Apr 2025 17:13:23 +0800 (CST)
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
Date: Wed,  9 Apr 2025 17:13:19 +0800
Message-Id: <20250409091319.17856-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250409072028.GA14003@breakpoint.cc>
References: <20250409072028.GA14003@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgCXX+owOvZnHjkdAQ--.48217S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRROJ5UUUUU
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiEBMqU2f2NYWJnwAAsN

Florian Westphal <fw@strlen.de> wrote:
> Whats the function of nf_conntrack_max?
> After this change its always 0?

nf_conntrack_max is a global (ancestor) limit, by default
nf_conntrack_max = max_factor * nf_conntrack_htable_size.

init_net.ct.sysctl_max is a parameter for each netns, and
setting it will not affect the value of nf_conntrack_max.

