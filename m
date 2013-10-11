From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nftables PATCH] src: error if listing nonexistent table
Date: Fri, 11 Oct 2013 14:30:10 +0200
Message-ID: <CAOkSjBjWPpMr=WEFBd9EpGBGRbhuBJZr6-Pa06L2OZRTKEXzwQ@mail.gmail.com>
References: <20131010222129.14092.99057.stgit@nfdev.cica.es> <20131011082416.GA3630@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46117 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3JKMac convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:30:32 -0400
Received: by mail-lb0-f179.google.com with SMTP id x18so3279929lbi.24
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 05:30:30 -0700 (PDT)
In-Reply-To: <20131011082416.GA3630@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 October 2013 10:24, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> Hi Arturo,
>
> On Fri, Oct 11, 2013 at 12:21:30AM +0200, Arturo Borrero Gonzalez wro=
te:
>> Here examples (foo table doesn't exist).
>>
>> Before this patch:
>>
>> # nft list table foo
>> table ip foo {
>> }
>
> I cannot reproduce this here:

Right. I guess this only happen with the patch I sent the other day
for the kernel to dump sets with NFPROTO_UNSPEC.

I will investigate and come back.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
