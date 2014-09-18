From: SaRaVanAn <saravanan.nagarajan87@gmail.com>
Subject: Re: Query on "Add locking to prevent concurrent instances" patch
Date: Thu, 18 Sep 2014 23:26:36 +0530
Message-ID: <CA+86yMjXGM=dNpsDjDz03CxXF9gEoC0XnrSn-KOqpuy9pYC4uw@mail.gmail.com>
References: <CA+86yMj=JY+x6v96wFmS8RrGuqard-kETu57fm-6VvGdvx6b5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:40958 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRR4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:56:37 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so1332585wes.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 10:56:36 -0700 (PDT)
In-Reply-To: <CA+86yMj=JY+x6v96wFmS8RrGuqard-kETu57fm-6VvGdvx6b5w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Team,
    Any pointers on this?

Patch details
http://git.netfilter.org/iptables/commit/?id=93587a04d0f2511e108bbc4d87a8b9d28a5c5dd8
http://git.netfilter.org/iptables/commit/?id=d7aeda5ed45ac7ca959f12180690caa371b5b14b

On Mon, Sep 15, 2014 at 6:05 PM, SaRaVanAn
<saravanan.nagarajan87@gmail.com> wrote:
> Hi Team,
>    We are using iptables version "1.4.14". We decided to take latest
> iptables version to resolve "resource temporarily unavailable"
> issue.We have compiled the latest version "1.4.20-1"  and tried
> installing it. It seems the latest iptables code needs glibc-2.14.
>
> Is it possible to merge the patch alone without going for glibc
> upgrade? Will it work without glibc upgrade?
>
> Glibc upgrade is a major change for us, since it leads to many library
> upgrades.
>
> Please provide your inputs on this.
>
>
> Regards,
> Saravanan N
