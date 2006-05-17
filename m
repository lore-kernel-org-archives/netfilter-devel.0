From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: Fix memory leak in ipt_recent
Date: Wed, 17 May 2006 09:40:49 +0200
Message-ID: <446AD381.8090007@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090406010601000902050200"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------090406010601000902050200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two small netfilter fixes for 2.6.17.
Please apply, thanks.


 net/bridge/netfilter/ebt_log.c  |    2 +-
 net/ipv4/netfilter/ipt_LOG.c    |    2 +-
 net/ipv4/netfilter/ipt_recent.c |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Jesper Juhl:
      [NETFILTER]: Fix memory leak in ipt_recent

Philip Craig:
      [NETFILTER]: fix format specifier for netfilter log targets

--------------090406010601000902050200
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Fix memory leak in ipt_recent

The Coverity checker spotted that we may leak 'hold' in
net/ipv4/netfilter/ipt_recent.c::checkentry() when the following
is true:
  if (!curr_table->status_proc) {
    ...
    if(!curr_table) {
    ...
      return 0;  <-- here we leak.
Simply moving an existing vfree(hold); up a bit avoids the possible leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6bf69b5660fafbbb8bfeebcfd53efee8ab419ff1
tree c7ac73a113253a66fe54ed1c3689666683a07374
parent 0c056c50a6218e0e577817c16ba8851af593d742
author Jesper Juhl <jesper.juhl@gmail.com> Wed, 17 May 2006 09:36:23 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 17 May 2006 09:36:23 +0200

 net/ipv4/netfilter/ipt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 1438432..b847ee4 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -821,6 +821,7 @@ #ifdef CONFIG_PROC_FS
 	/* Create our proc 'status' entry. */
 	curr_table->status_proc = create_proc_entry(curr_table->name, ip_list_perms, proc_net_ipt_recent);
 	if (!curr_table->status_proc) {
+		vfree(hold);
 		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for /proc entry.\n");
 		/* Destroy the created table */
 		spin_lock_bh(&recent_lock);
@@ -845,7 +846,6 @@ #endif
 		spin_unlock_bh(&recent_lock);
 		vfree(curr_table->time_info);
 		vfree(curr_table->hash_table);
-		vfree(hold);
 		vfree(curr_table->table);
 		vfree(curr_table);
 		return 0;

--------------090406010601000902050200--
