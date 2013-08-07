From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] table: add nft_table_list_del function
Date: Wed, 7 Aug 2013 11:55:16 +0200
Message-ID: <CAOkSjBgfM=Bf6yNHZFpV=jcCKGc1R=_a5MprtkP46j-4Un7f-Q@mail.gmail.com>
References: <20130801124546.13382.18859.stgit@nfdev.cica.es> <20130807094406.GA830@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:39119 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3HGJzi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:55:38 -0400
Received: by mail-la0-f42.google.com with SMTP id mf11so1070147lab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2013 02:55:37 -0700 (PDT)
In-Reply-To: <20130807094406.GA830@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 August 2013 11:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Arturo,
>
> On Thu, Aug 01, 2013 at 02:45:46PM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch adds the function nft_table_list_del(), that allows to de=
lete
>> elements from a struct nft_table_list.
>
> Do you need this? Otherwise, you know that I'm reticent to add
> new interfaces that we don't need at this moment.
>
> If you indeed need it, please add it to other objects as well. Thanks=
=2E

Yes, I'm using this in an incoming example for libnftables.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
