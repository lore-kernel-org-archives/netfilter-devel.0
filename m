From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] src: add fprintf functions
Date: Thu, 17 Oct 2013 15:13:46 +0200
Message-ID: <CAOkSjBiPTpn+vMvyRJDZ2emspGMqGcQZSp_AQkZzQyUHQvCePg@mail.gmail.com>
References: <20131016171437.27537.1477.stgit@nfdev.cica.es> <20131017101101.GA10727@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60771 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3JQNOI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:14:08 -0400
Received: by mail-lb0-f173.google.com with SMTP id o14so1903930lbi.32
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2013 06:14:06 -0700 (PDT)
In-Reply-To: <20131017101101.GA10727@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 October 2013 12:11, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> For set and ruleset objects, this branch is very likely to happen,
> since it is very likely that the buffer will be too small. To avoid
> this, I think it's better to provide an optimized version for this
> function that iterates over the list of objects and print them.

All ACK, I will send v2.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
