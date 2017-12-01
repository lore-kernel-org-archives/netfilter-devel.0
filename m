From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/21] netlink: Remove smp_read_barrier_depends() from comment
Date: Fri,  1 Dec 2017 11:51:14 -0800
Message-ID: <1512157876-24665-19-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
Cc: mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752177AbdLATv1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 14:51:27 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB1JnQEX115621
        for <netfilter-devel@vger.kernel.org>; Fri, 1 Dec 2017 14:51:26 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ekd7291se-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Dec 2017 14:51:26 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 1 Dec 2017 14:51:24 -0500
In-Reply-To: <20171201195053.GA23494@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
index 495ba4dd9da5..34551f8aaf9d 100644
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
-- 
2.5.2

