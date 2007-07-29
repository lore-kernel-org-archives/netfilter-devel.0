From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][netfilter] Avoid a possible NULL pointer deref in
	recent_seq_open()
Date: Sun, 29 Jul 2007 03:08:45 +0200
Message-ID: <200707290308.45464.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marc Boucher <marc@mbsi.ca>,
	Harald Welte <laforge@netfilter.org>, Jesper Juhl <jesper.juhl@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>, James Morris <jmorris@namei.org>,
	"David S. Miller" <davem@davemloft.net>, coreteam@netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

EHLO,

There is a small problem in
 net/ipv4/netfilter/ipt_recent.c::recent_seq_open().

If the call to seq_open() returns != 0 then the code calls 
kfree(st) but then on the very next line proceeds to 
dereference the pointer - not good.

Problem spotted by the Coverity checker.

Proposed patch to deal with it below.

Compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

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
 
