From: Jann Horn <jannh@google.com>
Subject: [PATCH net] netfilter: nf_log: fix uninit read in nf_log_proc_dostring
Date: Wed, 20 Jun 2018 18:33:45 +0200
Message-ID: <20180620163345.212776-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jannh@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When proc_dostring() is called with a non-zero offset in strict mode, it
doesn't just write to the ->data buffer, it also reads. Make sure it
doesn't read uninitialized data.

Fixes: c6ac37d8d884 ("netfilter: nf_log: fix error on write NONE to [...]")
Signed-off-by: Jann Horn <jannh@google.com>
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
2.18.0.rc1.244.gcf134e6275-goog
