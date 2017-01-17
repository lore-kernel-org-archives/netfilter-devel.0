From: Victor Julien <lists@inliniac.net>
Subject: Re: tcp state in conntrack destroy events
Date: Tue, 17 Jan 2017 22:39:49 +0100
Message-ID: <4d0f9bdc-d6a1-76cb-7a2e-4fcc3a78672c@inliniac.net>
References: <fdd3eb50-75d3-32e1-d7a0-f333050aece5@inliniac.net>
 <20170117212807.GC12001@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:54251 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbdAQVjw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 16:39:52 -0500
Received: from [192.168.1.6] (a212-238-163-105.adsl.xs4all.nl [212.238.163.105])
        (Authenticated sender: victorlists)
        by mail.inliniac.net (Postfix) with ESMTPSA id F286D7338
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 22:42:15 +0100 (CET)
In-Reply-To: <20170117212807.GC12001@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17-01-17 22:28, Florian Westphal wrote:
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
>>  [UPDATE] tcp      6 120 FIN_WAIT src=192.168.0.53 dst=x.x.x.x
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
> 

Would there be another way of achieving this goal? I mean other than
tracking all updates and keeping a parallel conntrack in user space :)

Maybe I wouldn't need all the TCP states and just a flag or something
indicating a 'unclean' connection end would also work.

Haven't been able to figure out all fields yet, but so far I haven't
found what I was hoping for.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

