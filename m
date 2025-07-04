Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A8A2882AD
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 08:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751618275; cv=none; b=pwj2I+AJlPo2Z1EnO3pQbUhkNH9iTYn4P8ttsEJ9117DSO+DZ5PPOjkMUKhR/J6XlY+HD+HAEA1t2yQs6W2+IgcGdIwMzlO39e1/jqaygOhpoZFZqkdR7ANK2evYDfqfq0mB3Z9KKhZOV/0xtATSlO/ES2ADTdnT9eKOTbRZGPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751618275; c=relaxed/simple;
	bh=w2oE4pOh1akyKzIgJzSCOJHT+T23QNxc7gNrBnaFFh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XNziLeclQqC18xO2w/72WAnS4LU7hm5ooo2f2PUPo00hptWNILPn/XYVnYXvZWM9Ow3Wz4j/FYDXcC5gA6JU06yPIbPeySxTF9hO/R6Wihv5G+4KOVvbhQfe7ERprYtq/eT2+7Kb1MFlcyjLqrJXED6HdHcw74dXRRZZoANsmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JPJ/sWpp; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JPJ/sWpp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1751618185;
	bh=d95nx73kVtyU4RyV75KvYPcyXTaQmjFaV1z38NhfO0A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=JPJ/sWppdQuAt42JSvwi5mAkDItJ0kzLh+ZmRDstLITBOIkEK/OrXLj0cxTLJOrdo
	 a2X2Il2+kGvHWvU2kC3QUezQMskuXcDiSpYtNX5yKEb2fXgBd9wWvOcd49fmUD967C
	 iZX0xCjrQAlmWiqH2JcR5CniELT1UfBdw0xzyFRU=
X-QQ-mid: zesmtpip3t1751618170ta0779b56
X-QQ-Originating-IP: GVTrYKP7FbgWTpX/QoheMwYVtVk1rEfX3Iwi04kHrNQ=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 04 Jul 2025 16:36:07 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16565113001037801047
EX-QQ-RecipientCnt: 18
From: WangYuli <wangyuli@uniontech.com>
To: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com,
	wangyuli@deepin.org,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH RESEND] ipvs: ip_vs_conn_expire_now: Rename del_timer in comment
Date: Fri,  4 Jul 2025 16:35:53 +0800
Message-ID: <E5403EE80920424D+20250704083553.313144-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: No5QEyASzJyIIU9unor/X8y7LFMRjImnjvyLj57w8HzfX/O1CQufcMHm
	gOJ57MH4SVVc803vqvpAMZjWu07uj6WO2MxCSanLmLDuV15Dj+mZjeVfSb/Bds1n6dbj0D8
	8z3tSCSXwSg7BqrpTEwc1uR6WHKORbwsXZAvJOeXTcJ5BcW4pUyRQ1cBrga+USUCW+xnDJR
	RmEQl+uOxCdYRr4y6KTQzMiAZOtX5Q8PeKi3q47V2gMZIhUkF2QJhYEXpwwilcslAIkWbXd
	4P36sKrXazzz9JKmuPBrHa5ad0oRaGWr4hYMEjTYYurviBGKLveLjUMToiQNzRPAFq+12I/
	f4X3A85fNT8RZOWG4TMW16/NbgzgYWdm+1JC24wTb9s9kayZ43KGD3ce9x4OLonc0m/+cp0
	l53aNKGH2tcS2AMdqPO7kx3SKf0pq9ppPMbyeDxw+WfArVFe9rFkKTfRPfWbZQ091qn2+Pw
	Wrn1Jc0sahqGm2mgtA/xKclaLMdarDwN0+UCyOI9RbEs9JhfusQvR7YNZv9WwvaUDEwBIqp
	m9cjksLdYGFqUgY4whT0lP9NvcdOM1nhUJswA2Zu8k8eNtYNAUDoPgOPdo5E+TIajwaQiqD
	8eLG/PNoi7ge+ZLZUtiCLQJc11j6sqiLRfi8GkKtKlMTKYg7Hm4GT/q5gsvIuiZj3O9Oo/j
	Jtuy+S5B5OZIb2lVljPbRdf/8SwPg0UHoujlU/DE9oaY7G1P4O5SZ5sJhCfsivFs34gtfRJ
	2MOykf/SwfUdO/gTTmkT1hbnKwM2rfH/l6cMU7xWhu2LSBoEoN7Gqom8xMcu7wuVQxMWlbP
	c6cprHwdOtaxEjPyQBWQbyp6N9fExV+Nz8kNx1d5CWY5UornZpM8m3a5mEO2gsYbQGkJ1pM
	unx6UL8n6Kqrf2+1HsgW/F5D0iXsvN7Xthi2p9dRPqgKzc8nmxreJ8pVop+7c34NZQHqPis
	iaLAXF421Z9inVbGLmk0UAPVRjGy/Sa+jkeQHeJpPQ8LGMqcfrXb/6Iz8/9qvdZCn0KOC75
	wgltxbB/9GWUQKSoclIsgBKYLEpc/tHp4gElTRjwwIOx2uHu6lrC5poe/Am1HL+/7ZFsis0
	8qVNbq3s7yZ
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer to timer_delete, but did not modify the comment for
ip_vs_conn_expire_now(). Now fix it.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 44b2ad695c15..965f3c8e5089 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -926,7 +926,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp)
 {
 	/* Using mod_timer_pending will ensure the timer is not
-	 * modified after the final del_timer in ip_vs_conn_expire.
+	 * modified after the final timer_delete in ip_vs_conn_expire.
 	 */
 	if (timer_pending(&cp->timer) &&
 	    time_after(cp->timer.expires, jiffies))
-- 
2.50.0

