From: "Julius Volz" <juliusv@google.com>
Subject: Re: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 14:45:59 +0200
Message-ID: <f4845fc0809230545n6c879a7eg7214b0a3b3db61a3@mail.gmail.com>
References: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
	 <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	"Simon Horman" <horms@verge.net.au>,
	"Joseph Mack NA3T" <jmack@wm7d.net>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYIWMqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:46:09 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m8NCk2ap030539
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 13:46:03 +0100
Received: from ug-out-1314.google.com (ugck40.prod.google.com [10.66.112.40])
	by zps77.corp.google.com with ESMTP id m8NCk081016060
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 05:46:00 -0700
Received: by ug-out-1314.google.com with SMTP id k40so3353814ugc.29
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 05:45:59 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 23, 2008 at 2:33 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2008-09-23 06:13, Julius Volz wrote:
>>
>>Any ideas why the first packets never appear in the POSTROUTING chain
>>but the ACK does?
>
> It is not the first packet of the TCP connection that will show up
> in the nat table, it is the first packet of the *tracked* connection,
> which may not match the boundary of the classical connection.
>
> Like...
>        -t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN -j NOTRACK
>        -t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN,ACK -j NOTRACK
>
> Will cause the exact behavior that the 3rd packet that would match
> --tcp-flags SYN,ACK,RST,FIN ACK will be the one showing up in the nat table.

Thanks, that makes sense! I have no other iptables rules, by the way.

I just found out a minute ago why the SYN didn't enter the chain in my
case. When you send packets through IPVS, you send them to the virtual
IP that is configured on the load balancer so that IPVS can pick them
up on LOCAL_IN. However, there is also a Netfilter NAT hook for
LOCAL_IN (nf_nat_fn), which marks the packet as "already seen". This
is mark is checked later in POSTROUTING and the chain is not traversed
then... just disabling that LOCAL_IN hook in
net/ipv4/nf_nat_standalone.c for testing leads to correct SNATing of
the SYN, but the reply from the backend does not seem to get un-SNATed
in PREROUTING for some reason. It gets picked up by IPVS from FORWARD,
but still has the SNAT IP as its destination, so IPVS doesn't
recognize it.

> As such, it might be worth looking at the LOGMARK target in Xtables-addons
> which will print out whether such a connection even exists/has been untracked.
> Alternatively, if you don't mind typing lots,
>
>        -t mangle -A PREROUTING -m conntrack --ctstate INVALID \
>                -j LOG --log-prefix "this won't shop up in nat: "
>        -t mangle -A PREROUTING -m conntrack --ctstate UNTRACKED \
>                -j LOG --log-prefix "neither will this: "

Thanks, this is interesting and I'll use that for further debugging!

Julius

-- 
Julius Volz - Corporate Operations - SysOps

Google Switzerland GmbH - Identification No.: CH-020.4.028.116-1
