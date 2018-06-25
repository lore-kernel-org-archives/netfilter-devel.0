From: Jann Horn <jannh@google.com>
Subject: [PATCH net] netfilter: nf_log: don't hold nf_log_mutex during user access
Date: Mon, 25 Jun 2018 17:22:00 +0200
Message-ID: <20180625152200.200145-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jannh@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The old code would indefinitely block other users of nf_log_mutex if
a userspace access in proc_dostring() blocked e.g. due to a userfaultfd
region. Fix it by moving proc_dostring() out of the locked region.

This is a followup to commit 266d07cb1c9a ("netfilter: nf_log: fix
sleeping function called from invalid context"), which changed this code
from using rcu_read_lock() to taking nf_log_mutex.

Fixes: 266d07cb1c9a ("netfilter: nf_log: fix sleeping function calle[...]")
Signed-off-by: Jann Horn <jannh@google.com>
---
 net/netfilter/nf_log.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 426457047578..95b92954b896 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -442,14 +442,17 @@ static int nf_log_proc_dostring(struct ctl_table *table, int write,
 		rcu_assign_pointer(net->nf.nf_loggers[tindex], logger);
 		mutex_unlock(&nf_log_mutex);
 	} else {
+		struct ctl_table tmp = *table;
+
+		tmp.data = buf;
 		mutex_lock(&nf_log_mutex);
 		logger = nft_log_dereference(net->nf.nf_loggers[tindex]);
 		if (!logger)
-			table->data = "NONE";
+			strlcpy(buf, "NONE", sizeof(buf));
 		else
-			table->data = logger->name;
-		r = proc_dostring(table, write, buffer, lenp, ppos);
+			strlcpy(buf, logger->name, sizeof(buf));
 		mutex_unlock(&nf_log_mutex);
+		r = proc_dostring(&tmp, write, buffer, lenp, ppos);
 	}
 
 	return r;
-- 
2.18.0.rc2.346.g013aa6912e-goog
