Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B63E78F4A;
	Thu, 22 May 2025 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905264; cv=none; b=W5Gb0Kz4YJ1Me5rNU/294wTCwl5v4Kl4d5kOcz6ZBzUdlu51Luk/idyiorlv+WeN5Zmft0PPLPrgzk9VcCrzW/bMtrD90hOuOmiig7uw7cyxqINMShYDcBe8rYlPRkVqvYYwmXHJuf42lis6poEeNCHn3yUeAbstasb/WCMD2Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905264; c=relaxed/simple;
	bh=N14/YhZ43lq0cVuSoifaGyBsC6zudQYaGXuOVuXbxBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8o0tXdnFYqvsKkSvZNfpKEZDegzayqyF9LqjLbRzyxQgUEGUzd1MNhCrgyC3E2PzbIuE33NarpBKJNJstIXbsm9rNSHcBI4jpyidqyclw73c/WoapAFKIyd3Fb+crooZl7O2oi9Wz9sbI/U0mOJUPKWW9w9GPZUHBUnRXm++aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pv99i+VC; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pv99i+VC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=N14/YhZ43lq0cVuSoifaGyBsC6zudQYaGXuOVuXbxBE=;
	b=pv99i+VCi7GPLuSUOG+wyHcxR3/9SACu66432iV7MAZz1acmdtPbF3U7m56Ilb
	DTL7ihzheVeWl+CcjNMjVZqgP8PRPkmHdaGSmfMIvTpvtY/d78qP+YqiSeQpfirr
	NWqsBrYX6FyhQaZyycwn7BqYVLtTGUNXG7gJydDClSaCQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD39k266i5owNZ9DA--.24847S4;
	Thu, 22 May 2025 17:13:31 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: pablo@netfilter.org
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
	xiafei_xupt@163.com
Subject: Re: [PATCH] netfilter: nf_conntrack: table full detailed log
Date: Thu, 22 May 2025 17:13:29 +0800
Message-Id: <20250522091329.45229-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <aC2q2OgYNVd8-5Yw@calendula>
References: <aC2q2OgYNVd8-5Yw@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD39k266i5owNZ9DA--.24847S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRGD73UUUUU
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKB9VU2gu6MozsgAAsU

Hi,

On Wed, 21 May 2025 12:28:40 +0200, Pablo Neira Ayuso wrote:
> Maybe print this only if this is not init_netns?
>
> Thanks

Thanks for the feedback.

You're right — for init_net, the netns information may not be helpful and could be redundant.
I'll update the patch to print the netns information only when net != &init_net.

Will send v2 shortly.

Thanks

