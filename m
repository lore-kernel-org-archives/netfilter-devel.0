From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables with ipset combined types
Date: Wed, 29 Jan 2014 12:48:04 +0100
Message-ID: <CAOkSjBjyZh9EcbExmzpYH_WkjOfpWH2Voggy0khyWsMNcHq8MQ@mail.gmail.com>
References: <52E8AD76.5050808@aim.com> <20140129093010.GA4332@localhost> <24843182.8UhhjTCEZr@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45482 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaA2Ls0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:48:26 -0500
Received: by mail-lb0-f173.google.com with SMTP id y6so1380036lbh.32
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2014 03:48:25 -0800 (PST)
In-Reply-To: <24843182.8UhhjTCEZr@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29 January 2014 12:34, Patrick Schaaf <netdev@bof.de> wrote:
>
> If I'm not mistaken, sets in nftables are right now scoped within a t=
able,
> so I could not reuse them in that fashion.
>

AFAIK, by now this is true.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
