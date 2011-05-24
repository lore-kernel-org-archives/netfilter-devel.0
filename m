From: Oskar Berggren <oskar.berggren@gmail.com>
Subject: Re: ipset and interfaces
Date: Tue, 24 May 2011 14:23:05 +0200
Message-ID: <BANLkTi=drvnwAiXk-Js+1Dw0wxWGNsT1xA@mail.gmail.com>
References: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com> <alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32893 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1EXMXp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:23:45 -0400
Received: by bwz15 with SMTP id 15so5571850bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 05:23:44 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2011/5/24 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
> On Tue, 24 May 2011, Oskar Berggren wrote:
>
>> Regarding ipsets.... how crazy would it be to add a set type
>> containing interface names?
>
> Usually the number of interfaces are not quite high in a system, so i=
t
> does not seem required.

I have machines with plenty of vlans. About 700 interfaces in the
largest instance currently.
That said, I don't have a clear use case for this particular set type
currently, but out of curiosity,
would it be reasonably doable within the ipset framework?


>
>> And how crazy would it be to add a set type containing tuples of
>> ip-address and interface name? =A0(I.e. the set match would look for=
 ip,
>> and match if a tuple with the proper interface is found)
>
> What is the case where a combination of matches does not solve the is=
sue?
> Something like this
>
> -N interfaces
> -A interfaces -i foo -j ACTION
> ...
>
> -A rule -m set --match-set src -j interfaces
>
> and thus you can match IP addresses and possible (incoming) interface=
s
> easily.


As above, about 700 interfaces, each with a generally just a few
source ip-addresses
expected for each interface, or a few subnets. I.e. in the simplest
case a single ip is
acceptable for a single interface, for a total of a couple of hundred
interfaces. This
is similar to rp_filter, but I had trouble getting that to work
predictably with multiple
routing tables. Currently I've solved it with a tree structure of
iptables chains and rules,
but being able to use a single set for this would look so much nicer.

/Oskar
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
