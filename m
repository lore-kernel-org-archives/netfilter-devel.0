From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC][PATCH] nftables: add slash to chain syntax
Date: Wed, 4 Dec 2013 16:16:21 +0100
Message-ID: <CAOkSjBhfM+r-Jc8wvExEvUGYEHWDBTDBf-c4_e9-v4RfmjQJZQ@mail.gmail.com>
References: <20131130232022.GA23206@home> <20131130232248.GA23209@home> <20131204140547.GA9643@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61461 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDPQn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:16:43 -0500
Received: by mail-lb0-f169.google.com with SMTP id y6so9445793lbh.14
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2013 07:16:41 -0800 (PST)
In-Reply-To: <20131204140547.GA9643@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 December 2013 15:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> The > symbol in the bash shell, if not escaped, results in a
> redirection. We could replace it by ':', so the maps will look like:
>
> add rule ip filter OUTPUT tcp dport vmap { \
>         22 : jump chain1, \
>         23 : jump chain2, \
> }
>
> Just in case we consider it worth to make it easier to run nft
> commands from the bash shell.

I totally like this approach.

Why not to ease the life of bash users? I guess they are many :-)
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
