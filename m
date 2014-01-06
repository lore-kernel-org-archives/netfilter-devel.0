From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] parsing: add interface to parse from file
Date: Mon, 6 Jan 2014 13:06:04 +0100
Message-ID: <CAOkSjBgJDk_06xvJjX+X4SaThuGZk5NRNGhxkOpATAyUKXrRoA@mail.gmail.com>
References: <20140103123145.27058.77216.stgit@nfdev.cica.es> <20140104011333.GA5250@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira <alvaroneay@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41068 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaAFMG0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:06:26 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so9693418lbi.40
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 04:06:24 -0800 (PST)
In-Reply-To: <20140104011333.GA5250@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 January 2014 02:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> In this case, I'd like to see something like a changeset composed of
> three patches.
>

Ok!

>
> perhaps you can call all this function _parse_file(...) instead.
>

of course.

>
> Alvaro's patch is also changing the internal.h file. You need to
> coordinate since you're working on the parsing infrastructure at the
> same time to avoid clashing on this, otherwise the patch coming later
> won't apply and one of you will have to rework it.

I think Alvaro's patch should come first, as he was already working on
this previous to my patch.

I will wait until alvaro's one is applied to make the refresh.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
