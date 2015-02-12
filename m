From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] netfilter: nft_compat: fix sparse warning
Date: Thu, 12 Feb 2015 13:25:57 +0100
Message-ID: <CAOkSjBgk4=rjyEMPeqZWUJ4_49apz49XsTjtwE2VxrpnJvgipA@mail.gmail.com>
References: <20150212101408.20533.19035.stgit@nfdev.cica.es> <20150212122025.GB3294@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:40179 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbbBLM0T convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 07:26:19 -0500
Received: by labgd6 with SMTP id gd6so9693022lab.7
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2015 04:26:17 -0800 (PST)
In-Reply-To: <20150212122025.GB3294@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 February 2015 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Thu, Feb 12, 2015 at 11:14:09AM +0100, Arturo Borrero Gonzalez wro=
te:
>> >> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assi=
gnment (different base types)
>>    net/netfilter/nft_compat.c:140:37:    expected restricted __be16 =
[usertype] ethproto
>>    net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned=
] [usertype] proto
>> >> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assi=
gnment (different base types)
>>    net/netfilter/nft_compat.c:351:37:    expected restricted __be16 =
[usertype] ethproto
>>    net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned=
] [usertype] proto
>
> This is spotting a more serious problem. The existing code is trimmin=
g
> the ethernet protocol field to u8. We should use u16 all around the
> code and then force the casting to calm down sparse.
>

I see,  I can handle it if you want.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
