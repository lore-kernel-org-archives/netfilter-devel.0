From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 13 Dec 2005 12:22:03 +0100
Message-ID: <439EAEDB.8080207@trash.net>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
	<438710E1.2000202@trash.net> <4387A946.3000005@eurodev.net>
	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
	<20051129040925.GC3544@rama.towersoft.de>
	<438CDF45.9040308@trash.net>
	<Pine.LNX.4.64.0512131041090.928@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000806050706000308090605"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>,  stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0512131041090.928@bizon.gios.gov.pl>
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
--------------000806050706000308090605
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
> The review cycle for the 2.6.14.4 was started. I can't find this fix in 
> listed patches and it seems 2.6.14 needs little different patch than 
> 2.6.15: s/size_t/int/.
> 
> Patch attached, not sure what to do with Signed-off-by lines so please 
> feel free to correct it.
> 
> Any chances for submitting it into -stable for inclusion in 2.6.14.4?

Sorry, I wanted to wait until the patch hit Linus' tree and
forgot about it. Unfortunately ctnetlink has a number of other
issues in 2.6.14 that don't fulfil the -stable requirements,
so in the end its still pretty unusable.

Anyway, this patch fixes a deadlock when dumping the conntrack
table which has already hit a number of people. Please consider
for -stable.

The patch Krzysztof attached went into 2.6.15-rc and fixes an
attribute sizes that was used inconsistently. Without this patch
compatiblity will break once we fix up the userspace side. The
first released kernel with ctnetlink was 2.6.14, so far the only
user known to me is a tool in beta-stage that lives in netfilter
SVN. We would prefer to have no incompatiblities between at least
2.6.14.x and later kernels, so is something like this acceptable
for -stable? If yes I'll send a patch that applies cleanly to
2.6.14.3.

--------------000806050706000308090605
Content-Type: text/x-patch;
 name="ctnl-01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnl-01.diff"

[NETFILTER]: Fix unbalanced read_unlock_bh in ctnetlink

NFA_NEST calls NFA_PUT which jumps to nfattr_failure if the skb has no
room left. We call read_unlock_bh at nfattr_failure for the NFA_PUT inside
the locked section, so move NFA_NEST inside the locked section too.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 266c8543480e2202ab63d1d604a5ca049f350cd8
tree 77c754dce63f39e1f9dc2d1768ecd348c1d50c74
parent 6636568cf85ef5898a892e90fcc88b61cca9ca27
author Patrick McHardy <kaber@trash.net> Mon, 05 Dec 2005 13:37:33 -0800
committer David S. Miller <davem@davemloft.net> Mon, 05 Dec 2005 13:37:33 -0800

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index aeb7353..e7fa29e 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -341,9 +341,10 @@ static int tcp_print_conntrack(struct se
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	struct nfattr *nest_parms;
 	
 	read_lock_bh(&tcp_lock);
+	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 	read_unlock_bh(&tcp_lock);

--------------000806050706000308090605--
