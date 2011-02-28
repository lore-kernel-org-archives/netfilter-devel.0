From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [patch] fix nla_policy_len to actually _iterate_ over the policy
Date: Mon, 28 Feb 2011 21:35:59 +0100
Message-ID: <20110228203559.GD8906@barkeeper1-xen.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: trivial@kernel.org, Holger Eitzenberger <holger@eitzenberger.org>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, stable@kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently nla_policy_len always returns n * NLA_HDRLEN:
It loops, but does not advance it's iterator.
NLA_UNSPEC == 0 does not contain a .len in any policy.

Trivially fixed by adding p++.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 5021cbc..ac09f22 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -148,7 +148,7 @@ nla_policy_len(const struct nla_policy *p, int n)
 {
 	int i, len = 0;
 
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < n; i++, p++) {
 		if (p->len)
 			len += nla_total_size(p->len);
 		else if (nla_attr_minlen[p->type])
