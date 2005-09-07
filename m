From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Wed, 07 Sep 2005 04:50:16 +0200
Message-ID: <m2slwh617b.fsf@cerbere.dyndns.info>
References: <431DD813.8010309@trash.net> <431DDB7C.3010503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <431DDB7C.3010503@trash.net> (Patrick McHardy's message of "Tue,
	06 Sep 2005 20:10:04 +0200")
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

> [NETFILTER]: Add NetBIOS name service helper
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Hi,
this attached patch fix the return valued when creating expectation
failed.
Please apply.

regards, 
Samir Bellabes


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=ip_ct_netbios_drop.patch

tree b731304f287168ee36e45517dffdf27ea9dfe47c
parent 48bc41a49c4f3aa760dff84e7f71437f5ed520fe
author Samir Bellabes <sbellabes@mandriva.com> 1126061246 +0200
committer Samir Bellabes <sbellabes@mandriva.com> 1126061246 +0200

[NETFILTER] Return NF_DROP if expectation failed for Netbios conntrack

Fix the returned value when it's not possible to allocate expectation
or if ip_conntrack_expect_related() failed.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
------------------------------------------------------------------------------

 ip_conntrack_netbios_ns.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

------------------------------------------------------------------------------

diff --git a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
--- a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
+++ b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
@@ -77,7 +77,7 @@ static int help(struct sk_buff **pskb,
 
 	exp = ip_conntrack_expect_alloc(ct);
 	if (exp == NULL)
-		goto out;
+		return NF_DROP;
 	memset(&exp->tuple, 0, sizeof(exp->tuple));
 	exp->tuple.src.ip         = iph->daddr & mask;
 	exp->tuple.dst.ip         = iph->saddr;
@@ -93,7 +93,8 @@ static int help(struct sk_buff **pskb,
 	exp->expectfn             = NULL;
 	exp->flags                = IP_CT_EXPECT_PERMANENT;
 
-	ip_conntrack_expect_related(exp);
+	if (ip_conntrack_expect_related(exp) != 0)
+		return NF_DROP;
 	ip_conntrack_expect_put(exp);
 
 	ip_ct_refresh_acct(ct, ctinfo, NULL, timeout * HZ);

--=-=-=--
