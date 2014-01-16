From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] ct: fix key and dir requirements
Date: Thu, 16 Jan 2014 21:46:17 +0100
Message-ID: <CAOkSjBhOb=Z_-KDfpmRko7Vi-U4QVhYUJwkJ1FbDpLjEVD3teA@mail.gmail.com>
References: <20140115181939.25239.19905.stgit@nfdev.cica.es> <20140116180538.GA18501@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:57777 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaAPUqj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:46:39 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so3014029lab.9
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2014 12:46:38 -0800 (PST)
In-Reply-To: <20140116180538.GA18501@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 January 2014 19:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> The kernel will complain if we pass invalid combinations, I don't wan=
t
> to have this early validation code in the library.
>

The problem is that as far as I've tested, the kernel  unconditionally
returns 'dir' [0].
If we print in XML/JSON the data obtained from the kernel, <dir> is
also printed, while it may be totally undesirable (for example, for a
latter parsing of that XML/JSON meant to be resended to the kernel).
I think we need this check, in libnftables or nft.

I don't see the point of allowing such a disruptive combination of attr=
ibutes.

We already have similar checks in other objects to disallow invalid
combinations, see [1] [2].

What do you think?

>
> Not related to this patch, but better I prefer if you use:
> nft_rule_expr_set_u8(...) instead of these two lines above.
>

I agree. But I think it would be better if all ops are of the same kind=
=2E
So I will patch all non-shorcuts ops like this all around libnftables,
unless you say otherwise, before this patch.


regards

[0] http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/tree=
/net/netfilter/nft_ct.c#n306
[1] http://git.netfilter.org/libnftables/tree/src/chain.c#n48
[2] http://git.netfilter.org/libnftables/tree/src/expr/bitwise.c#n269
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
