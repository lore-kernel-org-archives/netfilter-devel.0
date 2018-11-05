From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/14] netfilter: xt_IDLETIMER: add sysfs filename checking routine
Date: Tue,  6 Nov 2018 00:28:27 +0100
Message-ID: <20181105232832.21896-10-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

When IDLETIMER rule is added, sysfs file is created under
/sys/class/xt_idletimer/timers/
But some label name shouldn't be used.
".", "..", "power", "uevent", "subsystem", etc...
So that sysfs filename checking routine is needed.

test commands:
   %iptables -I INPUT -j IDLETIMER --timeout 1 --label "power"

splat looks like:
[95765.423132] sysfs: cannot create duplicate filename '/devices/virtual/xt_idletimer/timers/power'
[95765.433418] CPU: 0 PID: 8446 Comm: iptables Not tainted 4.19.0-rc6+ #20
[95765.449755] Call Trace:
[95765.449755]  dump_stack+0xc9/0x16b
[95765.449755]  ? show_regs_print_info+0x5/0x5
[95765.449755]  sysfs_warn_dup+0x74/0x90
[95765.449755]  sysfs_add_file_mode_ns+0x352/0x500
[95765.449755]  sysfs_create_file_ns+0x179/0x270
[95765.449755]  ? sysfs_add_file_mode_ns+0x500/0x500
[95765.449755]  ? idletimer_tg_checkentry+0x3e5/0xb1b [xt_IDLETIMER]
[95765.449755]  ? rcu_read_lock_sched_held+0x114/0x130
[95765.449755]  ? __kmalloc_track_caller+0x211/0x2b0
[95765.449755]  ? memcpy+0x34/0x50
[95765.449755]  idletimer_tg_checkentry+0x4e2/0xb1b [xt_IDLETIMER]
[ ... ]

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index c6acfc2d9c84..eb4cbd244c3d 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -114,6 +114,22 @@ static void idletimer_tg_expired(struct timer_list *t)
 	schedule_work(&timer->work);
 }
 
+static int idletimer_check_sysfs_name(const char *name, unsigned int size)
+{
+	int ret;
+
+	ret = xt_check_proc_name(name, size);
+	if (ret < 0)
+		return ret;
+
+	if (!strcmp(name, "power") ||
+	    !strcmp(name, "subsystem") ||
+	    !strcmp(name, "uevent"))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int idletimer_tg_create(struct idletimer_tg_info *info)
 {
 	int ret;
@@ -124,6 +140,10 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 		goto out;
 	}
 
+	ret = idletimer_check_sysfs_name(info->label, sizeof(info->label));
+	if (ret < 0)
+		goto out_free_timer;
+
 	sysfs_attr_init(&info->timer->attr.attr);
 	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
 	if (!info->timer->attr.attr.name) {
-- 
2.11.0
