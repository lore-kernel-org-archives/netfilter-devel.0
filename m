From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH 1/2] Revert "netfilter: nf_ct_helper: disable automatic helper
 assignment"
Date: Tue, 24 Jan 2017 01:06:24 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701240058110.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, info@jablonka.cz,
        Linus Torvalds <torvalds@linux-foundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

This reverts commit 3bb398d925ec73e42b778cf823c8f4aecae359ea. It breaks
existing firewall configurations.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
 net/netfilter/nf_conntrack_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7341adf7059d..6255f566cd06 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -38,10 +38,10 @@ unsigned int nf_ct_helper_hsize __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_helper_hsize);
 static unsigned int nf_ct_helper_count __read_mostly;
 
-static bool nf_ct_auto_assign_helper __read_mostly = false;
+static bool nf_ct_auto_assign_helper __read_mostly = true;
 module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
 MODULE_PARM_DESC(nf_conntrack_helper,
-		 "Enable automatic conntrack helper assignment (default 0)");
+		 "Enable automatic conntrack helper assignment (default 1)");
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table helper_sysctl_table[] = {
-- 
2.11.0
