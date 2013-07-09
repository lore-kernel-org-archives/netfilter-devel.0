From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Tue, 9 Jul 2013 20:22:23 +0200
Message-ID: <20130709182223.GA6266@localhost>
References: <20130705020312.25783ccd.billfink@mindspring.com>
 <20130706132333.GA3279@localhost>
 <20130707030458.fbf22472.billfink@mindspring.com>
 <20130709013023.2fb1fef1.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8GpibOaaTibBMecb"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130709013023.2fb1fef1.billfink@mindspring.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 01:30:23AM -0400, Bill Fink wrote:
> On Sun, 7 Jul 2013, Bill Fink wrote:
> 
> > I still have the remaining problem that the IPv6 expectation
> > is not successfully synced from the primary firewall to the
> > backup firewall.  I see the following error in conntrackd.log
> > on the backup firewall:
> > 
> > [Sun Jul  7 01:56:38 2013] (pid=24763) [ERROR] inject-add2: Invalid argument
> > Sun Jul  7 01:56:38 2013	300 proto=6 src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=0 dport=39767 mask-src=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff mask-dst=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff sport=0 dport=65535 master-src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx master-dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=37484 dport=21 class=0 helper=ftp
> > 
> > This exactly matches the IPv6 expectation on the primary firewall:
> > 
> > [root@sen-fw1 ~]# conntrackd -i expect
> > proto=6 src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=0 dport=39767 mask-src=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff mask-dst=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff sport=0 dport=65535 master-src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx master-dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=37484 dport=21 class=0 helper=ftp [active since 9s]
> > 
> > IPv4 expectations are working fine.
> > 
> > I tried to track down the error, and followed the error path:
> > 
> > 	external_inject_exp_new() ->
> > 	  nl_create_expect()->
> > 	    nfexp_query() ->
> > 	      nfnl_query() ->
> > 		nfnl_catch() ->
> > 		  nfnl_process() ->
> > 		    nfnl_step() ->
> > 		      nfnl_is_error() because
> > 			nlh->nlmsg_type == NLMSG_ERROR
> > 
> > but I wasn't sure how to proceed further.
> 
> I made some more progress, but still haven't found the root
> cause.  I put some printks in the nf_conntrack_netlink and
> nf_conntrack_ipv6 modules and tracked the error path there:
> 
> 	ctnetlink_new_expect() ->
> 	  ctnetlink_create_expect() ->
> 	    ctnetlink_parse_expect_nat() ->
> 	      ctnetlink_parse_tuple() ->
> 		ctnetlink_parse_tuple_ip() ->
> 		  l3proto->nlattr_to_tuple() ->
> 		    ipv6_nlattr_to_tuple() which fails
> 
> because tb[CTA_IP_V6_SRC] and tb[CTA_IP_V6_DST] are null.
> 
> But I'm currently stuck there.  Where are tb[CTA_IP_V6_SRC]
> and tb[CTA_IP_V6_DST] supposed to be set?  Is it in conntrackd
> during the build of the netlink message, or somewhere in one
> of the conntrack kernel modules during processing of the
> netlink message?  Is there a map somewhere of the control
> flow betwwen conntrackd and the conntrack kernel modules?
> 
> I was also a little confused by the call to ctnetlink_parse_expect_nat()
> since I'm not using NAT.

That's a good clue, thanks. Please, give a try to the attached kernel
patch.

Regards.

--8GpibOaaTibBMecb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-ctnetlink-fix-incorrect-NAT-expectation-du.patch"

>From 08fd3987afa49e092d3165a1b965a7a466cd3dc2 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 9 Jul 2013 20:16:39 +0200
Subject: [PATCH] netfilter: ctnetlink: fix incorrect NAT expectation dumping

nf_ct_expect_alloc leaves unset the expectation NAT fields. However,
ctnetlink_exp_dump_expect expects them to be zeroed in case they are
not used, which may not be the case. This results in dumping the NAT
tuple of the expectation when it should not.

Fix it by zeroing the NAT fields of the expectation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index c63b618..4fd1ca9 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -293,6 +293,11 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		       sizeof(exp->tuple.dst.u3) - len);
 
 	exp->tuple.dst.u.all = *dst;
+
+#ifdef CONFIG_NF_NAT_NEEDED
+	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
+	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+#endif
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
-- 
1.7.10.4


--8GpibOaaTibBMecb--
