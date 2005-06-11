From: Phil Oester <kernel@linuxace.com>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Sat, 11 Jun 2005 10:07:39 -0700
Message-ID: <20050611170739.GA5018@linuxace.com>
References: <42AB1577.5040006@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42AB1577.5040006@trash.net>
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


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 11, 2005 at 06:46:47PM +0200, Patrick McHardy wrote:
> I've applied everything on the list I could find, if I missed
> anything please resend now. Thanks.

Here's one

Since expectation timeouts were made compulsory [1], there is no need to
check for them in ip_conntrack_expect_insert.

Phil

[1] https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018143.html


Signed-off-by: Phil Oester <kernel@linuxace.com>



--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-exptimeout

diff -ruN linux-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-new/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-02 02:37:30.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ip_conntrack_core.c	2005-05-19 10:18:04.041146160 -0400
@@ -760,15 +760,11 @@
 	exp->master->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 
-	if (exp->master->helper->timeout) {
-		init_timer(&exp->timeout);
-		exp->timeout.data = (unsigned long)exp;
-		exp->timeout.function = expectation_timed_out;
-		exp->timeout.expires
-			= jiffies + exp->master->helper->timeout * HZ;
-		add_timer(&exp->timeout);
-	} else
-		exp->timeout.function = NULL;
+	init_timer(&exp->timeout);
+	exp->timeout.data = (unsigned long)exp;
+	exp->timeout.function = expectation_timed_out;
+	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
+	add_timer(&exp->timeout);
 
 	CONNTRACK_STAT_INC(expect_create);
 }

--W/nzBZO5zC0uMSeA--
