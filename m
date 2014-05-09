From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] internal: fix SNPRINTF_BUFFER_SIZE macro
Date: Fri, 9 May 2014 18:32:33 +0200
Message-ID: <CAOkSjBiC7w8XgMFt9w+6dJdu_2jQdOFe5T0eQC5-ZBtR-c5qyQ@mail.gmail.com>
References: <20140509115806.2467.11788.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:44900 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaEIQcz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 12:32:55 -0400
Received: by mail-la0-f48.google.com with SMTP id mc6so47548lab.35
        for <netfilter-devel@vger.kernel.org>; Fri, 09 May 2014 09:32:54 -0700 (PDT)
In-Reply-To: <20140509115806.2467.11788.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 May 2014 13:58, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> We need to store in 'offset' the complete amount of characters as ret=
urned
> from _snprintf. The value means how many characters long needs the bu=
ffer to be
> in order to store the corresponding string expansion.
>
> Before this patch, in cases where the buffer is smaller than the
> expansion, then ret > len, and therefore ret =3D len.
> So when incrementing offset, we do it with a wrong value.
>
> All previous versions of libnftnl are unable to handle this situation=
s: small
> buffers (or long string expansion).
>
> BTW, if a caller must reallocate a buffer to the returned value of sn=
printf, it
> should be ret + 1.
>

About this issue:

We use mostly fprintf() functions in our test infrastructure. While
_fprintf() functions use internally _snprintf() [0] (thus, allocating
a 4096 sized buffer in the stack), this is done *per object*. A single
object hardly can contain more than 4096 characters when
string-expanded (either JSON or XML).

Also, this problem arises strongly with a big nft_ruleset printed with
nft_ruleset_snprintf(), because there no single buffer is allocated
per object. OTOH, printing the same nft_ruleset with
nft_ruleset_fprintf() will result again in allocating single buffers
per object [1].

Regarding the reallocation [2] of ret + 1, that fix will come in a
different patch. The example provided in the snprintf(3) manpage also
reallocs with +1, as snprintf adds a trailing \0.

regards.

[0] http://git.netfilter.org/libnftnl/tree/src/utils.c#n188
[1] http://git.netfilter.org/libnftnl/tree/src/ruleset.c#n970
[2] http://git.netfilter.org/libnftnl/tree/src/utils.c#n199
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
