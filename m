From: Shannon Wynter <freman@fremnet.net>
Subject: Re: ipset suggestion, idle-timeout
Date: Tue, 22 Apr 2014 12:25:28 +1000
Message-ID: <5355D318.8010102@fremnet.net>
References: <5354A37C.8080308@fremnet.net> <alpine.DEB.2.10.1404212121400.17211@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31131 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbaDVCZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:25:35 -0400
In-Reply-To: <alpine.DEB.2.10.1404212121400.17211@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/04/2014 5:25 AM, Jozsef Kadlecsik wrote:
> That's equivalent with "match and re-add the element", which can easily be
> achieved with a rule like:
>
> ... -m set --match-set .... -j SET --add-set ...
>
> (or if you need multiple actions, then jump to a proper chain).
>
> Best regards,
> Jozsef
>
Brilliant, my apologies, I've been using ipset for ages, have even read 
the manual a few times, must have missed the bit where it was telling me 
I could use iptables to add to sets (makes sense though)

Thank you

Shannon.
