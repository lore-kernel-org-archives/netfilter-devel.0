From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables/libnftables packages for Fedora
Date: Wed, 15 Jan 2014 11:18:04 +0100
Message-ID: <CAOkSjBh=L4PMOEG6tYgUf7JOOFjvk+K1pEwAx=v7t4zyzAUY7A@mail.gmail.com>
References: <20140112134024.2475a4f2@voldemort.scrye.com> <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
 <20140112171116.46eaf896@voldemort.scrye.com> <20140115095330.GA4855@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kevin Fenzi <kevin@scrye.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43563 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAOKSZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:18:25 -0500
Received: by mail-la0-f42.google.com with SMTP id n7so1242131lam.15
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 02:18:24 -0800 (PST)
In-Reply-To: <20140115095330.GA4855@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2014 10:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> @Arturo: please investigate this issue as the first release is coming
> soon, otherwise we'll have to restrict xml support to one of the
> libmxml versions. I think it would be better if libnftables supports
> latest version of libmxml as it's the natural move on most
> distributions to pack the last software version. Moreover, it would b=
e
> good to contact the author to know if he has plans to keep a stable
> API/ABI in upcoming releases of libmxml, this is very important for
> third party software.

Sure,

I plan to make the required changes in libnftables to support the
latest version of libmxml.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
