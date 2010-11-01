From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: clone packet with new destination address
Date: Mon, 1 Nov 2010 23:00:34 +0800
Message-ID: <AANLkTiny3XRc7-OPrUzvzp_=0wd4KJ+GAhPQEkQrSwjR@mail.gmail.com>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com>
 <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com>
 <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
 <4CCECEDD.2030107@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34517 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0KAPA5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:00:57 -0400
Received: by fxm16 with SMTP id 16so4941104fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Nov 2010 08:00:56 -0700 (PDT)
In-Reply-To: <4CCECEDD.2030107@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 1, 2010 at 10:29 PM, Stephen Clark <sclark46@earthlink.net> wrote:
>
> I am not sure on how to go about doing that, looking at the code for TEE it
> looks
> like the cloned packet bypasses any of the remaining iptables chains.

It isn't true. The cloned packet only bypasses the iptables rule where
it is generated.

> So
> where
> would I change the destination address? Also if I am mistaken and it does
> hit
> one of the remaining iptables chains how do I tell it is not the original
> but the
> cloned packet I want to change to the new destination address?
>

I think you can use the RAWSNAT xtables-addon to change the
destination address. Since the new skb is attached to untracked ct,
you can use match conntrack --ctstate UNTRACKED to filter it out.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
