From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next PATCH v4] netfilter: nf_tables: add support for inverted
 logic in nft_lookup
Date: Thu, 23 Jun 2016 09:32:24 +0200
Message-ID: <CAOkSjBj9iKfOAimqNkKGutkr2XnUCH76PZ-ZjQngv6S+8LqZhg@mail.gmail.com>
References: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es> <20160622182230.GD8772@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38164 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbcFWHcp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 03:32:45 -0400
Received: by mail-wm0-f44.google.com with SMTP id r201so36394905wme.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 00:32:44 -0700 (PDT)
In-Reply-To: <20160622182230.GD8772@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 June 2016 at 20:22, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Wed, Jun 01, 2016 at 05:23:02PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Introduce a new configuration option for this expression, which allo=
ws users
>> to invert the logic of set lookups.
>
> Any plan to add the missing nftables bits? Let me know, I would like
> to have all the pieces in places so we can also add automated tests
> for this.

Eventually yes, but not in the short term.


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
