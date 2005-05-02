From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: LOG and DROP some specified packets in the same iptables rule
Date: Mon, 2 May 2005 13:52:38 +0800
Message-ID: <000b01c54edb$28bdd120$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello,

If I would like to log and drop some specified packets in the same
iptables rule. 
Can I simply do the change in ipt_LOG.c like the following.

--- ipt_LOG.c.old       2005-05-02 12:58:18.000000000 +0800
+++ ipt_LOG.c   2005-05-02 12:58:45.000000000 +0800
@@ -346,7 +346,7 @@ ipt_log_target(struct sk_buff **pskb,
        printk("\n");
        spin_unlock_bh(&log_lock);

-       return IPT_CONTINUE;
+       return NF_DROP;
 }

 static int ipt_log_checkentry(const char *tablename,


Will this change cause any side effect that I don't know?
Thanks in advance.

Vincent
