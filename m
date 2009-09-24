From: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Subject: Re: xt_stealth as separate patch against xtables-addons-1.17
Date: Thu, 24 Sep 2009 14:58:35 +0200 (MEST)
Message-ID: <alpine.LNX.2.00.0909241450270.8925@cedric.unob.cz>
References: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz> <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, spender@grsecurity.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cedric.unob.cz ([160.216.40.10]:50570 "EHLO cedric.unob.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZIXM6n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:58:43 -0400
In-Reply-To: <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thu, 24 Sep 2009, Jan Engelhardt wrote:

> I looked at xt_stealth and it looks like
>
> -A INPUT -j sktest
> -A sktest -m socket -j RETURN
> -A sktest -j DROP
>
> can do just the same.
> Please tell me if I am wrong anywhere.
>
> That would mean there is no need for xt_stealth.

Yeah, thanks for suggestion.

On 2.6.29.6 with iptables 1.4.4, tried:

   iptables -N opensocktest
   iptables -A opensocktest -m socket                      -j RETURN
   iptables -A opensocktest                                -j DROP

   iptables -A INPUT                                       -j opensocktest

Unfortunately, adding the last rule failed with message:

   ip_tables: socket match: bad hook_mask 0x2/0x1

in the KRB (is there something I do wrong, or do I need updated
xt_socket)? At the moment, I'm stuck with 2.6.29.6; no chance to test
with newer kernel.


Btw, the manpage for 'socket' match should clearly specify that
an 'open socket' means socket in either listening or established state.
I was first puzzled by what 'open socket' really means...
Balasz?

Jan
