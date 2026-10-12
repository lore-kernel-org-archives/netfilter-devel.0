Received: from out28-219.mail.aliyun.com (out28-219.mail.aliyun.com [115.124.28.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6D2324B22;
	Mon, 12 Oct 2026 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796857; cv=none; b=dInA0X00EP6PT4v/KGOxB3ZrRvWIOYQVtZJ/a4OIuXuoczRq00zx5Ez8spaEjOExwWUg3pJjcP9jP2I03EXrodWiKf3LJFcoOH2qaswbysBdjOVbiXcrhb36CpFw7n2L3GSWRpMo4ib/31Wn3m9tU3WkaUyQgmilG15AaK1K8wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796857; c=relaxed/simple;
	bh=d+gFYcEnLii11OvhNawy2jXchZRSsqOetKdwDoS2D8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcD3nbta4VvycGWI/5v9RXfjJaCkKybvQYxaQgWztOyMVU5ua/rEzU97u8FcFjIZi9CeXxQ7Z/idTDFcHE4yQKjYObxw80Hqib2BuTJxSfhkaezzJJBGMwLiZKxdfroX37h89ayL1yRupSEaJzLvS3kHyadjl2BBQZbeVa4yrck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=qa0ZNKlw; arc=none smtp.client-ip=115.124.28.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="qa0ZNKlw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791796846; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aYYQ62aVof7qszNn19ukjFeX2XpVm3pY4vkHjqLNOmE=;
	b=qa0ZNKlwgnwbdhdAlOJ2C5immZK7MbEU1e656JI6q/khFrbj8qSVXeNqHuZJAh8MOFWOusCbeRd4rbwdwnLWjS8ggc+0eSFSupWm+vBTNRjTElerChMQiOye34Jl+frppch6vbtLgkH2YgnhkZRFJdU6ZD84LQQ2j3UyGHphSqc=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.2042257|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0103276-0.000588983-0.989083;FP=16211396117861819911|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032023038;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.jZyMeHZ_1791796845;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jZyMeHZ_1791796845 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 17:20:45 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	phil@nwl.cc,
	liuwb@xiaopeng.com
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix NULL deref in decode_seqof()
Date: Mon, 12 Oct 2026 17:20:44 +0800
Message-ID: <20261012092044.925598-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012090835.920932-1-zhugl3@xiaopeng.com>
References: <20261012090835.920932-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You are right, I could not find a reachable path either.

I re-checked all call sites that would invoke decode_seqof() without
a DECODE guard:

- decode_seq() root loop: every SEQOF entry with a NULL fields
  pointer sits outside the root window (index >= f->lb); the ones
  inside the root window carry STOP or OPEN.
- decode_seq() extension loop: entries without DECODE are skipped
  with bs->cur += len, decode_seqof() is never called for them.
- decode_choice() and the decode_seqof() item loop: no NULL-fields
  SEQOF entries among the options/items without STOP or OPEN either.

So f->fields can only be NULL when decode_seqof() is called from
outside the decoder, which is what my test module did.  The KASAN
report only demonstrates the in-function deref, not reachability
from a packet.

Please drop this patch.
