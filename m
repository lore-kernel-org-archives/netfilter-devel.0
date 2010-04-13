From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Tue, 13 Apr 2010 21:02:49 +0800
Message-ID: <h2h412e6f7f1004130602sbeba6466w198a600253ad447@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	<n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	<1271162669.16881.301.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:64534 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0DMNDk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:03:40 -0400
Received: by iwn35 with SMTP id 35so1846575iwn.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 06:03:40 -0700 (PDT)
In-Reply-To: <1271162669.16881.301.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 13, 2010 at 8:44 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le mardi 13 avril 2010 =C3=A0 19:06 +0800, Changli Gao a =C3=A9crit :
>
> Thats theory. And for sparse arrays, that pro might be true.
> In your case, you prealloc all the array, using more ram than vmalloc=
=2E..
>
> In practice, x86 cpu can access vmalloced() data much faster then
> flex_array_managed data (take a look at all the expensive divides in
> flex code... :'( )
>
> If vmalloc() happens to be slow, it can trivially be extended to use
> huge pages too. It will happen one day, when/if necessary.
>

The current flex_array isn't optimized well. If it is well optimized,
will it be faster than vmalloc()?

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
