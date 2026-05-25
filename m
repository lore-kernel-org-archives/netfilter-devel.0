Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4642C33ADA2;
	Mon, 25 May 2026 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733784; cv=none; b=gZ45MPkUL6kP7cIBPnin+oAOmpD1AEzfJDo+xu1sIyhjeswRtGnY0MluEZs+Av5EcA1FuW8dG0F4bgFEDhPCGfItMo7+3Mt2bGsMHUd8ncQAe0bV2mcz6jb9g0IoygEPmFAvobr/zrR9Z5Z5J53Ma63uyH4/bPk22U5k9RVGu3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733784; c=relaxed/simple;
	bh=4XgYNrkURoZt44VhoFVYksPUjr+6j3qEDwc9+v/PBtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNko5b+RwzaxcZsaJjcD5B32azVF+30EAeYA5Z8lMg9Mb2BkS/Czv3ztP8EyKr9KrBA3QcPXWlmU6YYhnpum2caI/VjDxyky6/MHyH9dQeegO8nAiUe+wdtEOT8cwjtDMb8AVkyWWkpgGdwezydJLYFKo0rGAvGeIlaug6O62oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3FC3260595; Mon, 25 May 2026 20:29:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 03/11] netfilter: allow nfnetlink built-in only
Date: Mon, 25 May 2026 20:29:16 +0200
Message-ID: <20260525182924.28456-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525182924.28456-1-fw@strlen.de>
References: <20260525182924.28456-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Netfilter has its own netlink multiplexer, initially only a few
subsystem were using it, most notably conntrack, queue and log,
later in time nf_tables. These days it is the control plane of
preference.

Just remove modular support for this, allow it built-in only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig  | 2 +-
 net/netfilter/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f71ff98eb5d0..665f8008cc4b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,7 +22,7 @@ config NETFILTER_SKIP_EGRESS
 	def_bool NETFILTER_EGRESS && (NET_CLS_ACT || IFB)
 
 config NETFILTER_NETLINK
-	tristate
+	bool
 
 config NETFILTER_FAMILY_BRIDGE
 	bool
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f0751ca302c6..6bf74d488a29 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
+netfilter-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 
 nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o \
 		   nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o \
@@ -23,7 +24,6 @@ endif
 obj-$(CONFIG_NETFILTER) = netfilter.o
 obj-$(CONFIG_NETFILTER_BPF_LINK) += nf_bpf_link.o
 
-obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
-- 
2.53.0

