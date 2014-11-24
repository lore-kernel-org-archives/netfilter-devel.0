From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: named vmaps
Date: Mon, 24 Nov 2014 20:03:16 +0100
Message-ID: <CAJO99Tkv_rRE8Jd+=DzVSmWiFMUT2hgtLWR9VUxmZkivrod34w@mail.gmail.com>
References: <CAJO99T=5z-AC=YzOVTYH3++6kf74fXqSu=Q15Jqhb3bVYQ-mLw@mail.gmail.com>
	<20141124115522.GA27521@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59969 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaKXTDS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:03:18 -0500
Received: by mail-lb0-f171.google.com with SMTP id n15so2245669lbi.16
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 11:03:16 -0800 (PST)
In-Reply-To: <20141124115522.GA27521@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-11-24 12:55 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Fri, Nov 21, 2014 at 09:22:00AM +0100, Bj=C3=B8rnar Ness wrote:
>> Is support for named vmaps removed from nft? Running kernel 3.18.0-r=
c5
>> [ ... ]
>
> I have updated the documentation:
>
> http://wiki.nftables.org/wiki-nftables/index.php/Dictionaries
>
> Please, let me know if you find any mistake on it. Thanks.

This works, thanks Pablo!

A few comments, tho:

Is it possible/planned to make counters work with sets/vmaps?

nft add rule filter input ip saddr vmap @my_vmap counter

will not work since it counts too late (never)

Is the following planned:
1) individual element counters
2) comments for elements
3) element timeout

Also, negative set/vmap lookup does not seem to work, I would like the
following functionality

nft insert rule filter forward ip saddr !@ignorelist ip saddr @blocklis=
t drop

Best regards,

--=20
Bj(/)rnar
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
