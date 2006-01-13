From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
 notification
Date: Fri, 13 Jan 2006 19:12:56 +0900 (JST)
Message-ID: <20060113.191256.73498527.yoshfuji@linux-ipv6.org>
References: <43C76D22.8050805@trash.net>
	<200601130938.k0D9c6Yo007986@toshiba.co.jp>
	<43C776A6.2010306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <43C776A6.2010306@trash.net>
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

In article <43C776A6.2010306@trash.net> (at Fri, 13 Jan 2006 10:45:10 +0100), Patrick McHardy <kaber@trash.net> says:

> Yasuyuki KOZAKAI wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Fri, 13 Jan 2006 10:04:34 +0100
> > 
> > 
> >>>I think that root caurse is missing check at __nf_ct_{l3}proto_find().
> >>>I'll write patch for it. It will free people from taking care about
> >>>expectation mask.
> >>
> >>I agree, that seems to be the best solution.
> > 
> > 
> > Here you are. How about this ?
> 
> Thanks, looks good. Applied.

Really? ;-)

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

diff -u b/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
--- b/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -101,7 +101,7 @@
 static inline struct nf_conntrack_l3proto *
 __nf_ct_l3proto_find(u_int16_t l3proto)
 {
-	if (unlikely(l3proto > AF_MAX))
+	if (unlikely(l3proto >= AF_MAX))
 		return &nf_conntrack_generic_l3proto;
 	return nf_ct_l3protos[l3proto];
 }
diff -u b/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- b/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -188,7 +188,7 @@
 struct nf_conntrack_protocol *
 __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
 {
-	if (unlikely(l3proto > AF_MAX || nf_ct_protos[l3proto] == NULL))
+	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
 		return &nf_conntrack_generic_protocol;
 
 	return nf_ct_protos[l3proto][protocol];

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
