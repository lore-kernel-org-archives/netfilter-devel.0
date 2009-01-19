From: Patrick McHardy <kaber@trash.net>
Subject: Re: Rejecting non-CIDR conformant masks?
Date: Mon, 19 Jan 2009 23:24:39 +0100
Message-ID: <4974FDA7.4040702@trash.net>
References: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>    <4974C56D.7020903@trash.net> <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZASWYq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:24:46 -0500
In-Reply-To: <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Amos Jeffries wrote:
>> Jan Engelhardt wrote:
>>     
>>> once again, with that lovely IRC channel that is out there, I noticed a
>>> software that produces odd rules, and indeed, the latest iptables
>>> (and ip6tables) seem to allow a match that has no equivalent CIDR
>>> number, such as:
>>>
>>> 	-A test -d 0.0.0.123/0.0.0.255
>>>
>>> It absolutely works, but if iptables is supposed to support that (is
>>> it?), I should be adding it to the manpage.
>>> Comments?
>>>       
>> Its supposed to work, apparently people have been using masks like
>> /0.0.0.1 for load-balancing with better distribution than /1 :)
>>     
>
> Should they not be using ipset for that?

Why shouldn't they do this, its simple and probably effective.
> The acceptance of this in ip6tables is a major security worry. With the
> non-local network possibly accepting and routing hosts with 'forged' host
> parts.
>   

I don't get the point, people can simply choose not to use this.

