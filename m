From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH] netfilter: nf_tables: invert chain deletion
 abort path
Date: Thu, 28 Apr 2016 10:55:56 +0200
Message-ID: <CAOkSjBiyaiG6PrVyq3A+43-AcPaAigQfR5ByNNbgtqu=v93MJg@mail.gmail.com>
References: <146011296985.3580.3314850969369156279.stgit@nfdev2.cica.es> <20160414102434.GA2905@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37887 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbcD1I4R convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 04:56:17 -0400
Received: by mail-wm0-f46.google.com with SMTP id a17so53356630wme.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 01:56:16 -0700 (PDT)
In-Reply-To: <20160414102434.GA2905@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 April 2016 at 12:24, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>
> Thanks for coming up with this Arturo.
>
> I have a better way to fix this by not adding/removing the objects to
> the lists.
>
> Ping me back if I don't come up with the fix anytime soon.

ping :-)

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
