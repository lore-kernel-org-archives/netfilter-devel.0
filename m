From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 10:23:31 +0200
Message-ID: <CAOkSjBjezoobHAqOpL9oNz1hPJ+6P-+ebNeUBkgOVo1Ni-xzHA@mail.gmail.com>
References: <20160530194748.GA25328@sonyv> <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
 <20160530224104.GA2199@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34082 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbcEaIXw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 04:23:52 -0400
Received: by mail-wm0-f45.google.com with SMTP id z87so20338368wmh.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 01:23:51 -0700 (PDT)
In-Reply-To: <20160530224104.GA2199@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 May 2016 at 00:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is not yet supported. This requires a small kernel patch to allo=
w
> inversions in the nft_lookup.c. Then, the little extra code for
> libnftnl and nft.
>
> All tests for this usecase are disabled at the moment.

What is your idea of the implementation?

Perhaps adding NFTA_LOOKUP_FLAGS and also:
enum nft_lookup_flags {
   NFT_LOOKUP_F_INV =3D (1 << 0),
};


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
