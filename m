From: "Julius Volz" <juliusv@google.com>
Subject: Re: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 15:13:44 +0200
Message-ID: <f4845fc0809230613l68c1ba90s16e5482479bd3c9c@mail.gmail.com>
References: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
	 <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>
	 <f4845fc0809230545n6c879a7eg7214b0a3b3db61a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	"Simon Horman" <horms@verge.net.au>,
	"Joseph Mack NA3T" <jmack@wm7d.net>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:27411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYIWNN4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:13:56 -0400
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id m8NDDl30017342
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 14:13:48 +0100
Received: from ug-out-1314.google.com (ugfj3.prod.google.com [10.66.186.3])
	by zps38.corp.google.com with ESMTP id m8NDDjFf018924
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 06:13:46 -0700
Received: by ug-out-1314.google.com with SMTP id j3so1743404ugf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 06:13:45 -0700 (PDT)
In-Reply-To: <f4845fc0809230545n6c879a7eg7214b0a3b3db61a3@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 23, 2008 at 2:45 PM, Julius Volz <juliusv@google.com> wrote:
> On Tue, Sep 23, 2008 at 2:33 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>
>> On Tuesday 2008-09-23 06:13, Julius Volz wrote:
>>>
>>>Any ideas why the first packets never appear in the POSTROUTING chain
>>>but the ACK does?
>>
>> It is not the first packet of the TCP connection that will show up
>> in the nat table, it is the first packet of the *tracked* connection,
>> which may not match the boundary of the classical connection.
>>
>> Like...
>>        -t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN -j NOTRACK
>>        -t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN,ACK -j NOTRACK
>>
>> Will cause the exact behavior that the 3rd packet that would match
>> --tcp-flags SYN,ACK,RST,FIN ACK will be the one showing up in the nat table.
>
> Thanks, that makes sense! I have no other iptables rules, by the way.
>
> I just found out a minute ago why the SYN didn't enter the chain in my
> case. When you send packets through IPVS, you send them to the virtual
> IP that is configured on the load balancer so that IPVS can pick them
> up on LOCAL_IN. However, there is also a Netfilter NAT hook for
> LOCAL_IN (nf_nat_fn), which marks the packet as "already seen". This
> is mark is checked later in POSTROUTING and the chain is not traversed
> then... just disabling that LOCAL_IN hook in
> net/ipv4/nf_nat_standalone.c for testing leads to correct SNATing of
> the SYN, but the reply from the backend does not seem to get un-SNATed
> in PREROUTING for some reason. It gets picked up by IPVS from FORWARD,
> but still has the SNAT IP as its destination, so IPVS doesn't
> recognize it.

Ok, the SYN/ACK from the backend is logged as --cstate INVALID in
PREROUTING and INPUT. This means that Netfilter thinks it doesn't
belong to any connection, although it just SNATed the SYN to the
backend correctly? Hmm... how can this be?

Julius

-- 
Julius Volz - Corporate Operations - SysOps

Google Switzerland GmbH - Identification No.: CH-020.4.028.116-1
