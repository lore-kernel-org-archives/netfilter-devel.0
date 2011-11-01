From: pablo@netfilter.org
Subject: [PATCH 11/14] ipvs: Fix compilation error in ip_vs.h for ip_vs_confirm_conntrack function.
Date: Tue,  1 Nov 2011 10:11:33 +0100
Message-ID: <1320138696-28048-12-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net,
	Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
	Simon Horman <horms@verge.net.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJMJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:09 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

This is to address the following error during the compilation:

  In file included from kernel/sysctl_binary.c:6:
  include/net/ip_vs.h:1406: error: expected identifier or =E2=80=98(=E2=
=80=99 before =E2=80=98{=E2=80=99 token
  make[1]: *** [kernel/sysctl_binary.o] Error 1
  make[1]: *** Waiting for unfinished jobs....

That manifests itself when CONFIG_IP_VS_NFCT is undefined in .config fi=
le.

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index a6b8b47..05b08c9 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1396,7 +1396,7 @@ static inline void ip_vs_update_conntrack(struct =
sk_buff *skb,
 {
 }
=20
-static inline int ip_vs_confirm_conntrack(struct sk_buff *skb);
+static inline int ip_vs_confirm_conntrack(struct sk_buff *skb)
 {
 	return NF_ACCEPT;
 }
--=20
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
