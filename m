From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 1/2] src: add _unset functions
Date: Thu, 6 Jun 2013 12:35:01 +0200
Message-ID: <CAOkSjBi5B8pHLF2+Kt3eqL71+jqNXWJOJHPq6FZ+O4Wti+TBzQ@mail.gmail.com>
References: <20130605213713.11415.64106.stgit@nfdev.cica.es> <20130606101508.GA5947@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33571 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3FFKfX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:35:23 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so2424455lab.28
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 03:35:21 -0700 (PDT)
In-Reply-To: <20130606101508.GA5947@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/6/6 Pablo Neira Ayuso <pablo@netfilter.org>:
>
> To unset, use:
>
> x->flags &=3D ~(1 << attr)

Nice. I'm with v2.

What about the data being freed? Is that desirable?


--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
