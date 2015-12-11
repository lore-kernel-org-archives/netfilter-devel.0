From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: release objects on netns destruction
Date: Fri, 11 Dec 2015 09:33:20 +0100
Message-ID: <CAOkSjBin2WoyFtp6aDOh1fHFHS4cfCKotaqy7m0Y8epY_GMgUA@mail.gmail.com>
References: <1449690931-1617-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38197 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbLKIdl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 03:33:41 -0500
Received: by wmec201 with SMTP id c201so59453460wme.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Dec 2015 00:33:40 -0800 (PST)
In-Reply-To: <1449690931-1617-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 December 2015 at 20:55, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> We have to release the existing objects on netns removal otherwise we
> leak them. Chains are unregistered in first place to make sure no
> packets are walking on our rules and sets anymore.
>
> Reported-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: Unregister chains in first place to make sure no packets are walk=
ing
>     over rules and sets anymore.
>
>  net/netfilter/nf_tables_api.c | 43 +++++++++++++++++++++++++++++++++=
+++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
>

I've run a kernel with this patch, did some tests regarding netns and
nftables, and found no problems so far :-)

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
