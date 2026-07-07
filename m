Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F3D3F870C;
	Tue,  7 Jul 2026 11:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783422045; cv=none; b=sR2+x8F1IGTAGO8LlQNemf0nOc49s+7ctEtPbTr3nTeAcqBX3spUo12cJ0L8+yHpUi1Az2DJmMY3vlo+P98bWyxZxRHLbjU5YKS58HDhWkH7ebJ0A/tOu5Wt8GdEAti/W/YIJ4XuhGOgRm2uKe3GcNFnz03P3p7Gcfrt9Dx/0X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783422045; c=relaxed/simple;
	bh=xfAix1SI/5H4odFpah60tVEkhbcttrfLxGmJA+3KN7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l31HJlprJpBxUNIZyWDgtADhumrunhpvCQw4iFyS4sC97gOQRAy02gAp1cHJSgL+Y2fcCTCccO9T7Xm6e98O5F1h2q10GcdLxGMR+Tc8iq3FFuXZqpKXdYNQ5W/bM68FxkvyBXfvBHH22a649w0mP1o63AbrNQYSiMP745zaukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=E1jvZzaW; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="E1jvZzaW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Transfer-Encoding; bh=Wb1ul
	XqaN6LhsrQOCbA/VuSQqCeRVoSv6NswqkkKJ8w=; b=E1jvZzaWo3hUgMdd0OHlg
	CsCEz2tugJDvIaW4EiZ/SUgjsLh75MKd9wBJy4POqO+9HqAexd/KRipE4B8PKftL
	qwRWKBksOdraVTP9oT0OxpaWeqBkjD1rYD/oYGvJeCPjW16zVbMf3w0rEhhh1h7E
	eMRZc36m2Go404eE7lbP90=
Received: from localhost.localdomain (unknown [101.5.13.242])
	by web2 (Coremail) with SMTP id yQQGZQAXw5VB3ExqboPLAg--.29993S2;
	Tue, 07 Jul 2026 19:00:17 +0800 (CST)
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>
Subject: [PATCH nf] netfilter: ecache: fix inverted time_after() check
Date: Tue,  7 Jul 2026 19:00:14 +0800
Message-ID: <20260707110015.99988-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQAXw5VB3ExqboPLAg--.29993S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZry3tFWkur18uF15XFWkZwb_yoW5Wr17pF
	Z5Zr93tFWxCrWYkanYvw1UAFn8ua93u34xua45GF95CanxGrs8JFs5KrW2qF98ZrWvkF4I
	yF4jyr1jkFs8XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9v1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r4r
	Kr1UJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc
	8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCY02Av
	z4vE14v_Gw4l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8Ww4UJr1UMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1rb15UUUUU==
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAgABAWpMxHwgogAAse

ecache_work_evict_list() redelivers DESTROY events for conntracks that
were moved to the per-netns dying_list after event delivery failed.  It
sets a 10ms deadline:

    stop = jiffies + ECACHE_MAX_JIFFIES

but then tests:

    time_after(stop, jiffies)

This condition is true while the deadline is still in the future, so the
worker returns STATE_RESTART after the first successful redelivery in the
usual case.  ecache_work() maps STATE_RESTART to delay 0, which turns the
redelivery path into one dying conntrack per workqueue dispatch and makes
the sent > 16 batching/cond_resched() path effectively unreachable.

A conntrack netlink listener whose receive queue is congested can make
DESTROY event delivery fail with -ENOBUFS.  With sustained conntrack
churn, entries then accumulate on the dying_list and are only drained at
the degraded one-entry-per-dispatch rate once delivery succeeds again,
wasting CPU on back-to-back workqueue reschedules and prolonging
conntrack memory/resource pressure.

In a KASAN QEMU test with CONFIG_NF_CONNTRACK_EVENTS=y and
nf_conntrack.enable_hooks=1, a congested DESTROY listener caused 8192
nf_ct_delete() calls to return false and move entries to the dying_list.
After closing the listener, the unfixed kernel needed 7670 ecache_work()
entries to destroy 7669 conntracks.  With this change, the same 8192
entries were destroyed by 2 ecache_work() entries.

Swap the comparison so the worker restarts only after the deadline has
expired.

Fixes: 2ed3bf188b33 ("netfilter: ecache: use dedicated list for event redelivery")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
---
 net/netfilter/nf_conntrack_ecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 9df159448b89..cc8d8e85169f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -77,7 +77,7 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 		hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode, &evicted_list);
 
-		if (time_after(stop, jiffies)) {
+		if (time_after(jiffies, stop)) {
 			ret = STATE_RESTART;
 			break;
 		}
-- 
2.47.3

