From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] nf_log: avoid oops in (un)bind with invalid nfproto values
Date: Mon, 28 Feb 2011 21:06:10 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102282102400.16012@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eric@inl.fr,
	"David S. Miller" <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52177 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1B1UGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:06:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 41ac51eeda58a85b8a06d748cce7035cc77deebd
(kaber/nf-next-2.6 @ 2.6.38-rc1+):

  ipvs: make "no destination available" message more informative (2011-02-16 14:53:33 +0900)

are available in the git repository at:
  git://dev.medozas.de/linux master

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

 net/netfilter/nf_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


---
parent 41ac51eeda58a85b8a06d748cce7035cc77deebd (v2.6.38-rc1-194-g41ac51e)
commit 653393692ac5b0baabf707bb94d20e5c661a27c0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Feb 28 20:42:25 2011 +0100

netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Like many other places, we have to check that the array index is
within allowed limits, or otherwise, a kernel oops and other nastiness
can ensue when we access memory beyond the end of the array.

[ 5954.115381] BUG: unable to handle kernel paging request at 0000004000000000
[ 5954.120014] IP:  __find_logger+0x6f/0xa0
[ 5954.123979]  nf_log_bind_pf+0x2b/0x70
[ 5954.123979]  nfulnl_recv_config+0xc0/0x4a0 [nfnetlink_log]
[ 5954.123979]  nfnetlink_rcv_msg+0x12c/0x1b0 [nfnetlink]
...

The problem goes back to v2.6.30-rc1~137^2~134^2~31 where nf_log_bind
was decoupled from nf_log_register.

Reported-by: Miguel Di Ciurcio Filho <miguel.filho@gmail.com>,
  via irc.freenode.net/#netfilter
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/nf_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 20c775c..b6c4697 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -85,6 +85,8 @@ EXPORT_SYMBOL(nf_log_unregister);
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	if (__find_logger(pf, logger->name) == NULL) {
 		mutex_unlock(&nf_log_mutex);
@@ -98,6 +100,8 @@ EXPORT_SYMBOL(nf_log_bind_pf);
 
 void nf_log_unbind_pf(u_int8_t pf)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
-- 
# Created with git-export-patch

