From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 12:50:57 +0100
Message-ID: <CAOkSjBhnJ7WZKE-MC8Ej_zq5WadoHcnV8XQcchjkLhPkH7GbsQ@mail.gmail.com>
References: <20140205102547.GA20930@macbook.localnet> <20140205104247.GA4458@localhost>
 <20140205105348.GB21355@macbook.localnet> <20140205111713.GB4660@localhost> <CAOkSjBgmrx3tqDxpa0JdW84UvU6QrGe5b2ieT6xuvcW2c+XDqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52815 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBELvU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:51:20 -0500
Received: by mail-lb0-f173.google.com with SMTP id y6so219816lbh.4
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2014 03:51:17 -0800 (PST)
In-Reply-To: <CAOkSjBgmrx3tqDxpa0JdW84UvU6QrGe5b2ieT6xuvcW2c+XDqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 February 2014 12:49, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
>
> Just wondering if this idea could be reused to allow nft_payload to
> fetch ip src/dst in a family independent way, so we can have dual
> stacked rules of this kind:

I meant dependant,.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
