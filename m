From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Rejecting non-CIDR conformant masks?
Date: Tue, 20 Jan 2009 08:12:55 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901200810510.15943@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>    <4974C56D.7020903@trash.net> <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZATHM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:12:57 -0500
In-Reply-To: <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-19 23:08, Amos Jeffries wrote:
>>> 	-A test -d 0.0.0.123/0.0.0.255
>>
>> Its supposed to work, apparently people have been using masks like
>> /0.0.0.1 for load-balancing with better distribution than /1 :)
>
>Should they not be using ipset for that?

I am not sure ipset provides an appropriate (optimized) set type for that,
and since /0.0.0.1 is about 2^31 hosts, all the existing types
including tree and bitmap would seem to take large amounts of memory
due to this pattern.

>The acceptance of this in ip6tables is a major security worry. With the
>non-local network possibly accepting and routing hosts with 'forged' host
>parts.

That is why you add extra specifiers like -i/-o xyz to restrict
what /0.0.0.1 applies to.
