From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_nat_snmp_basic: add missing length checks in ASN.1 cbs
Date: Mon, 11 Feb 2019 17:53:18 +0100
Message-ID: <20190211165319.17965-2-pablo@netfilter.org>
References: <20190211165319.17965-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211165319.17965-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jann Horn <jannh@google.com>

The generic ASN.1 decoder infrastructure doesn't guarantee that callbacks
will get as much data as they expect; callbacks have to check the `datalen`
parameter before looking at `data`. Make sure that snmp_version() and
snmp_helper() don't read/write beyond the end of the packet data.

(Also move the assignment to `pdata` down below the check to make it clear
that it isn't necessarily a pointer we can use before the `datalen` check.)

Fixes: cc2d58634e0f ("netfilter: nf_nat_snmp_basic: use asn1 decoder library")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index a0aa13bcabda..0a8a60c1bf9a 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -105,6 +105,8 @@ static void fast_csum(struct snmp_ctx *ctx, unsigned char offset)
 int snmp_version(void *context, size_t hdrlen, unsigned char tag,
 		 const void *data, size_t datalen)
 {
+	if (datalen != 1)
+		return -EINVAL;
 	if (*(unsigned char *)data > 1)
 		return -ENOTSUPP;
 	return 1;
@@ -114,8 +116,11 @@ int snmp_helper(void *context, size_t hdrlen, unsigned char tag,
 		const void *data, size_t datalen)
 {
 	struct snmp_ctx *ctx = (struct snmp_ctx *)context;
-	__be32 *pdata = (__be32 *)data;
+	__be32 *pdata;
 
+	if (datalen != 4)
+		return -EINVAL;
+	pdata = (__be32 *)data;
 	if (*pdata == ctx->from) {
 		pr_debug("%s: %pI4 to %pI4\n", __func__,
 			 (void *)&ctx->from, (void *)&ctx->to);
-- 
2.11.0
