From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 16:40:35 +0000
Message-ID: <20141212164034.GA3237@acer.localdomain>
References: <54885B08.1010700@c-s.fr>
 <20141210182244.GA5622@salvia>
 <548AC07D.6080703@c-s.fr>
 <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
 <548ACC89.5060700@c-s.fr>
 <CAOkSjBiDnZPHyGoHy+zmA9Kc957KfxRd6U86J+B21124i4Z5jA@mail.gmail.com>
 <548AE5A5.8020104@c-s.fr>
 <20141212152523.GI8013@acer.localdomain>
 <548B15DB.70707@c-s.fr>
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
Received: from stinky.trash.net ([213.144.137.162]:63410 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbaLLQkk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:40:40 -0500
Content-Disposition: inline
In-Reply-To: <548B15DB.70707@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.12, leroy christophe wrote:
> Le 12/12/2014 16:25, Patrick McHardy a =E9crit :
> >On 12.12, leroy christophe wrote:
> >>Le 12/12/2014 12:55, Arturo Borrero Gonzalez a =E9crit :
> >>>On 12 December 2014 at 12:07, leroy christophe <christophe.leroy@c=
-s.fr> wrote:
> >>I'm not sure what I proposed it the correct patch, maybe it shall b=
e fixed
> >>earlier in the chain, I don't know.
> >Yeah, I'm not so sure myself.
> >
> >Could you please try what happens if you do:
> >
> >... tcp dport 222 redir :tcp dport
> >
> >Which should redirect to the same port, but I'm interested if it
> >actually does that.
> >
> Without my patch, I get the following. Note the strange value in the =
DPT on
> the second line.
>=20
> [   61.377273] redirIN=3Deth0 OUT=3D
> MAC=3D08:00:51:20:44:5b:08:00:27:fe:42:1e:08:00 SRC=3D172.25.231.37
> DST=3D172.25.231.5 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2912=
2 DF PROTO=3DTCP
> SPT=3D55626 DPT=3D222 WINDOW=3D14600 RES=3D0x00 SYN URGP=3D0
> [   61.377816] rejected IN=3Deth0 OUT=3D
> MAC=3D08:00:51:20:44:5b:08:00:27:fe:42:1e:08:00 SRC=3D172.25.231.37
> DST=3D172.25.231.5 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2912=
2 DF PROTO=3DTCP
> SPT=3D55626 DPT=3D20 WINDOW=3D14600 RES=3D0x00 SYN URGP=3D0

Strange, not sure why it is 20.

> With my patch, I get correct port.
>=20
> [  511.994597] redirIN=3Deth0 OUT=3D
> MAC=3D08:00:51:20:44:5b:08:00:27:fe:42:1e:08:00 SRC=3D172.25.231.37
> DST=3D172.25.231.5 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2130=
0 DF PROTO=3DTCP
> SPT=3D55622 DPT=3D222 WINDOW=3D14600 RES=3D0x00 SYN URGP=3D0
> [  511.994999] rejected IN=3Deth0 OUT=3D
> MAC=3D08:00:51:20:44:5b:08:00:27:fe:42:1e:08:00 SRC=3D172.25.231.37
> DST=3D172.25.231.5 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2130=
0 DF PROTO=3DTCP
> SPT=3D55622 DPT=3D222 WINDOW=3D14600 RES=3D0x00 SYN URGP=3D0

Thanks! I'll have another look later, but it seems your patch is fine.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
