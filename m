From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6] netfilter: nf_log: fix uninit read in nf_log_proc_dostring
Date: Wed, 27 Jun 2018 17:22:21 +0200
Message-ID: <20180627152223.3633-5-pablo@netfilter.org>
References: <20180627152223.3633-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627152223.3633-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jann Horn <jannh@google.com>

When proc_dostring() is called with a non-zero offset in strict mode, it
doesn't just write to the ->data buffer, it also reads. Make sure it
doesn't read uninitialized data.

Fixes: c6ac37d8d884 ("netfilter: nf_log: fix error on write NONE to [...]")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 426457047578..2c47f9ec3511 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -424,6 +424,10 @@ static int nf_log_proc_dostring(struct ctl_table *table, int write,
 	if (write) {
 		struct ctl_table tmp = *table;
 
+		/* proc_dostring() can append to existing strings, so we need to
+		 * initialize it as an empty string.
+		 */
+		buf[0] = '\0';
 		tmp.data = buf;
 		r = proc_dostring(&tmp, write, buffer, lenp, ppos);
 		if (r)
-- 
2.11.0
