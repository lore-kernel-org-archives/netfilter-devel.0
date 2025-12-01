Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4543074AE;
	Mon,  1 Dec 2025 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764587401; cv=none; b=SLCC9YUw2xgu6XzRQkhmi0GE8fjD7hvDiAF0OXIYk2pcVHoxz0bDaQivC5lZy+y3zM43HUQk5Kj/kHhn6FLDJLYE7V2NQ6BJY0vkBKl5FlGc7PX8Ivw8+5yBlFv41n5Zi0U+7vCE8dWqHTFrKYeeJN3n8Id2NFqMlQTc/40XlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764587401; c=relaxed/simple;
	bh=Pv1IQ51X0pudiAZXtLYDSjapHMQ71+Hadzj3B7QsbTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JT/B6PXGfv9xjsBWpKv0+PJzjvUv0zHEOqLl9/7FmeYexgEllhFf/UJ84RhJMc7vwL9Jp9D00lddiGuQcNf2VYUOpnbTvOdTGMRP4xnoCyTuh04ynx4QDXBhHCpypPHOTEx8+XxzF7k2vEoAsvRdrxX0v3p/R1YsF/LkC8bvQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=K4JZezq2; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="K4JZezq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=JYF+JHVCM5WmwlI4QfpzF6nTb6eCo8XGkwwqSahw5S0=;
	b=K4JZezq2Yz/JDanhpzuIT2ddgKEU9JdFw7QMnoW3cmZ/JQ/fDwqog5RHcYfM+z
	cbRnrfXzoZ2hiUm0dBbC7GNJcrlgnpeE3llL77JyALWXsc/kcWagxHDxo9f/Vt/N
	a0PVTf78c5Nuj2myYdsIk6Y/KsrXUkhnl+zgeorA6hKY4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3n5Q5dy1pWombDw--.29581S4;
	Mon, 01 Dec 2025 19:08:43 +0800 (CST)
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
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Mon,  1 Dec 2025 19:08:41 +0800
Message-Id: <20251201110841.9519-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <aO5WDcNAegXi1Umg@strlen.de>
References: <aO5WDcNAegXi1Umg@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n5Q5dy1pWombDw--.29581S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4fJFWxZFyUZr48Jr4rGrg_yoW8tFy5pF
	Wrtw1Iyrs7JF4jya9xKwn7ZF4rCrWfAF4akr98J340v3Z8Xa4Fvr4fKr4YvF9rCr1DGw4j
	va1IvrykAa4vvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUGD7xUUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBAXU2ktbpq7CQAAs+


>  I've applied a variant of this patch to nf-next:testing.
>  
>  Could you please check that I adapted it correctly?
>  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/commit/?h=testing&id=b7bfa7d96fa5a7f3c2a69ad406ede520e658cb07
>  
>  (I added a patch right before that rejects conntrack_max=0).

Historically, some systems or scripts have used 0 to mean “unlimited”.
In this way, some scripts that are set to 0 need to be adjusted.
Rejecting this value may break compatibility, so it would be good to document 
this behavior change clearly in the commit message and/or changelog.

>  
>  I wonder if we should update the sysctl path to reflect the
>  effective value, i.e., so that when netns sets
>  
>  nf_conntrack_max=1000000
>  
>  ... but init_net is capped at 65536, then a listing
>  shows the sysctl at 65536.
>  
>  It would be similar to what we do for max_buckets.

I would argue against updating the sysctl path to reflect the 
effective value. Doing so could be misleading, as it would no 
longer show the value actually configured in the namespace, 
but rather the clamped or capped value. Users might feel that 
their explicit configuration has been silently altered, which 
can be frustrating for professional users who rely on precise 
control. If there is a genuine need to see the effective value, 
it can be computed on demand or exposed via a separate parameter 
specifically indicating the effective value. Keeping the sysctl 
path as-is preserves transparency, predictability, and user trust.

>  
>  I also considered to make such a request fail at set time, but it
>  would make the sysctl fail/not fail 'randomly' and it also would
>  not do the right thing when init_net setting is reduced later.

I would be cautious about making the sysctl fail at set time. Doing 
so could lead to seemingly “random” failures depending on the current 
state of init_net, which would be confusing for users. Moreover, if 
init_net’s setting is reduced later, the sysctl behavior would not be 
consistent, and users might end up with invalid or unexpected values 
anyway. It seems safer to allow the set operation to succeed but let 
the effective value be determined by the existing limits, maintaining
predictable behavior.

