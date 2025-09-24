Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C52046BA;
	Wed, 24 Sep 2025 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722836; cv=none; b=JLqqg4Z4YFm83lrZnmEVTvIZNjCvrM1zmSFcULZFPwiu7bGc5pGrakgfWSRfNao2Dhewf2Vj7ynXfp+ezX967iGb/IGaV3oYjnMgzfkdauKXSG6yVjHeMQGojhvS0e0hsCgj5p9KbQbyPmiKiGj50OGd61nEzQb3S38IGlz/uvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722836; c=relaxed/simple;
	bh=sIz7sIpZOveXoSl+bxVlPZGRfEJdCpEzinizqj86JUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/r0ihJ6AcJIXMzMYNV+b5+grF470jcOctRG/HWwGYG033T1epsOaitLTYdEJb9tyq6vMGEH0HwCifQvGiW/wcVHG9HP7WbO+MblHoAQ7OKLOlEa59dPovyXgbyh2Nxq+N5a+a/8OlGgnIf8qDPQArYV/T7ctPi83ltTQsfU1VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ED7D1605F7; Wed, 24 Sep 2025 16:07:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/6] netfilter: nfnetlink: reset nlh pointer during batch replay
Date: Wed, 24 Sep 2025 16:06:50 +0200
Message-ID: <20250924140654.10210-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

During a batch replay, the nlh pointer is not reset until the parsing of
the commands. Since commit bf2ac490d28c ("netfilter: nfnetlink: Handle
ACK flags for batch messages") that is problematic as the condition to
add an ACK for batch begin will evaluate to true even if NLM_F_ACK
wasn't used for batch begin message.

If there is an error during the command processing, netlink is sending
an ACK despite that. This misleads userspace tools which think that the
return code was 0. Reset the nlh pointer to the original one when a
replay is triggered.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e598a2a252b0..811d02b4c4f7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -376,6 +376,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	struct netlink_ext_ack extack;
+	struct nlmsghdr *onlh = nlh;
 	LIST_HEAD(err_list);
 	u32 status;
 	int err;
@@ -386,6 +387,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	status = 0;
 replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
+	nlh = onlh;
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
 
-- 
2.49.1

