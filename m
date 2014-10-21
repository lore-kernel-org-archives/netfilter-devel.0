From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH v3] utils: fix arp family number
Date: Tue, 21 Oct 2014 10:53:19 +0200
Message-ID: <CAOkSjBgmmE0MUPY10u1iOKgBsN4P3y9mLM3FHcMzA7hL3maP8Q@mail.gmail.com>
References: <20141020115049.27980.35459.stgit@nfdev.cica.es> <20141021075927.GA3610@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42718 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaJUIxl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:53:41 -0400
Received: by mail-lb0-f182.google.com with SMTP id z11so599629lbi.27
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 01:53:39 -0700 (PDT)
In-Reply-To: <20141021075927.GA3610@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 October 2014 09:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> BTW, it would be good to see a similar refactor in nft_verdict2str().

I don't see a clean way to do it, given some verdicts are negative
numbers (enum nft_verdicts in nf_tables.h).
We may end accessing a negative index, out of bounds of the array.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
