From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: BUG: Kernel panic at masquerade
Date: Fri, 9 Jan 2015 23:02:10 +0100
Message-ID: <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
References: <54B048D1.6040009@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Linke <linkerpro@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:65435 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbAIWCc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:02:32 -0500
Received: by mail-la0-f46.google.com with SMTP id q1so16786999lam.5
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jan 2015 14:02:30 -0800 (PST)
In-Reply-To: <54B048D1.6040009@mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 January 2015 at 22:32, Linke <linkerpro@mail.ru> wrote:
> Hello,
>
> I'm stable receive a kernel panic in this ruleset:
>
> nft add table firewall
> nft add chain firewall prerouting {type nat hook prerouting priority =
0\;}
> nft add rule firewall prerouting masquerade
>
>
> trying at Archlinux
>
> official latest 3.18-grsec kernel
> and AUR 3.19.0-rc3-gbdec419 (builded from git.kernel.org)
>

Why are you using masquerade in a prerouting hook? It only makes sense
in postrouting. Is a case I've not tested.

Anyway, that should not happen. I will investigate.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
