From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] ipt_osf: module revision fixup
Date: Fri, 7 Jan 2005 14:22:00 +0300
Message-ID: <20050107142200.294ac6bd@zanzibar.2ka.mipt.ru>
References: <20050107022459.GC26992@ti64.telemetry-investments.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20050107022459.GC26992@ti64.telemetry-investments.com>
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

> Use C99 initializers to allow for new match revision field.

I've applied your patch to my tree, netfilter team, please
apply it to netfilter CVS, thank you.

Signed-off-by: Bill Rugolsky <brugolsky@telemetry-investments.com>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c.revision	2004-11-24 10:19:50.000000000 -0500
+++ patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c	2005-01-06 20:37:36.000000000 -0500
@@ -83,14 +83,11 @@
 static unsigned long seq, ipt_osf_groups = 1;
 static struct sock *nts;
 
-static struct ipt_match osf_match = 
-{ 
-	{ NULL, NULL }, 
-	"osf", 
-	&match, 
-	&checkentry, 
-	NULL, 
-	THIS_MODULE 
+static struct ipt_match osf_match = { 
+	.name = "osf", 
+	.match = &match, 
+	.checkentry = &checkentry, 
+	.me = THIS_MODULE 
 };
 
 static void ipt_osf_nlsend(struct osf_finger *f, const struct sk_buff *sk)


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
