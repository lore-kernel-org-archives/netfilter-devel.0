From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Mon, 3 Nov 2014 20:42:13 +0100
Message-ID: <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es> <20141030162520.GA2074@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43679 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKCTmf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:42:35 -0500
Received: by mail-lb0-f171.google.com with SMTP id b6so1943124lbj.16
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 11:42:33 -0800 (PST)
In-Reply-To: <20141030162520.GA2074@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 October 2014 17:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Thu, Oct 16, 2014 at 12:41:19PM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch adds redirect support for nft.
>>
>> The syntax is:
>>
>>  % nft add rule nat prerouting redirect [port|nat_flags]
>
> I prefer if you add a couple of valid examples to the patch
> description. This won't work as the protocol is not specified.
>
> There's also some minor issues with this patch:
>
> % nft add rule nat prerouting redirect
> Memory allocation failure
>
> Please, address and resubmit, thanks Arturo.

Hi Pablo,

I've take further look at this patch. I don't see any issue.

As masquerade, I think redirect without protocol should work. I just
tested again the patch with ICMP packets and the redirection simply
works. I used tcpdump for the checks. The rule I used is the same as
in the patch description.

Regarding the memory allocation failure, I'm unable to find the issue.
Do you think is related to this patch? I just added thousands of
redirect rules in both IPv4 and IPv6 with no failures nor leakages
reported by valgrind.

I would request you a bit more info, please.

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
