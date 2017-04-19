From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Doubt about CTA_EXPECT_* values passed to ctnetlink_parse_tuple()
Date: Wed, 19 Apr 2017 10:58:39 +0200
Message-ID: <20170419085839.GA1197@salvia>
References: <20170417223730.GR28657@google.com>
 <20170418083947.GA1720@salvia>
 <20170418194116.GD128305@google.com>
 <20170418194315.GE128305@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761268AbdDSI6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 04:58:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CA4924716
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 10:58:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C03BDA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 10:58:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4023ADA87A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 10:58:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170418194315.GE128305@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 18, 2017 at 12:43:15PM -0700, Matthias Kaehlcke wrote:
> El Tue, Apr 18, 2017 at 12:41:16PM -0700 Matthias Kaehlcke ha dit:
> 
> > Hi Pablo,
> > 
> > Thanks for your reply!
> > 
> > El Tue, Apr 18, 2017 at 10:39:47AM +0200 Pablo Neira Ayuso ha dit:
> > 
> > > On Mon, Apr 17, 2017 at 03:37:30PM -0700, Matthias Kaehlcke wrote:
> > > > Hi,
> > > > 
> > > > While working on clang support for kernel builds I came across at what
> > > > at first sight looks like an enum mismatch in the netfilter conntrack
> > > > code:
> > > > 
> > > > In multiple occasions CTA_EXPECT_* values (of type enum ctattr_expect)
> > > > are passed to ctnetlink_parse_tuple(), which expects an 'enum
> > > > ctattr_type' as type argument.
> > > 
> > > Are you refering to this? See patch.
> > 
> > Almost, see patch :)
> 
> This time with patch

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 27540455dc62..4d7f3780d64b 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1006,9 +1006,8 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
>  
>  static int
>  ctnetlink_parse_tuple(const struct nlattr * const cda[],
> -		      struct nf_conntrack_tuple *tuple,
> -		      enum ctattr_type type, u_int8_t l3num,
> -		      struct nf_conntrack_zone *zone)
> +		      struct nf_conntrack_tuple *tuple, u32 type,
> +		      u_int8_t l3num, struct nf_conntrack_zone *zone)
>  {
>  	struct nlattr *tb[CTA_TUPLE_MAX+1];
>  	int err;
> @@ -2405,7 +2404,7 @@ static struct nfnl_ct_hook ctnetlink_glue_hook = {
>  
>  static int ctnetlink_exp_dump_tuple(struct sk_buff *skb,
>  				    const struct nf_conntrack_tuple *tuple,
> -				    enum ctattr_expect type)
> +				    uint32_t type)
>  {
>  	struct nlattr *nest_parms;
>  

Looks fine. Please, add title, description and Signed-off-by tag, I'll
take it :)
