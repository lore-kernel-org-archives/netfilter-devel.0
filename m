From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Wed, 07 Sep 2005 11:57:14 +0200
Message-ID: <m28xy98akl.fsf@cerbere.dyndns.info>
References: <431DD813.8010309@trash.net> <431DDB7C.3010503@trash.net>
	<m2slwh617b.fsf@cerbere.dyndns.info>
	<20050906.195649.54560179.davem@davemloft.net>
	<431E5800.9080406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <431E5800.9080406@trash.net> (Patrick McHardy's message of "Wed,
	07 Sep 2005 05:01:20 +0200")
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

--=-=-=

Patrick McHardy <kaber@trash.net> writes:

>>>[NETFILTER] Return NF_DROP if expectation failed for Netbios conntrack
>>>Fix the returned value when it's not possible to allocate expectation
>>>or if ip_conntrack_expect_related() failed.
>>>Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
>> Patrick, I've applied this, I hope you don't mind :)
>
> Actually it was deliberate, I don't see a reason why the packet
> should be dropped, its best effort.
All conntracks are dropping packets, in that way.
netbios_ns should do the same, or other conntracks should be patched.

> Besides that the patch
> creates a reference leak, we always need to call
> ip_conntrack_expect_put. Please revert the patch. Thanks.
You are right, i'm proposing this patch, which don't introduce the
reference leak.

regards, 
Samir Bellabes


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=ip_ct_netbios_drop.patch

tree 04acb82014fc0e82fa4c77dae5e2281e90b366c8
parent 48bc41a49c4f3aa760dff84e7f71437f5ed520fe
author Samir Bellabes <sbellabes@mandriva.com> 1126085733 +0200
committer Samir Bellabes <sbellabes@mandriva.com> 1126085733 +0200

[NETFILTER] Return NF_DROP if expectation failed for Netbios conntrack

Fix the returned value when it's not possible to allocate expectation
or if ip_conntrack_expect_related() failed.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
------------------------------------------------------------------------------

 ip_conntrack_netbios_ns.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

------------------------------------------------------------------------------

diff --git a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
--- a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
+++ b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
@@ -48,6 +48,7 @@ static int help(struct sk_buff **pskb,
 	struct rtable *rt = (struct rtable *)(*pskb)->dst;
 	struct in_device *in_dev;
 	u_int32_t mask = 0;
+	int ret = NF_ACCEPT;
 
 	/* we're only interested in locally generated packets */
 	if ((*pskb)->sk == NULL)
@@ -76,8 +77,10 @@ static int help(struct sk_buff **pskb,
 	BUG_ON(uh == NULL);
 
 	exp = ip_conntrack_expect_alloc(ct);
-	if (exp == NULL)
+	if (exp == NULL) {
+		ret = NF_DROP;
 		goto out;
+	}
 	memset(&exp->tuple, 0, sizeof(exp->tuple));
 	exp->tuple.src.ip         = iph->daddr & mask;
 	exp->tuple.dst.ip         = iph->saddr;
@@ -93,12 +96,13 @@ static int help(struct sk_buff **pskb,
 	exp->expectfn             = NULL;
 	exp->flags                = IP_CT_EXPECT_PERMANENT;
 
-	ip_conntrack_expect_related(exp);
+	if (ip_conntrack_expect_related(exp) !=0)
+		ret = NF_DROP;
 	ip_conntrack_expect_put(exp);
 
 	ip_ct_refresh_acct(ct, ctinfo, NULL, timeout * HZ);
 out:
-	return NF_ACCEPT;
+	return ret;
 }
 
 static struct ip_conntrack_helper helper = {

--=-=-=--
