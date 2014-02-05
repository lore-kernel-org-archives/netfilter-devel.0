From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 12:49:01 +0100
Message-ID: <CAOkSjBgmrx3tqDxpa0JdW84UvU6QrGe5b2ieT6xuvcW2c+XDqg@mail.gmail.com>
References: <20140205102547.GA20930@macbook.localnet> <20140205104247.GA4458@localhost>
 <20140205105348.GB21355@macbook.localnet> <20140205111713.GB4660@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47586 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaBELtd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:49:33 -0500
Received: by mail-lb0-f170.google.com with SMTP id u14so218889lbd.29
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2014 03:49:31 -0800 (PST)
In-Reply-To: <20140205111713.GB4660@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 February 2014 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>>
>> I guess an NFPROTO_INET specific reject module that dispatches to
>> the IPv4 and IPv6 versions is the only possibility unless we want
>> to add restrictions (which I don't).
>
> I think that, once the infrastructure to provide expressions per
> family in place, a specific reject for inet is a good idea. It can
> reply depending on the packet family that it sees at _eval(...). I
> don't have any better idea on how to handle this case.

Just wondering if this idea could be reused to allow nft_payload to
fetch ip src/dst in a family independent way, so we can have dual
stacked rules of this kind:

nft add rule inet filter input ip daddr www.example.com accept

or maybe:

nft add rule inet filter input ip daddr { 1.1.1.1 : accept , ::1 : acce=
pt }

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
