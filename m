From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Tue, 27 Jan 2009 11:14:43 +0100
Message-ID: <497EDE93.9000606@trash.net>
References: <1232707890.32071.41.camel@khasse.inl.fr>	<200901231110.n0NBAR7Z000645@toshiba.co.jp>	<497DB689.3020109@trash.net> <200901271009.n0RA9d4I025010@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: eric@inl.fr, Marek.Szuba@if.pw.edu.pl,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZA0KOs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:14:48 -0500
In-Reply-To: <200901271009.n0RA9d4I025010@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 26 Jan 2009 14:11:37 +0100
> 
>>> Thank you. I understand why ICMPv6 packets are special here and
>>> I agree to assign UNTRACKED to them. Indeed non-invertible tuple might
>>> bring issues.
>> How about adding a flag to indicate that only one direction of
>> the tuple exists? It makes sense to support this for other kinds
>> of simplex flows as well in my opinion and it somewhat goes in the
>> same direction as the patch I talked about during the workshop
>> to have only a single tuple within the conntrack and have reply
>> tuples or potentially other tuples that relate to a connection
>> within the ct_extend area. And using NEW and having netlink
>> events seems more consistent to me.
> 
> It sounds good for long term solution. For now Eric's patch is enough,
> I think.

OK, thanks.

> And sorry, I don't remember your patch in detail since maybe nftables talk
> was impressive to me ;) but it sounds that it will make easier to implement
> a module to track protocols using broadcast. 

:) Yes, that was one of the ideas. The other one was that f.i. protocols
like SIP don't actually care about the network identitities of their
flows and might send traffic related to a single logical connection on
multiple different flows. I'm hoping that allowing more than two tuples
per conntrack will help with proper tracking.
