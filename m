From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] tests: shell: cover transactions via nft -f using
 flat syntax
Date: Wed, 22 Jun 2016 16:16:27 +0200
Message-ID: <CAOkSjBjZsn5ePJynyjdaEorcQHrQm4uo+62D7hZKJrdvvecFVg@mail.gmail.com>
References: <1466594336-24231-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35551 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbcFVORB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 10:17:01 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so1557819wme.2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 07:16:54 -0700 (PDT)
In-Reply-To: <1466594336-24231-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 June 2016 at 13:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> This patch covers transactions using the flat syntax representation, =
eg.
>
>         add table x
>         add chain x y { type filter hook forward priority 0; }
>         add chain x y { policy drop; }
>
> This also covers things like:
>
>         add element x whitelist { 1.1.1.1 }
>         delete element x whitelist { 1.1.1.1 }
>
> The one above may look silly from a human behaviour point of view, bu=
t
> silly robots may very well behave like this.
>
> These tests require several kernel patches though in order to pass
> successfully.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I reviewed most of the testscases and they seem fine to me,

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Side note:

if you execute some of them without the kernel patches (so they fail),
a segfault happens in nft (I guess related to cache handling).

W: [FAILED] ./testcases/transactions/0037set_0: expected 0 but got 139
=2E/testcases/transactions/0037set_0: line 19: 15139 Segmentation fault
    $NFT -f $tmpfile
W: [FAILED] ./testcases/transactions/0038set_0: expected 0 but got 139
=2E/testcases/transactions/0038set_0: line 21: 15151 Segmentation fault
    $NFT -f $tmpfile
W: [FAILED] ./testcases/transactions/0039set_0: expected 0 but got 139
=2E/testcases/transactions/0039set_0: line 21: 15163 Segmentation fault
    $NFT -f $tmpfile



--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
