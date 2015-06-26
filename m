From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 26 Jun 2015 13:47:20 +0200
Message-ID: <CAJO99Tk3dk1G2HXfz46CQu=M2QON2R_hnFTm3Fwkb+BKjYvqSQ@mail.gmail.com>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
	<20150619125724.GG22946@acer.localdomain>
	<2024102.ynN6JVsV1M@rofl>
	<alpine.LSU.2.20.1506191520530.15886@nerf40.vanv.qr>
	<20150619133708.GJ22946@acer.localdomain>
	<alpine.LSU.2.20.1506191553060.24212@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick Schaaf <netdev@bof.de>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34383 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbbFZLrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 07:47:22 -0400
Received: by lbnk3 with SMTP id k3so62889772lbn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2015 04:47:20 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1506191553060.24212@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jun 19, 2015 4:14 PM, "Jan Engelhardt" <jengelh@inai.de> wrote:
>
>
> On Friday 2015-06-19 15:37, Patrick McHardy wrote:
> >
> >[...] I don't think [tee] is necessarily well known among
> >firewall admins.
>
> I think different.
>
>
> TEE has been in iptables for a long time (a little over five years),
> the manpage for it has the important keywords "clone" and "redirect"
> in it, and there are sufficiently many blog posts and StackExchange
> on the matter (including duplication), and has become an established
> name, like masquerade - another symbolic-mnemonic name - once did.

I agree. Tee is a historic name, and should be good reasons to change.
