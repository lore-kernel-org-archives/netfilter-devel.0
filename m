From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Building the conntrack rule from scratch
Date: Thu, 27 Nov 2008 01:07:51 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811270103450.21265@fbirervta.pbzchgretzou.qr>
References: <492DC363.3040304@astrocorp.com> <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr> <492DD46A.7000209@astrocorp.com> <alpine.LNX.1.10.0811270003121.21265@fbirervta.pbzchgretzou.qr> <492DDAB7.3090209@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37186 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYK0AHx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:07:53 -0500
In-Reply-To: <492DDAB7.3090209@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-27 00:24, Bryan Duff wrote:
>> > Here is the rule:
>> >
>> > conntrack -I --orig-src 192.168.10.10 --orig-dst 192.168.2.206
>> > --reply-src 192.168.2.206 --reply-dst 192.168.2.204 -p udp
>> > --orig-port-src 5000 --orig-port-dst 7002 --reply-port-src 7002
>> > --reply-port-dst 7000 -u ASSURED -t 60
>> >
>> > 192.168.10.10 is the phone in my LAN.
>> > 192.168.2.204 is the local WAN address.
>> > 192.168.2.206 is the remote address.
>> >
>> > If that above rule is inserted, and I send traffic (that matches
>> > the rule) out the WAN from the LAN, why would it not SNAT the
>> > rule on the way out (from orig-src 192.168.10.10 to reply-dst
>> > 192.168.2.204)?
>>
>> You just set up a NAT mapping and even marked it ASSURED,
>> so no further mapping modifications are accepted.
>
> Wait.  So I don't need to do anything else?  It should work?

I did not say that ... I merely said that packets from the connection
will not traverse the nat table anymore because the connection is
ASSURED. The ASSURED bit (a _status_ bit) is distinct from
NEW/ESTABLISHED (a _state_ bit), *but* I would say that setting
ASSURED requires that the connection be at least ESTABLISHED, and
that the connection state is implicitly upgraded to ESTABLISHED
if you try to set it to ASSURED. That is the first issue.

The second one may be that because the connection might not have
the IP_NAT_MANIP_SRC flag set that no SNAT is done at all. Can't
say much more though, since I rarely need conntrack(8) currently.
