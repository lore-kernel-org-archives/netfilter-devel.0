From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 15:25:24 +0000
Message-ID: <20141212152523.GI8013@acer.localdomain>
References: <54885B08.1010700@c-s.fr>
 <20141210182244.GA5622@salvia>
 <548AC07D.6080703@c-s.fr>
 <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
 <548ACC89.5060700@c-s.fr>
 <CAOkSjBiDnZPHyGoHy+zmA9Kc957KfxRd6U86J+B21124i4Z5jA@mail.gmail.com>
 <548AE5A5.8020104@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	GUITTON Alex <alex.guitton@c-s.fr>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030334AbaLLPZ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:29 -0500
Content-Disposition: inline
In-Reply-To: <548AE5A5.8020104@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.12, leroy christophe wrote:
> Le 12/12/2014 12:55, Arturo Borrero Gonzalez a =E9crit :
> >On 12 December 2014 at 12:07, leroy christophe <christophe.leroy@c-s=
=2Efr> wrote:
> I'm not sure what I proposed it the correct patch, maybe it shall be =
fixed
> earlier in the chain, I don't know.

Yeah, I'm not so sure myself.

Could you please try what happens if you do:

=2E.. tcp dport 222 redir :tcp dport

Which should redirect to the same port, but I'm interested if it
actually does that.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
