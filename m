From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 3/5] procfs: fix double drop_sysctl_table()
Date: Wed,  5 Dec 2018 20:56:28 +0800
Message-ID: <1544014590-14429-3-git-send-email-laoar.shao@gmail.com>
References: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, adobriyan@gmail.com, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All of the callers will execute drop_sysctl_table() whatever the callee
insert_header() successes or fails.
So we can't execute drop_sysctl_table() in insert_header().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 fs/proc/proc_sysctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 89921a0..9aeb750 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -241,7 +241,6 @@ static int insert_header(struct ctl_dir *dir, struct ctl_table_header *header)
 	if (header->ctl_table == sysctl_mount_point)
 		clear_empty_dir(dir);
 	header->parent = NULL;
-	drop_sysctl_table(&dir->header);
 	return err;
 }
 
-- 
1.8.3.1
