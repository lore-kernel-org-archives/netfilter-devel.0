From: mudrunka@spoje.net
Subject: Re: Easy way to set NOTRACK for INPUT, FORWARD and OUTPUT
 independently
Date: Sat, 17 Dec 2016 15:27:54 +0100
Message-ID: <e4afb86fb9f9bf2f5e9167b70106540b@spoje.net>
References: <83039186e8c81a62f20e605de41ccba3@spoje.net>
 <c84a9319f8b1f2bb0554d5a4a942e3b1@spoje.net>
 <20161217122922.GC13094@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.spoje.net ([82.100.58.2]:43643 "EHLO mail.spoje.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbcLQO2A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Dec 2016 09:28:00 -0500
Received: from localhost (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id 6F80444098
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Dec 2016 15:27:57 +0100 (CET)
Received: from mail.spoje.net ([127.0.0.1])
        by localhost (mail.spoje.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kPS7H0Hotl61 for <netfilter-devel@vger.kernel.org>;
        Sat, 17 Dec 2016 15:27:55 +0100 (CET)
Received: from mail.spoje.net (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id D692144097
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Dec 2016 15:27:54 +0100 (CET)
In-Reply-To: <20161217122922.GC13094@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

WOW! Thank you very much, this actually works!


> I suggest to use the addrtype match for this:
> addrtype --dst-type LOCAL should do what you want.
> 
>> >I am planning to switch over to nftables, so it might be another
>> >solution...
>> >Is this planned to be fixed in nftables? If not can you please
>> >consider fixing it?
> 
> The fib expression can be used in nft. ("fib daddr type local").
> --
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

