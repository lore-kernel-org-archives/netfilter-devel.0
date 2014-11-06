From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH v2] nft: don't resolve hostnames by default
Date: Thu, 6 Nov 2014 12:38:28 +0100
Message-ID: <CAOkSjBjGpVfBf+ErLnpXXURnGt1vq9+kHKmwRn9ydF8x9qbVfQ@mail.gmail.com>
References: <20141106080458.24488.47600.stgit@nfdev.cica.es> <20141106103100.GA4783@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:42969 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKFLiu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:38:50 -0500
Received: by mail-la0-f43.google.com with SMTP id ge10so2438001lab.30
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Nov 2014 03:38:48 -0800 (PST)
In-Reply-To: <20141106103100.GA4783@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 November 2014 11:31, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Thu, Nov 06, 2014 at 09:05:28AM +0100, Arturo Borrero Gonzalez wro=
te:
>> This patch changes the behaviour of nft to don't translate IP
>> addresses to hostnames when printing rules.
>
> Thanks. I took over this patch and gave it another spin. Find it
> attached.

Your patch looks fine. Thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
