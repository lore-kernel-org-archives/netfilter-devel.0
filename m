From: "Amos Jeffries" <squid3@treenet.co.nz>
Subject: Re: Rejecting non-CIDR conformant masks?
Date: Tue, 20 Jan 2009 11:08:34 +1300 (NZDT)
Message-ID: <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz>
References: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>
    <4974C56D.7020903@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:48835
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZASWTV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:19:21 -0500
In-Reply-To: <4974C56D.7020903@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Jan Engelhardt wrote:
>> once again, with that lovely IRC channel that is out there, I noticed a
>> software that produces odd rules, and indeed, the latest iptables
>> (and ip6tables) seem to allow a match that has no equivalent CIDR
>> number, such as:
>>
>> 	-A test -d 0.0.0.123/0.0.0.255
>>
>> It absolutely works, but if iptables is supposed to support that (is
>> it?), I should be adding it to the manpage.
>> Comments?
>
> Its supposed to work, apparently people have been using masks like
> /0.0.0.1 for load-balancing with better distribution than /1 :)

Should they not be using ipset for that?

The acceptance of this in ip6tables is a major security worry. With the
non-local network possibly accepting and routing hosts with 'forged' host
parts.

AYJ


