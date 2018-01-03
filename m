From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Subject: [tip:core/rcu] netlink: Remove smp_read_barrier_depends() from
 comment
Date: Wed, 3 Jan 2018 08:07:56 -0800
Message-ID: <tip-dfe1b4427835f995aed593d063e6fcdf78b00823@git.kernel.org>
Reply-To: pablo@netfilter.org, hpa@zytor.com, mingo@kernel.org,
          netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
          coreteam@netfilter.org, kadlec@blackhole.kfki.hu,
          paulmck@linux.vnet.ibm.com, tglx@linutronix.de, fw@strlen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, tglx@linutronix.de, coreteam@netfilter.org,
        kadlec@blackhole.kfki.hu, paulmck@linux.vnet.ibm.com,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mingo@kernel.org, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([65.50.211.136]:35235 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeACQNM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 11:13:12 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit-ID:  dfe1b4427835f995aed593d063e6fcdf78b00823
Gitweb:     https://git.kernel.org/tip/dfe1b4427835f995aed593d063e6fcdf78b00823
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 27 Nov 2017 09:26:06 -0800
Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Tue, 5 Dec 2017 11:57:54 -0800

netlink: Remove smp_read_barrier_depends() from comment

Now that smp_read_barrier_depends() has been de-emphasized, the less
said about it, the better.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 495ba4d..34551f8 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -67,8 +67,7 @@ static inline bool lockdep_nfnl_is_held(__u8 subsys_id)
  * @ss: The nfnetlink subsystem ID
  *
  * Return the value of the specified RCU-protected pointer, but omit
- * both the smp_read_barrier_depends() and the READ_ONCE(), because
- * caller holds the NFNL subsystem mutex.
+ * the READ_ONCE(), because caller holds the NFNL subsystem mutex.
  */
 #define nfnl_dereference(p, ss)					\
 	rcu_dereference_protected(p, lockdep_nfnl_is_held(ss))
