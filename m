From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 12:07:53 +0100
Message-ID: <548ACC89.5060700@c-s.fr>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia> <548AC07D.6080703@c-s.fr> <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	GUITTON Alex <alex.guitton@c-s.fr>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:28953 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965849AbaLLLH4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:07:56 -0500
In-Reply-To: <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Le 12/12/2014 11:49, Arturo Borrero Gonzalez a =C3=A9crit :
> With nft_nat and nft_redir_ipv6, the three code are almost the same:
>
> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/ne=
t/netfilter/nft_nat.c
> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/ne=
t/ipv6/netfilter/nft_redir_ipv6.c
>
> Since it seems the same issue may appear, would you like to patch all=
 of them?
>
> regards.
Hi,

Yes the issue is most likely the same, so I believe it should also be=20
fixed there.

Christophe
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
