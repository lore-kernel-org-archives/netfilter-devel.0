From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 12:55:09 +0100
Message-ID: <CAOkSjBiDnZPHyGoHy+zmA9Kc957KfxRd6U86J+B21124i4Z5jA@mail.gmail.com>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia>
 <548AC07D.6080703@c-s.fr> <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
 <548ACC89.5060700@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	GUITTON Alex <alex.guitton@c-s.fr>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:65215 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333AbaLLLzb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:55:31 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so5798327lab.40
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2014 03:55:29 -0800 (PST)
In-Reply-To: <548ACC89.5060700@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 December 2014 at 12:07, leroy christophe <christophe.leroy@c-s.fr=
> wrote:
>
> Le 12/12/2014 11:49, Arturo Borrero Gonzalez a =C3=A9crit :
>>
>> With nft_nat and nft_redir_ipv6, the three code are almost the same:
>>
>>
>> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/n=
et/netfilter/nft_nat.c
>>
>> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/n=
et/ipv6/netfilter/nft_redir_ipv6.c
>>
>> Since it seems the same issue may appear, would you like to patch al=
l of
>> them?
>>
>> regards.
>
> Hi,
>
> Yes the issue is most likely the same, so I believe it should also be=
 fixed
> there.
>

BTW, please send your patches to netfilter-devel. No need to CC
netfilter@vger.kernel.org.
Patches should include the Signed-off-by line (please be sure they
apply with git am).

Thanks, regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
