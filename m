From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] net/icmp: restore source address if packet is NATed
Date: Thu, 9 Nov 2017 09:35:16 +0900
Message-ID: <CAHmME9oYGQpr7+aq7ByQ4UVYMY5aFky09NrHpVRYNMZ+XiDVDw@mail.gmail.com>
References: <CAHmME9rapx6z1T76ik2vhF0bBotVy+GFkTTDY810aNso7ViV5w@mail.gmail.com>
 <20171109000134.GC5512@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:55427 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752182AbdKIAfT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2017 19:35:19 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3639e33d
        for <netfilter-devel@vger.kernel.org>;
        Thu, 9 Nov 2017 00:31:54 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 903a3621 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <netfilter-devel@vger.kernel.org>;
        Thu, 9 Nov 2017 00:31:53 +0000 (UTC)
Received: by mail-oi0-f44.google.com with SMTP id a132so3279777oih.11
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Nov 2017 16:35:17 -0800 (PST)
In-Reply-To: <20171109000134.GC5512@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 9, 2017 at 9:01 AM, Florian Westphal <fw@strlen.de> wrote:
> I think correct solution is to never allow drivers to do something like
> this.  What is the use case here? Normal IP stack should send
> imcp/pkttobig errors, and that will work fine since it occurs pre-snat.

The use case is particular tunneling devices -- virtual interfaces.
It's possible that a tunnel device won't be able to transmit a packet,
due to some particular state issue -- no encryption key available,
incomplete configuration for a particular destination, etc -- and in
that case, it's quite important to be able to send an error --
ICMP_DEST_UNREACH,ICMP_HOST_UNREACH -- back to the sender, rather than
letting packets disappear into a blackhole without any useful
notification.
