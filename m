From: Rob Thomas <xrobau@gmail.com>
Subject: Resurrecting "does nftables support string match?"
Date: Fri, 2 Feb 2018 09:32:17 +1000
Message-ID: <CAC5zRjPSCeXaE-3Q9gSmOcc0Ajbt7CK7KoUhE-dDPvuvcoB9yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38512 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeBAXcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 18:32:19 -0500
Received: by mail-it0-f43.google.com with SMTP id k6so5830507ita.3
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Feb 2018 15:32:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looking through the archives, I see this was brought up previously,
and the answer was 'no' - cite
https://www.spinics.net/lists/netfilter-devel/msg49574.html

What I *actually* want to do is whitelist SIP traffic (unencrypted)
from various remote hosts, hopefully using a set of valid strings (eg,
bytes 10 to 20 of the packet must be in the set X, which contains
"AAAAAAAAAA", "BBBBBBBBBB" and "CCCCCCCCCC" for example)

I was browsing through the RHEL 7.5 release notes, and noticed that
they've pulled 0.8 in, so I was hopefully thinking that I could do
this in nftables, but it appears it's still on the wishlist.

Any news, or, anything I can help with?

--Rob
