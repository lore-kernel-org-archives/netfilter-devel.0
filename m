From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: ipt_recent: avoid a possible NULL pointer deref
	in recent_seq_open()
Date: Mon,  6 Aug 2007 15:29:04 +0200 (MEST)
Message-ID: <20070806132846.17202.40768.sendpatchset@localhost.localdomain>
References: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ipt_recent: avoid a possible NULL pointer deref in recent_seq_open()

If the call to seq_open() returns != 0 then the code calls 
kfree(st) but then on the very next line proceeds to 
dereference the pointer - not good.

Problem spotted by the Coverity checker.

Proposed patch to deal with it below.

Compile tested only.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ab3b4927a235c95684cb571b90a04cf6ea1ef7f9
tree acdb734e5cd9dfc4d471ccd85c84cb80100ed45d
parent b880c0879b449ace25e8454656fb0646b32634e6
author Jesper Juhl <jesper.juhl@gmail.com> Mon, 06 Aug 2007 14:09:52 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 06 Aug 2007 14:09:52 +0200

 net/ipv4/netfilter/ipt_recent.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 3218043..6d0c0f7 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -387,12 +387,17 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 	st = kzalloc(sizeof(*st), GFP_KERNEL);
 	if (st == NULL)
 		return -ENOMEM;
+
 	ret = seq_open(file, &recent_seq_ops);
-	if (ret)
+	if (ret) {
 		kfree(st);
+		goto out;
+	}
+
 	st->table    = pde->data;
 	seq          = file->private_data;
 	seq->private = st;
+out:
 	return ret;
 }
 
