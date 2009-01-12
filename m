From: Patrick McHardy <kaber@trash.net>
Subject: Re: How can i leave a packet to continue the iptables ruleset checking?
Date: Mon, 12 Jan 2009 06:10:52 +0100
Message-ID: <496AD0DC.1070102@trash.net>
References: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: ilninno <ilninno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55570 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZALFLJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:11:09 -0500
In-Reply-To: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ilninno wrote:
> Hello! I have some problems with netfilter_queue:
> 
> I created a queue and registered my c program, when a packet matchs
> with the iptables rules my code get the event. i usually return
> NF_ACCEPT and NF_DROP, but sometimes i need to leave the packet to
> continue with iptables rules checking, i tried with:
> 
> 1- Using NF_QUEUE: WIth this option the packet enter again in iptables
> rules (from rule 1 to NFQUEUE rule), but i only want to check (from
> NFQUEUE rule to end).
> 
> 
> rule:   $IPTABLES -A OUTPUT -m state --state NEW -j NFQUEUE --queue-num 0
> 
> 
> 
> How can i leave the packet to continue in iptables ruleset without
> beginning again?  Thanks for your time.

You can use NF_REPEAT to enter the same chain again and mark
the packet to skip the first rules or jump to a seperate chain.
