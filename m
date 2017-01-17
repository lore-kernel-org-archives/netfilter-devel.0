From: Jarno Rajahalme <jarno@ovn.org>
Subject: Re: tcp state in conntrack destroy events
Date: Tue, 17 Jan 2017 15:23:33 -0800
Message-ID: <EAB296C2-DCE6-4CCD-9AB9-5505C9C1B2BD@ovn.org>
References: <fdd3eb50-75d3-32e1-d7a0-f333050aece5@inliniac.net> <20170117212807.GC12001@breakpoint.cc>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Victor Julien <lists@inliniac.net>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35484 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdAQXYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 18:24:19 -0500
Received: by mail-pf0-f174.google.com with SMTP id f144so65408716pfa.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 15:23:36 -0800 (PST)
In-Reply-To: <20170117212807.GC12001@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> On Jan 17, 2017, at 1:28 PM, Florian Westphal <fw@strlen.de> wrote:
> 
> Victor Julien <lists@inliniac.net> wrote:
>> I was hoping to get the last TCP state in a conntrack destroy event,
>> however it seems to be unavailable.
>> 
>> Through libnetfilter_conntrack the value retrieved at ATTR_TCP_STATE is
>> always 0.
>> 
>> Using the conntrack command I see the same behavior:
>> 
>> destroy doesn't have it (conntrack -E -e destroy -p tcp):
>> 
>> [DESTROY] tcp      6 src=218.65.30.38 dst=192.168.178.254 sport=61063
>> dport=22 packets=11 bytes=820 src=192.168.0.123 dst=218.65.30.38
>> sport=22 dport=61063 packets=8 bytes=424 [ASSURED] mark=3 delta-time=77
>> 
>> update does (conntrack -E -e updates -p tcp):
>> 
>> [UPDATE] tcp      6 120 FIN_WAIT src=192.168.0.53 dst=x.x.x.x
>> sport=52958 dport=443 src=x.x.x.x dst=192.168.178.254 sport=443
>> dport=52958 [ASSURED] mark=3
>> 
>> Is this intentional? My goal is to create connection log that includes a
>> hint about why the connection is gone.
> 
> Yes, its intentional, see
> net/netfilter/nf_conntrack_netlink.c, there is a check for DESTROY
> that supresses most of the extra info:
> 
> 682 if (events & (1 << IPCT_DESTROY)) {
> 683    if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
> 684        ctnetlink_dump_timestamp(skb, ct) < 0)
> 685           goto nla_put_failure;
> 686    } else {
> ..
> 	/* IPCT_PROTOINFO */
> 
> Pablo made this change in 7b621c1ea64a54f77b8a841b16dc4c9fee3ecf48,
> i guess the rationale was that clients aren't interested in this
> on DESTROY.
> 
> Would be easy to change this.

I have a use case where we want to log terminating connections, but only if a specific label bit is set. To do this, we currently have to listen to both create and destroy events and keep track of all the connections in the userspace to be able to correlate destroy event to the connection and from there to the labels. Would be nice if the destroy event included labels, so that we would not have to listen to create events nor keep a duplicate connection tracking table in userspace.

  Jarno

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

