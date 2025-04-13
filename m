Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B44CEEC3;
	Sun, 13 Apr 2025 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744506929; cv=none; b=pQo/x3RoZKsZ0QFJS75kambgTDmCXh7Gs9FCXPJXO1A/OYWq+S+GvgTRM4owAIFDZ+zyh5Uj4x0refpGZUwAzYAcImUX3wZLd2Ee7Qi+Iy6HkQvbonxbM5HQYRJ72qfY4TqFMQLuYC6A0osjU4dldJHnm0CQ3HZaNexTe2mtG2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744506929; c=relaxed/simple;
	bh=D3fz4fTUn8U8BzQBvnDXtTYCgY+nYo1uEy11tf3l2Io=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f69UbYMW9hcq20QT3YmZoby8LOXIltDnoDCrfD4rlpu7R9NJZxZI2h2AnoWhJtjaQzjhrEMm28Fjr2zZX48I8KA6ic1J03R5tybw1EK+kw7Vk/t6TWcaQSNJUdVxFgXkAa68PpVDT0thlVDLVJkp0ssSWy/ypdfoPe2pAYUy0Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZxhQ4vPm; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZxhQ4vPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=7LcWQ3v1o29xFMs0TzDObXscRocZHBUcBwlusIx/aPg=;
	b=ZxhQ4vPmQceYafLOPHyUXI2Cuzj1bWK8sBO23/wPXTZk/zT4jDXFfIvCAQfJc9
	4v+J5DvR1pM6MXZOJWG6VU4T8feGeTCx1poIgf4YfYTQR3RfWqfYg+71uQAE7aRV
	bYlT8PDsqIrJBaJAvje51iszFAv+6XlOqo7RlR14rXuQM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wC3EeHvD_tn8jDiGA--.20704S4;
	Sun, 13 Apr 2025 09:14:24 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: kuba@kernel.org
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	xiafei_xupt@163.com
Subject: Re: [PATCH V5] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Sun, 13 Apr 2025 09:14:23 +0800
Message-Id: <20250413011423.76978-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250412141630.635c2b34@kernel.org>
References: <20250412141630.635c2b34@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3EeHvD_tn8jDiGA--.20704S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur4UXr1fWFWfAry3Gw1Dtrb_yoW8Xw4DpF
	s8ZrykGa18XryrZrn8Aw1kZa4Uu397CrsIkrykury8ZFnFgFyUJFn0gF12qFyqyws7Ka1x
	Kay3WFy5Gr4UJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUppB3UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMRkuU2f7CLCQ8gAAsT

> If you CC netdev@ please do not post multiple versions a day.
> Please wait with posting v6 until you get some feedback (and
> this email does not count).

Thanks for the reminder and the review.

I’ll hold off on posting v6 until I receive proper feedback.
Also, I’ll double-check the Kconfig dependencies and ensure the
file doesn’t break builds when conntrack is not enabled.

Appreciate your time!

Sincerely.

> You need to be careful with the Kconfig, this file may be included
> when contrack is not built:
>
> In file included from ./include/linux/kernel.h:28,
>                  from ./include/linux/cpumask.h:11,
>                  from ./arch/x86/include/asm/cpumask.h:5,
>                  from ./arch/x86/include/asm/msr.h:11,
>                  from ./arch/x86/include/asm/tsc.h:10,
>                  from ./arch/x86/include/asm/timex.h:6,
>                  from ./include/linux/timex.h:67,
>                  from ./include/linux/time32.h:13,
>                  from ./include/linux/time.h:60,
>                  from ./include/linux/compat.h:10,
>                  from ./include/linux/ethtool.h:17,
>                  from drivers/net/vrf.c:12:
> include/net/netfilter/nf_conntrack.h:365:25: error: ‘struct net’ has no member named ‘ct’
>   365 |             min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
>       |                         ^

Add conditional compilation protection:

+static inline unsigned int nf_conntrack_max(const struct net *net)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	return likely(init_net.ct.sysctl_max && net->ct.sysctl_max) ?
+	    min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
+	    max(init_net.ct.sysctl_max, net->ct.sysctl_max);
+#else
+	return 0;
+#endif
+}

