Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF942E7185;
	Thu,  3 Sep 2026 00:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396139; cv=none; b=s5A1t5b9dF0z6IgOMjn/VPni8KPJ63eHZvHwZDWA63/v9mUzaBtZQxAlLABFPJ3riq92wabUq7lVyWVtJtMaitlv2Vob+2EHt2eM8pxv/l9Iq50ixeAG9K5ryWqVpuf2fSNw5hBs3F1YkepaLSQ2ZiLw9n/o3Zv3EnIiQN78wzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396139; c=relaxed/simple;
	bh=SQyDg5b53VBSiX9ghzf0r40iQLnrJ3Hs8NKhpP5AJlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcCZXHCX87SZhD5EemOaALz/RUVO+wAxVb2KMrmjox78sLz9/jY7F6j9ZRSYMKnQjU2zapuGWYbeev5bg+nyotU53Hlwlx6EyX0yQqQf+6kpnzqOWFmdNS55rufTbgi/Em69CWsbCcYWfweNn8U29uqTODe7nh1z7XCQRmtHmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YudcnP9o; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YudcnP9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396132;
	bh=GLya4uiEw6iBjW9I+BvelF89lS2037O9hCQ63uvv7wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YudcnP9ouO5Uc5cCw5XQeQukuERyKHk/zpQHEslI1cCLxCmKdilh2ROUwtLpHwOyY
	 EtjAmBhynd8LPcrq5L4LYyLH8l0XHR1H0qcYUBlys2BBrw0uvon71tfIBPhcTOtYQa
	 rXLSbqDVkXETxvHOv7FetGSvbE0rZl96w9tAYjWgOGW4CJ4ARE3UyQgPfDrys9JiaB
	 p10hDXiQzs42S5Qava5d9qCW4q2Xl11grUEgvH30A687cB+wMd47E7DIEhBCsLAg+d
	 mrJQpKNZ3gScPFR/WqDMTN9762vV2NZxWj1Y72ciCDRpSUiDbq7Nxkbc0lKi0wsmQO
	 YPVq9yRG+khJQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 65A226079C;
	Thu,  3 Sep 2026 02:42:12 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 12/12] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Thu,  3 Sep 2026 02:41:49 +0200
Message-ID: <20260903004149.1037028-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ilya Maximets <i.maximets@ovn.org>

NLM_F_DUMP_FILTERED is only set on data elements in the conntrack dump.
But when everything is filtered out it is confusing for the user space,
since the flag is not reported anymore and it looks like the table was
empty, which may or may not be the case.

'answer_flags' were introduced precisely for this use case, and the
conntrack dump should set the flag in there in case the filtering was
applied.

This is important, for example, to be able to tell if the filters are
supported or not by the kernel without modifying the kernel state.

With the proper reporting of NLM_F_DUMP_FILTERED on NLMSG_DONE, an
application in user space can just try and dump with an arbitrary
filter without worrying that there could be no matching entry.  The
reported flag will signal that the filtering was applied and therefore
supported.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9b4e29557ec3..579ada063b1b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1077,6 +1077,8 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 
-- 
2.47.3

