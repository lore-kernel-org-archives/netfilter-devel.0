From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] netfilter: nft_redir: fix sparse warnings: cast to
 restricted __be32
Date: Wed, 12 Nov 2014 13:01:47 +0100
Message-ID: <CAOkSjBiQ8z2QBJT+P=QSN=4MVfJV8GuC=MgOzt+sCOYTzTAEVA@mail.gmail.com>
References: <20141112111039.323.26439.stgit@nfdev.cica.es> <20141112115651.GA32330@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:59885 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaKLMCJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:02:09 -0500
Received: by mail-la0-f42.google.com with SMTP id gq15so11242136lab.15
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2014 04:02:08 -0800 (PST)
In-Reply-To: <20141112115651.GA32330@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 November 2014 12:56, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>
> Thanks Arturo.
>
> I already sent a patch, I prefer to get rid of this variable for
> consistency with other nft nat-like expressions.

Sure, I just wasn't aware of your patch when sending mine.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
