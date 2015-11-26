From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 10:52:10 -0200
Message-ID: <5657007A.40303@gmail.com>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia> <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz> <20151126095133.GA1612@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35368 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbKZMwZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 07:52:25 -0500
In-Reply-To: <20151126095133.GA1612@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Em 26-11-2015 07:51, Pablo Neira Ayuso escreveu:
> On Wed, Nov 25, 2015 at 09:58:30PM +0100, Michal Kubecek wrote:
>> On Wed, Nov 25, 2015 at 06:20:46PM -0200, Marcelo Ricardo Leitner wrote:
>>> Em 25-11-2015 17:42, Pablo Neira Ayuso escreveu:
>>>>
>>>> Any specific reason ...
>>>>
>>>> not to have this enable by default?
>>>> to have a sysctl switch to enable/disable this?
>>>>
>>>> Thanks.
>>>
>>> Yes, because it can't be used in routers in the middle. That is,
>>> unless it's a common hop with the initial path..
>>> If it's enabled and this router doesn't see the initial handshake,
>>> it won't allow heartbeats to pass and will block all secondary
>>> paths.
>>>
>>> So if one is already using commit d7ee35190427 and this went on by
>>> default, it would break his/her setup.
>>
>> This essentially means anyone using SCTP multihoming and conntrack based
>> rules as commit db29a9508a92 ("netfilter: conntrack: disable generic
>> tracking for known protocols") enforces using the helper. This is where
>> the need for basic multihoming support came from: our customer was using
>> SCTP multihoming through a firewall with connection tracking but without
>> helper (so that only IP addresses were used to match the conntrack); the
>> security fix prevented them from doing that.
>
> I would really like to see some scrutiny on the SCTP to get it
> embedded into nf_conntrack.
>
> Similar things with other existing protocols that are supported, where
> you need to modprobe the protocol to get support for this.
>
> I think this existing behaviour is an anachronism.

This is not like an extension to SCTP, like a new protocol on top of it. 
It's just how SCTP works on its own.

We can compare the creation of conntrack entries based on heartbeats 
with tcp_loose switch, which allows picking up already established 
connections. Conntrack entries based on heartbeats are somewhat like 
that, it's for paths that you didn't/can't see the handshake.

Then, this patch takes advantage that all SCTP associations have an ID 
(vtag) associated with it and makes it possible to only allow these 
secondary paths if such vtag is already known by this host, in an 
attempt to not be too loose.

This is kind of orthogonal with FTP expected data connections: we can't 
know any of the addresses that will be used for the other paths, but we 
expect that new paths will be used.

So if you see conntrack running at the host that is running the 
application, these secondary conntracks would be like RELATED conntrack 
entries, because we can check if the vtag is known or not and have an 
indication that it's related to something that is already there. But if 
you see conntrack running on a router somewhere out there, it's just 
picking up an already established connection, because it has no idea of 
the rest of the association. The former is the one this patch aims to 
protect without interfering with the last.

Does that help somehow?

   Marcelo

