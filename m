From: mudrunka@spoje.net
Subject: Re: Easy way to set NOTRACK for INPUT, FORWARD and OUTPUT
 independently
Date: Tue, 06 Dec 2016 06:56:56 +0100
Message-ID: <c84a9319f8b1f2bb0554d5a4a942e3b1@spoje.net>
References: <83039186e8c81a62f20e605de41ccba3@spoje.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.spoje.net ([82.100.58.2]:55688 "EHLO mail.spoje.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbcLFGE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 01:04:58 -0500
Received: from localhost (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id BDB6A44096
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 06:56:58 +0100 (CET)
Received: from mail.spoje.net ([127.0.0.1])
        by localhost (mail.spoje.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BhE-DcKgLWWp for <netfilter-devel@vger.kernel.org>;
        Tue,  6 Dec 2016 06:56:56 +0100 (CET)
Received: from mail.spoje.net (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id 9238544095
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 06:56:56 +0100 (CET)
In-Reply-To: <83039186e8c81a62f20e605de41ccba3@spoje.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

And by "disguise" i've meant "distinguish" :-)
T.

Dne 2016-12-06 06:54, mudrunka@spoje.net napsal:
> Hello,
> currently in iptables i can set NOTRACK (-j CT --notrack) only for
> OUTPUT and PREROUTING. Because the routing decision is made after the
> conntracking.
> 
> I need stateful firewall on INPUT, but conntrack on FORWARD is
> performance drawback for me. And i can imagine that someone might have
> exact oposite of this problem.
> 
> When i want to enable conntrack for input, but not for forwarding, i
> have to list all the ip adresses on local interfaces. This is big
> administrative PITA for several reasons. i have routers with hundreds
> of vlans and each of these vlans have multiple ip adresses - both ipv4
> and ipv6. Disabling conntrack for FORWARD only means listing all of
> them in PREROUTING to disguise INPUT traffic from the FORWARDed one.
> This is annoying and prone to error.
> 
> It would be super useful if one can simply use "-j CT --notrack" in
> INPUT and FORWARD. (it already works in OUTPUT)
> 
> If it's impossible to postpone conntrack after routing decision, it
> might be possible to add some macro that would match any of local
> adresses that are currently on any of interfaces. like "--src local"
> or "--dst local". Currently i am using ipset filled by cron script
> with all these adresses parsed from "ip a s". But that's far from
> being elegant or reliable.
> 
> I am planning to switch over to nftables, so it might be another 
> solution...
> Is this planned to be fixed in nftables? If not can you please
> consider fixing it?
> 
> 
> Thanks
> 
> Best regards
>       Tomas Mudrunka

