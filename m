From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: Doubt about CTA_EXPECT_* values passed to ctnetlink_parse_tuple()
Date: Tue, 18 Apr 2017 12:43:15 -0700
Message-ID: <20170418194315.GE128305@google.com>
References: <20170417223730.GR28657@google.com>
 <20170418083947.GA1720@salvia>
 <20170418194116.GD128305@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35075 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754528AbdDRTnR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 15:43:17 -0400
Received: by mail-pf0-f180.google.com with SMTP id i5so1325802pfc.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 12:43:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170418194116.GD128305@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

El Tue, Apr 18, 2017 at 12:41:16PM -0700 Matthias Kaehlcke ha dit:

> Hi Pablo,
> 
> Thanks for your reply!
> 
> El Tue, Apr 18, 2017 at 10:39:47AM +0200 Pablo Neira Ayuso ha dit:
> 
> > On Mon, Apr 17, 2017 at 03:37:30PM -0700, Matthias Kaehlcke wrote:
> > > Hi,
> > > 
> > > While working on clang support for kernel builds I came across at what
> > > at first sight looks like an enum mismatch in the netfilter conntrack
> > > code:
> > > 
> > > In multiple occasions CTA_EXPECT_* values (of type enum ctattr_expect)
> > > are passed to ctnetlink_parse_tuple(), which expects an 'enum
> > > ctattr_type' as type argument.
> > 
> > Are you refering to this? See patch.
> 
> Almost, see patch :)

This time with patch

--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="y.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 27540455dc62..4d7f3780d64b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1006,9 +1006,8 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
 
 static int
 ctnetlink_parse_tuple(const struct nlattr * const cda[],
-		      struct nf_conntrack_tuple *tuple,
-		      enum ctattr_type type, u_int8_t l3num,
-		      struct nf_conntrack_zone *zone)
+		      struct nf_conntrack_tuple *tuple, u32 type,
+		      u_int8_t l3num, struct nf_conntrack_zone *zone)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;
@@ -2405,7 +2404,7 @@ static struct nfnl_ct_hook ctnetlink_glue_hook = {
 
 static int ctnetlink_exp_dump_tuple(struct sk_buff *skb,
 				    const struct nf_conntrack_tuple *tuple,
-				    enum ctattr_expect type)
+				    uint32_t type)
 {
 	struct nlattr *nest_parms;
 

--a8Wt8u1KmwUX3Y2C--
