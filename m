From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH libnftables] examples: nft-rule-add: use existing batch
 infrastructure
Date: Thu, 02 Jan 2014 01:26:58 +0100
Message-ID: <1388622418.3787.32.camel@ice-age2.regit.org>
References: <1386695918-3623-1-git-send-email-pablo@netfilter.org>
	 <1388615980.3787.27.camel@ice-age2.regit.org>
	 <CAOkSjBj7i8J9kDoW--QkFeq8bU8f5USFSyDefXg6CmOU1AGaNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:52096 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaABA1F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jan 2014 19:27:05 -0500
In-Reply-To: <CAOkSjBj7i8J9kDoW--QkFeq8bU8f5USFSyDefXg6CmOU1AGaNw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, 2014-01-02 at 01:06 +0100, Arturo Borrero Gonzalez wrote:
>=20
> El 01/01/2014 23:39, "Eric Leblond" <eric@regit.org> escribi=F3:
> >
> > I don't see this patch in any of the branch. Is there any issue wit=
h
> > it ?
> >
> > It seems really useful as existing examples are using really old
> code.
> >
>=20
> I think you are looking for
> http://git.netfilter.org/libnftables/commit/examples/nft-rule-add.c?i=
d=3D0b3161731262d3a8c6110c17fd818af325dbf491

Indeed! Sorry for the noise.

New year resolution: double check my git commands before mailing ;)

BR,
--=20
Eric Leblond <eric@regit.org>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
