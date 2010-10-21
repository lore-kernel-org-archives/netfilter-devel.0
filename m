From: kaber@trash.net
Subject: [PATCH 15/72] netfilter: nf_conntrack_sip: Allow ct_sip_get_header() to be called with a null ct argument
Date: Thu, 21 Oct 2010 17:19:02 +0200
Message-ID: <1287674399-31455-16-git-send-email-kaber@trash.net>
References: <1287674399-31455-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1287674399-31455-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Simon Horman <horms@verge.net.au>

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/nf_conntrack_sip.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 53d8922..2fd1ea2 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -152,6 +152,9 @@ static int parse_addr(const struct nf_conn *ct, const char *cp,
 	const char *end;
 	int ret = 0;
 
+	if (!ct)
+		return 0;
+
 	memset(addr, 0, sizeof(*addr));
 	switch (nf_ct_l3num(ct)) {
 	case AF_INET:
-- 
1.7.1

